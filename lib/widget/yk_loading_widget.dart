import 'package:flutter/material.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkLoadingWidget extends StatelessWidget {
  final double height;
  final double width;

  const YkLoadingWidget({super.key, this.height = 50, this.width = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: YkCoreInfo.bgWhiteColor),
      child: Center(child: CircularProgressIndicator(color: YkCoreInfo.mainColor)),
    );
  }
}
