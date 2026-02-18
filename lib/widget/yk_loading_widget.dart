import 'package:flutter/material.dart';
import 'package:yk_flutter_core/widget/yk_text_widget.dart';
import 'package:yk_flutter_core/yk_core_info.dart';

class YkLoadingWidget extends StatelessWidget {
  final String text;

  const YkLoadingWidget({super.key, this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: CircularProgressIndicator(color: YkCoreInfo.mainColor)),
        (text.isNotEmpty) ? const SizedBox(height: 2) : const SizedBox(),
        (text.isNotEmpty)
            ? YkTextWidget(text, style: TextStyle(color: YkCoreInfo.mainColor))
            : Container(),
      ],
    );
  }
}
