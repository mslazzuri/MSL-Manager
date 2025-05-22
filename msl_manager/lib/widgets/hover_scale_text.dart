import 'package:flutter/material.dart';

class HoverScaleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const HoverScaleText({super.key, required this.text, this.style});

  @override
  State<HoverScaleText> createState() => HoverScaleTextState();
}

class HoverScaleTextState extends State<HoverScaleText> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Text(widget.text, style: widget.style),
      ),
    );
  }
}
