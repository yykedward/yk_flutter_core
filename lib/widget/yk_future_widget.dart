import 'package:flutter/material.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkFutureWidget<T> extends StatelessWidget {
  final Future<T> initFuture;

  final Widget Function(BuildContext context, T t) widgetBuilder;

  const YkFutureWidget(
      {super.key, required this.initFuture, required this.widgetBuilder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return YkCoreInfo.emptyWidget;
            }
            return widgetBuilder(context, snapshot.data as T);
          } else {
            return YkCoreInfo.loadingWidget;
          }
        });
  }
}
