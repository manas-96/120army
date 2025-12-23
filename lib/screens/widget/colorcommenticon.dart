import 'package:onetwentyarmyprayer2/global.dart';

import '../../exports.dart';

class Colorcommenticon extends StatelessWidget {
  const Colorcommenticon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
      child: SvgPicture.asset(
        'assets/icons/chat_fill.svg',

        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
