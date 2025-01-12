import 'package:charify/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final Function(String)? onChange;
  const DefaultTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChange,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.onSurface,
        hintText: hintText,
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
