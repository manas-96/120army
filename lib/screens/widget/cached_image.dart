import '../../exports.dart';

class MyImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final bool profilePic;
  final bool radius;
  final double radiusVal;

  // 🔹 new flags
  final bool profileStatus;
  final bool coverStatus;

  const MyImageWidget({
    super.key,
    required this.imageUrl,
    this.width = 50.0,
    this.height = 50.0,
    this.profilePic = false,
    this.radius = false,
    this.radiusVal = 20.0,
    this.profileStatus = false, // default false
    this.coverStatus = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    String fallbackAsset = "assets/images/logo.png";

    // 🔹 logic for profile / cover
    if (profileStatus) {
      fallbackAsset = "assets/images/user.png";
    } else if (coverStatus) {
      fallbackAsset = "assets/images/cover.png";
    }

    // 🔹 dynamic width/height logic
    final double? finalWidth =
        coverStatus
            ? MediaQuery.of(context)
                .size
                .width // full screen width for cover
            : (profilePic ? width : null);

    final double? finalHeight =
        coverStatus
            ? 260.0 // fixed height for cover
            : (profilePic ? height : null);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius == false ? radiusVal : width),
      child:
          imageUrl.isEmpty
              ? Image.asset(
                fallbackAsset,
                width: finalWidth,
                height: finalHeight,
                fit: BoxFit.cover,
              )
              : CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 100),
                fadeOutDuration: const Duration(milliseconds: 100),
                imageUrl: imageUrl,
                width: finalWidth,
                height: finalHeight,
                placeholder:
                    (context, url) => Center(
                      child: Image.asset(
                        fallbackAsset,
                        width: coverStatus == false ? 50 : finalWidth,
                        height: coverStatus == false ? 50 : finalHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Image.asset(
                      fallbackAsset,
                      width: finalWidth,
                      height: finalHeight,
                      fit: BoxFit.cover,
                    ),
                fit: BoxFit.cover,
              ),
    );
  }
}
