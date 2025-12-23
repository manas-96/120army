import '../../exports.dart';
import '../../global.dart';

class Borderdevider extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const Borderdevider({
    super.key,
    this.borderColor = postBorderColor,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: borderWidth)),
      ),
    );
  }
}
