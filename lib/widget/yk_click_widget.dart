import 'package:flutter/material.dart';

class YkClickWidget extends StatefulWidget {
  final void Function() onTap;
  final Widget child;
  final bool needFilter;

  // 可以自定义防连点的时间间隔，默认1000毫秒
  final int interval;
  final void Function()? onDoubleTap;

  const YkClickWidget({
    super.key,
    required this.onTap,
    required this.child,
    this.needFilter = true,
    this.interval = 1000,
    this.onDoubleTap,
  });

  @override
  State<YkClickWidget> createState() => _YkClickWidgetState();
}

class _YkClickWidgetState extends State<YkClickWidget> {
  // 把点击时间戳放到State类中，保留状态
  int _clickTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () {
        widget.onDoubleTap?.call();
      },
      onTap: () {
        // 获取当前时间戳
        final int currentTime = DateTime.now().millisecondsSinceEpoch;
        // 判断是否需要过滤连点，默认需要
        final bool needCheck = widget.needFilter;

        if (needCheck) {
          // 检查时间间隔是否大于设定的interval（默认1000ms）
          if (currentTime - _clickTime > widget.interval) {
            widget.onTap();
            // 更新上一次点击的时间戳
            _clickTime = currentTime;
          }
        } else {
          // 不需要过滤时直接触发
          widget.onTap();
        }
      },
      child: widget.child,
    );
  }
}
