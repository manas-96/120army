import '../../../exports.dart';
import '../../../statemanagment/profillecoverchange/profillecoverchange_bloc.dart';

class ProfileImageWidget extends StatelessWidget {
  final double size;
  const ProfileImageWidget({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfillecoverchangeBloc, ProfillecoverchangeState>(
      builder: (context, state) {
        String? imageUrl;
        if (state is ProfileCoverLoaded) {
          imageUrl = state.profilePic;
        }

        if (imageUrl != null && imageUrl.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: size,
              width: size,
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => SizedBox(
                    height: size,
                    width: size,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              errorWidget: (_, __, ___) => Icon(Icons.person, size: size),
            ),
          );
        } else {
          return Image.asset(
            "assets/images/user.png",
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}

class CoverImageWidget extends StatelessWidget {
  final double height;
  const CoverImageWidget({super.key, this.height = 260});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfillecoverchangeBloc, ProfillecoverchangeState>(
      builder: (context, state) {
        String? coverUrl;
        if (state is ProfileCoverLoaded) {
          coverUrl = state.coverPic;
        }

        if (coverUrl != null && coverUrl.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: coverUrl,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder:
                (_, __) => SizedBox(
                  height: height,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            errorWidget:
                (_, __, ___) => Container(
                  height: height,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
          );
        } else {
          return Image.asset(
            "assets/images/cover.png",
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        }
      },
    );
  }
}
