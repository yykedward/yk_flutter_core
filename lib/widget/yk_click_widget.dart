import 'package:flutter/material.dart';

class YkClickWidget extends StatelessWidget {
  final GestureTapCallback onClick;
  final Widget child;
  final bool needFilter;

  static int _clickTime = 0;

  const YkClickWidget({
    super.key,
    required this.onClick,
    required this.child,
    this.needFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        int time = DateTime.now().millisecondsSinceEpoch;

        if (needFilter) {
          if (time - _clickTime > 1000) {
            onClick();
            _clickTime = time;
          }
        } else {
          onClick();
        }
      },
      child: child,
    );
  }
}
