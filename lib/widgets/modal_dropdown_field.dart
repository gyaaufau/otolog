import 'package:flutter/material.dart';
import '../resources/colors.dart';

class ModalDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? label;
  final bool showLabel;

  const ModalDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel && label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    value != null
                        ? AppColors.primary[500]
                        : AppColors.neutral[700],
                letterSpacing: 0.15,
              ),
            ),
          ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder:
                  (context) => _ModalBottomSheet(
                    items: items,
                    selectedValue: value,
                    onSelected: onChanged,
                  ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    value != null
                        ? AppColors.primary[500]!
                        : AppColors.neutral[200]!,
                width: value != null ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color:
                          value != null
                              ? AppColors.neutral[900]
                              : AppColors.neutral[400],
                      letterSpacing: 0.2,
                      height: 1.4,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color:
                      value != null
                          ? AppColors.primary[500]
                          : AppColors.neutral[500],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _ModalBottomSheet extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final void Function(String?) onSelected;

  const _ModalBottomSheet({
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutral[200]!, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select an option',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral[900],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.neutral[500],
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selectedValue;
                  return InkWell(
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : AppColors.neutral[900],
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
