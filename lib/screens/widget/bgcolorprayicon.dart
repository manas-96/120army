import '../../exports.dart';
import '../../global.dart';

class Bgcolorprayicon extends StatelessWidget {
  const Bgcolorprayicon({
    super.key,
    this.iconpath = "assets/icons/post_pray.svg",
    this.padding = 3,
  });

  final String iconpath;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
      child: SvgPicture.asset(
        iconpath,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
