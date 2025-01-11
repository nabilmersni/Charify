import 'package:charify/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  const DefaultCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.onSurface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          onChanged.call(value);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    color: AppColors.text,
                    size: 24,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
