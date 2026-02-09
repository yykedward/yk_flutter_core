import 'package:flutter/material.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkEmptyWidget extends StatelessWidget {
  final double height;
  final double width;

  const YkEmptyWidget({super.key, this.height = 50, this.width = 50});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Icon(Icons.layers_clear, color: YkCoreInfo.mainColor, size: 38),
    );
  }
}
