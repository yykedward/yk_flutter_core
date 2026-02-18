import 'package:flutter/material.dart';
import 'package:yk_flutter_core/widget/yk_text_widget.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkEmptyWidget extends StatelessWidget {
  final String text;

  const YkEmptyWidget({super.key, this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.layers_clear, color: YkCoreInfo.mainColor, size: 38),
        (text.isNotEmpty) ? const SizedBox(height: 2) : const SizedBox(),
        (text.isNotEmpty)
            ? YkTextWidget(text,
                style: TextStyle(fontSize: 20, color: YkCoreInfo.mainColor))
            : const SizedBox(),
      ],
    );
  }
}
