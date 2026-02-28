import 'package:flutter/material.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkFutureWidget<T> extends StatelessWidget {
  final Future<T> initFuture;

  final Widget Function(BuildContext context, T t) widgetBuilder;

  final Widget? loadingWidget;
  final Widget? emptyWidget;

  const YkFutureWidget({super.key, required this.initFuture, required this.widgetBuilder, this.loadingWidget, this.emptyWidget});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return emptyWidget ?? YkCoreInfo.emptyWidget;
            }
            return widgetBuilder(context, snapshot.data as T);
          } else {
            return loadingWidget ?? YkCoreInfo.loadingWidget;
          }
        });
  }
}
