import '../../../exports.dart';
import '../../../global.dart';
import '../../../shimmerloader/edit_profile_loader.dart';
import '../../../statemanagment/challenges/challenges_bloc.dart';
import '../cached_image.dart';

class Badgewidget extends StatelessWidget {
  const Badgewidget({super.key, this.own = true});

  final bool own;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengesBloc, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengesLoading) {
          return Editprofileloader();
        } else if (state is ChallengesLoaded) {
          return Container(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(state.model.data!.length, (index) {
                int istotalcompleted =
                    state.model.data![index].isTotalCompleted!;
                String imageUrl = state.model.data![index].image!;

                return GestureDetector(
                  onTap: () {
                    if (istotalcompleted == 0) {
                      if (own) {
                        Navigator.of(context).pushNamed("/home?tab=3");
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              content: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      kDefaultPadding * 2,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: MyImageWidget(imageUrl: imageUrl),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width:
                            (MediaQuery.of(context).size.width - (4 * 3) - 16) /
                            4,
                        height: 90,
                        padding: const EdgeInsets.all(10),
                        child: Opacity(
                          opacity: istotalcompleted == 0 ? 0.2 : 1,
                          child: MyImageWidget(imageUrl: imageUrl),
                        ),
                      ),
                      Positioned.fill(
                        child:
                            istotalcompleted == 0
                                ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                                : SizedBox.shrink(),
                      ),
                      Positioned.fill(
                        child:
                            istotalcompleted == 0
                                ? Center(
                                  child: Icon(
                                    Icons.lock,
                                    color: kPrimaryColor,
                                    size: 28,
                                  ),
                                )
                                : SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        } else if (state is ChallengesError) {
          return Text(state.error);
        } else {
          return Text("Something went wrong");
        }
      },
    );
  }
}
