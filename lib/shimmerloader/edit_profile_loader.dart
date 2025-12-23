import '../exports.dart';
import '../global.dart';

class Editprofileloader extends StatelessWidget {
  const Editprofileloader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          CircleAvatar(radius: 40, backgroundColor: Colors.white),
          const SizedBox(height: 20),
          Container(width: 150, height: 20, color: Colors.white),
          const SizedBox(height: 10),
          Container(width: 250, height: 14, color: Colors.white),
          const SizedBox(height: 30),
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                height: 20,
                color: Colors.white,
              ),
            );
          }),
        ],
      ),
    );
  }
}
