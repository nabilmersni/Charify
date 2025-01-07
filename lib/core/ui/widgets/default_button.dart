import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final Color? bgColor;
  final Color? textColor;
  final Function()? onPressed;
  final EdgeInsets? padding;

  const DefaultButton({
    super.key,
    this.text,
    this.bgColor,
    this.textColor,
    this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return bgColor?.withOpacity(0.5);
                  }
                  return bgColor;
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.disabled)) {
                    return textColor?.withOpacity(0.5);
                  }
                  return textColor;
                },
              ),
              padding: WidgetStatePropertyAll(padding),
            ),
        child: Text(text ?? ""),
      ),
    );
  }
}
