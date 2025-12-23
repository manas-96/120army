import '../../../exports.dart';
import '../../../shared_pref.dart';

class FullNameWidget extends StatelessWidget {
  final TextStyle? style; // optional custom style

  const FullNameWidget({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    String? fullName = SharedPrefUtils.getCachedStr("fullname");

    if (fullName != null && fullName.isNotEmpty) {
      return Text(
        fullName,
        style:
            style ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    } else {
      return const Text(
        "Guest",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      );
    }
  }
}

class BioWidget extends StatelessWidget {
  final TextStyle? style;

  const BioWidget({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    String? bio = SharedPrefUtils.getCachedStr("bio");

    if (bio != null && bio.isNotEmpty) {
      return Text(
        bio,
        style:
            style ?? const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
      );
    } else {
      return const Text(
        "No bio available",
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }
  }
}
