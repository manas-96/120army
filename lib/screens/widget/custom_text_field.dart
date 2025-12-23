import '../../exports.dart';
import '../../global.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black, fontSize: formLabelFontSize),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: formLabelFontSize,
          color: Colors.grey,
        ),
        floatingLabelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusbox),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusbox),
          borderSide: BorderSide(color: greyBorderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusbox),
          borderSide: const BorderSide(color: errorColor), // Error color
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusbox),
          borderSide: const BorderSide(color: errorColor), // Same error color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusbox),
          borderSide: const BorderSide(color: Color(0xFF909090)),
        ),
        errorStyle: const TextStyle(color: errorColor, fontSize: smallSize),
        suffixIcon: suffixIcon,
      ),
      validator: validator, // Apply validator
    );
  }
}
