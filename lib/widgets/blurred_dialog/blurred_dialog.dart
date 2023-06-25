import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredDialog extends StatefulWidget {
  final Widget dialogContent;
  BlurredDialog({required this.dialogContent});
  @override
  _BlurredDialogState createState() => _BlurredDialogState();
}

class _BlurredDialogState extends State<BlurredDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        GestureDetector(
          // bắt sự kiện người dùng bấm vào BackdropFilter
          onTap: () {
            Navigator.pop(context); // đóng dialog
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(
              constraints: const BoxConstraints.expand(),
            ),
          ),
        ),
        // Dialog content
        widget.dialogContent,
      ],
    );
  }
}
