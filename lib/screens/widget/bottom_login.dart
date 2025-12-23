import '../../exports.dart';
import '../../global.dart';

class Bottomlogin extends StatelessWidget {
  const Bottomlogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
        left: kDefaultPadding,
        right: kDefaultPadding,
      ),
      child: TextButton(
        onPressed: () {
          Navigator.of(
            context,
          ).pushNamed("/login", arguments: {"animationEnabled": false});
        },
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'I already joined',
                style: TextStyle(color: Colors.grey, fontSize: smallSize),
              ),
              TextSpan(
                text: ' 120 Army',
                style: TextStyle(color: kPrimaryColor, fontSize: smallSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
