import '../../exports.dart';

void showGlobalSnackBar({
  required String message,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  ToastGravity gravity = ToastGravity.BOTTOM,
  int duration = 1, // in seconds
}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: duration == 1 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.0,
    timeInSecForIosWeb: 1,
  );
}
