import 'package:flutter/material.dart';
import '../resources/colors.dart';

class FormInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showLabel;

  const FormInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textCapitalization,
    this.maxLength,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.showLabel = true,
  });

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  bool _isFocused = false;
  String? _errorText;
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

  String? _validateField(String? value) {
    final error = widget.validator?.call(value);
    setState(() {
      _errorText = error;
    });
    // Return the actual error for form validation, error text is hidden via errorStyle
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral[600],
                letterSpacing: 0.2,
              ),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _errorText != null
                      ? AppColors.tertiary[500]!
                      : _isFocused
                      ? AppColors.primary.withOpacity(0.5)
                      : AppColors.neutral[200]!,
              width: _errorText != null || _isFocused ? 2 : 1,
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
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            maxLength: widget.maxLength,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            validator: _validateField,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral[900],
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: AppColors.neutral[400],
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused ? AppColors.primary : AppColors.neutral[400],
                size: 20,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: const TextStyle(height: 0, color: Colors.transparent),
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              isDense: true,
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _errorText!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.tertiary[500],
                letterSpacing: 0.2,
              ),
            ),
          ),
      ],
    );
  }
}
