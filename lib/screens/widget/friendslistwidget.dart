import '../../exports.dart';
import '../../global.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../shimmerloader/edit_profile_loader.dart';
import '../../statemanagment/friendlist/friendlist_bloc.dart';
import 'border.dart';
import 'custom_elevated_button.dart';
import 'myfriendlistwidget.dart';

class Friendslistwidget extends StatelessWidget {
  const Friendslistwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendlistBloc, FriendlistState>(
      builder: (context, state) {
        if (state is FriendlistLoading) {
          return Editprofileloader();
        } else if (state is FriendlistLoaded) {
          List<Suggestdatum> data = state.model.data;
          if (data.isNotEmpty) {
            return Column(
              children: [
                Gap(10),
                Borderdevider(
                  borderWidth: 4,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                ),
                Gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Friends",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                "${data.length} friends",
                                style: TextStyle(color: textGrayColor),
                              ),
                            ],
                          ),
                          if (data.length > 3) ...[
                            SizedBox(
                              width: 100,
                              child: CustomButton(
                                verticalPadding: 10,
                                fontsize: 12,
                                text: "See all",
                                backgroundColor: kLightPrimaryColor,
                                textColor: kPrimaryColor,
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    "/myfriendlist",
                                    arguments: {
                                      "data": data,
                                      "fullscreen": true,
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                      Myfriendlist(data: data),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        } else if (state is FriendlistError) {
          return Text(state.error);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
