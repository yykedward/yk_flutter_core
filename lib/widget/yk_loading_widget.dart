import 'package:flutter/material.dart';

class YkLoadingWidget<T> extends StatelessWidget {
  final Future<T> initFuture;

  final Widget Function(BuildContext context, T? t) widgetBuilder;

  Widget? loadingWidget;

  YkLoadingWidget({super.key, required this.initFuture, required this.widgetBuilder, this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return widgetBuilder(context, snapshot.data);
          } else {
            if (this.loadingWidget != null) {
              return this.loadingWidget!;
            }
            return SizedBox(width: 100, height: 100, child: const Center(child: CircularProgressIndicator()));
          }
        });
  }
}
