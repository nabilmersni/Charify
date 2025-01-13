import 'package:charify/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Function(String)? onChange;
  final TextInputType? keyboardType;
  const DefaultTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.onChange,
    this.prefixText,
    this.keyboardType,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.onSurface,
        hintText: hintText,
        prefixText: prefixText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.text.withOpacity(0.7),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon,
      ),
    );
  }
}
