import '../../exports.dart';
import '../../global.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final double verticalPadding;
  final bool isOutlined;
  final double fontsize;
  final Color textColor;
  final IconData? icon; // Flutter icon instead of SVG
  final double iconSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = kPrimaryColor,
    this.borderColor = kPrimaryColor,
    this.verticalPadding = 18,
    this.isOutlined = false,
    this.fontsize = 14,
    this.textColor = Colors.white,
    this.icon, // Optional Flutter icon
    this.iconSize = 24.0, // Default icon size
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child:
          isOutlined
              ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                ),
                onPressed: onPressed,
                child: _buildButtonContent(isOutlined: true), // Pass isOutlined
              )
              : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                ),
                onPressed: onPressed,
                child: _buildButtonContent(
                  isOutlined: false,
                ), // Pass isOutlined
              ),
    );
  }

  /// Builds button content with optional Flutter Icon
  Widget _buildButtonContent({required bool isOutlined}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize,
            color: isOutlined ? kPrimaryColor : textColor,
          ),
          const SizedBox(width: 8), // Space between icon and text
        ],
        Text(
          text,
          style: TextStyle(
            color: isOutlined ? kPrimaryColor : textColor,
            fontSize: fontsize,
          ),
        ),
      ],
    );
  }
}
