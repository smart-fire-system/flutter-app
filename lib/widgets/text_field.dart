import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxLines;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.inputType,
    this.maxLines,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: CustomStyle.mediumText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: CustomStyle.smallTextBRed,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.greyMedium,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.greyMedium,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.redDark,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final int? maxLines;
  final IconData? icon;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.inputType,
    this.maxLines,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        style: CustomStyle.mediumText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: CustomStyle.smallTextBRed,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.greyMedium,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.greyMedium,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: CustomStyle.redDark,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class GrowingTextField extends StatefulWidget {
  final String value;
  final String? hintText;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final double minWidth;
  final double maxWidth;
  final TextStyle? style;
  final int? maxLines;
  final TextDirection textDirection;

  const GrowingTextField({
    super.key,
    required this.value,
    this.hintText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.minWidth = 60,
    this.maxWidth = 200,
    this.style,
    this.maxLines,
    this.textDirection = TextDirection.rtl,
  });

  @override
  State<GrowingTextField> createState() => _GrowingTextFieldState();
}

class _GrowingTextFieldState extends State<GrowingTextField> {
  late TextEditingController _controller;
  double _width = 60;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _updateWidth(widget.value);
    _controller.addListener(() {
      _updateWidth(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant GrowingTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
      _updateWidth(widget.value);
    }
  }

  void _updateWidth(String text) {
    final textStyle = widget.style ?? const TextStyle(fontSize: 16);
    final span =
        TextSpan(text: text.isEmpty ? widget.hintText ?? '' : text, style: textStyle);
    final tp = TextPainter(
        text: span, maxLines: 1, textDirection: widget.textDirection);
    tp.layout();
    final newWidth = tp.width + 24; // Add some padding
    setState(() {
      _width = newWidth.clamp(widget.minWidth, widget.maxWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(minWidth: widget.minWidth, maxWidth: widget.maxWidth),
      child: SizedBox(
        width: _width,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: CustomStyle.redLight, width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: CustomStyle.redDark, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            hintText: widget.hintText ?? '',
          ),
          style: widget.style ?? const TextStyle(fontSize: 16),
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          textDirection: widget.textDirection,
        ),
      ),
    );
  }
}
