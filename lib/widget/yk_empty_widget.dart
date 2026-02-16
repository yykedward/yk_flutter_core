import 'package:flutter/material.dart';
import 'package:yk_flutter_core/widget/yk_text_widget.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkEmptyWidget extends StatelessWidget {
  const YkEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.layers_clear, color: YkCoreInfo.mainColor, size: 38),
        const SizedBox(height: 2),
        YkTextWidget("暂无数据",
            style: TextStyle(fontSize: 20, color: Color(0xFFFFFFFF))),
      ],
    );
  }
}
