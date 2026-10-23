import 'package:flutter/material.dart';

mixin YkPayTypeWidgetDelegate<T> on Widget {
  dynamic getCurrentType();
}

mixin YkPayWidgetDelegate<T> {
  Future init();

  Widget getMainWidget();

  YkPayTypeWidgetDelegate getTypeWidget();

  Widget getBottomPay(Function() payCallBack);

  Future createOrder(T type);
}

class YkPayWidget<T> extends StatelessWidget {
  final YkPayWidgetDelegate<T> delegate;

  final Widget? loadingWidget;

  final Widget? errorWidget;

  const YkPayWidget({super.key, required this.delegate, this.loadingWidget, this.errorWidget});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: delegate.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final typeWidget = delegate.getTypeWidget();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                delegate.getMainWidget(),
                typeWidget,
                delegate.getBottomPay(() {
                  delegate.createOrder(typeWidget.getCurrentType());
                }),
              ],
            );
          } else {
            return loadingWidget ?? const Center(child: CircularProgressIndicator());
          }
        });
  }
}
