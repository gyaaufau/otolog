import 'package:flutter/material.dart';
import '../resources/colors.dart';

class FormDateField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final DateTime? value;
  final void Function(DateTime?) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showLabel;

  const FormDateField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.showLabel = true,
  });

  @override
  State<FormDateField> createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.value ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.neutral[900]!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _isFocused
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.neutral[200]!,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow:
            _isFocused
                ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [
                  BoxShadow(
                    color: AppColors.neutral[900]!.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: InkWell(
        onTap: _selectDate,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      _isFocused
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.neutral[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  color:
                      _isFocused ? AppColors.primary : AppColors.neutral[500],
                  size: 18,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showLabel)
                      Text(
                        widget.label,
                        style: TextStyle(
                          color:
                              _isFocused
                                  ? AppColors.primary
                                  : AppColors.neutral[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    if (widget.showLabel) const SizedBox(height: 4),
                    Text(
                      widget.value != null
                          ? '${widget.value!.day}/${widget.value!.month}/${widget.value!.year}'
                          : widget.hint,
                      style: TextStyle(
                        color:
                            widget.value != null
                                ? AppColors.neutral[900]
                                : AppColors.neutral[400],
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.calendar_today_rounded,
                color: _isFocused ? AppColors.primary : AppColors.neutral[500],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
