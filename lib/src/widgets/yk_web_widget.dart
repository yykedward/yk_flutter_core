import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// H5 JS 通道消息处理器
///
/// [message] 为 H5 通过 `window.<handlerName>.postMessage(...)` 发来的消息；
/// [reply] 用于向 H5 回调，传入的字符串会作为 JS 代码在当前页面中执行。
typedef YkJsMessageHandler = FutureOr<void> Function(
  String message,
  void Function(String javaScript) reply,
);

/// WebView 全局配置
///
/// 在 App 启动时配置一次即可，对所有 [YkWebWidget] 生效；
/// 单个页面需要覆盖进度条颜色时，通过 [YkWebWidgetController] 设置。
class YkWebViewConfig {
  YkWebViewConfig._();

  static final YkWebViewConfig instance = YkWebViewConfig._();

  /// 全局 User-Agent 定制回调：入参为当前 UA，返回 null 表示不做修改
  String? Function(String? userAgent)? userAgentCallback;

  /// 拦截到需要交给系统处理的跳转（如支付宝、非 http 协议）时触发
  void Function(Uri uri)? externalNavigationCallback;

  /// 加载进度条颜色（全局默认）
  Color? progressColor;

  /// 加载进度条背景色（全局默认）
  Color? progressBackgroundColor;
}

/// [YkWebWidget] 的控制器
///
/// 用于注册 JS 通道、覆盖进度条颜色，以及在 widget 外部控制网页加载。
class YkWebWidgetController {
  final Map<String, YkJsMessageHandler> _jsHandlers = {};

  WebViewController? _webController;

  /// 覆盖全局配置的进度条颜色
  Color? progressColor;

  /// 覆盖全局配置的进度条背景色
  Color? progressBackgroundColor;

  /// 注册一个 JS 通道，H5 侧通过 `window.<handlerName>.postMessage()` 调用
  void registerJsHandler(String handlerName, YkJsMessageHandler handler) {
    _jsHandlers[handlerName] = handler;
  }

  /// 加载 [url]，需在 [YkWebWidget] 挂载后调用
  void loadUrl(String url) {
    _webController?.loadRequest(Uri.parse(url));
  }

  /// 重新加载当前页面
  Future<void> reload() async {
    await _webController?.reload();
  }

  /// 在当前页面执行一段 JS 代码
  Future<void> evaluate(String javaScript) async {
    await _webController?.runJavaScript(javaScript);
  }

  /// 当前页面是否可以后退
  Future<bool> canGoBack() async {
    return await _webController?.canGoBack() ?? false;
  }

  /// 后退一页，不可后退时为空操作
  Future<void> goBack() async {
    if (await canGoBack()) {
      await _webController?.goBack();
    }
  }

  /// 由 [_YkWebWidgetState] 在挂载时绑定底层控制器
  void _bind(WebViewController webController) {
    _webController = webController;
  }

  /// 由 [_YkWebWidgetState] 在销毁时解绑
  void _unbind() {
    _webController = null;
  }
}

/// 基于 webview_flutter 封装的网页组件，自带顶部加载进度条
///
/// - 非挂载期内的跳转拦截、UA 定制见 [YkWebViewConfig]
/// - JS 通道注册与进度条颜色覆盖见 [YkWebWidgetController]
class YkWebWidget extends StatefulWidget {
  const YkWebWidget({
    super.key,
    required this.url,
    this.controller,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
  });

  /// 初始加载的页面地址，widget 更新时地址变化会自动重新加载
  final String url;

  /// 可选控制器，用于注册 JS 通道、覆盖进度条颜色、控制加载
  final YkWebWidgetController? controller;

  /// 页面开始加载时回调
  final void Function(String url)? onPageStarted;

  /// 页面加载完成时回调
  final void Function(String url)? onPageFinished;

  /// 页面资源加载出错时回调
  final void Function(WebResourceError error)? onWebResourceError;

  @override
  State<YkWebWidget> createState() => _YkWebWidgetState();
}

class _YkWebWidgetState extends State<YkWebWidget> {
  final WebViewController _webController = WebViewController();
  final ValueNotifier<double> _progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  /// 初始化控制器。
  ///
  /// JS 通道必须在 [WebViewController.loadRequest] 之前注册，
  /// 否则页面早期的桥调用会丢失；UA 也需在首次加载前设置。
  Future<void> _setupController() async {
    widget.controller?._bind(_webController);

    _webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) => _progress.value = progress / 100,
        onPageStarted: (String url) => widget.onPageStarted?.call(url),
        onPageFinished: (String url) => widget.onPageFinished?.call(url),
        onWebResourceError: (WebResourceError error) =>
            widget.onWebResourceError?.call(error),
        onNavigationRequest: _onNavigationRequest,
      ));

    for (final entry
        in (widget.controller?._jsHandlers ?? const <String, YkJsMessageHandler>{})
            .entries) {
      _webController.addJavaScriptChannel(entry.key,
          onMessageReceived: (JavaScriptMessage message) {
        entry.value(message.message, _runJavaScript);
      });
    }

    final userAgentCallback = YkWebViewConfig.instance.userAgentCallback;
    if (userAgentCallback != null) {
      final userAgent = await _webController.getUserAgent();
      final newUserAgent = userAgentCallback(userAgent);
      if (newUserAgent != null) {
        await _webController.setUserAgent(newUserAgent);
      }
    }

    await _webController.loadRequest(Uri.parse(widget.url));
  }

  void _runJavaScript(String javaScript) {
    unawaited(_webController.runJavaScript(javaScript).catchError((Object _) {}));
  }

  /// 非 http(s) 协议（about: 除外）或支付相关域名，交由系统处理
  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    final url = request.url;
    final isExternal = (!url.startsWith('http') && !url.contains('about:')) ||
        url.contains('openapi.alipay.com');
    if (isExternal) {
      YkWebViewConfig.instance.externalNavigationCallback?.call(Uri.parse(url));
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  void didUpdateWidget(covariant YkWebWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _webController.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  void dispose() {
    widget.controller?._unbind();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<double>(
          valueListenable: _progress,
          builder: (BuildContext context, double progress, Widget? child) {
            if (progress == 0 || progress == 1) {
              return const SizedBox.shrink();
            }
            final config = YkWebViewConfig.instance;
            final backgroundColor =
                widget.controller?.progressBackgroundColor ??
                    config.progressBackgroundColor;
            final color =
                widget.controller?.progressColor ?? config.progressColor;
            return LinearProgressIndicator(
              value: progress,
              backgroundColor: backgroundColor,
              valueColor: color == null
                  ? null
                  : AlwaysStoppedAnimation<Color>(color),
            );
          },
        ),
        Expanded(child: WebViewWidget(controller: _webController)),
      ],
    );
  }
}
