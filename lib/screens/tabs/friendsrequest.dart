import '../../exports.dart';
import '../../global.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../shimmerloader/edit_profile_loader.dart';
import '../../statemanagment/friendrequestlist/friendrequestlist_bloc.dart';
import '../../statemanagment/suggestfriendlist/suggestfriendlist_bloc.dart';
import '../widget/border.dart';
import '../widget/custom_elevated_button.dart';
import '../widget/friendrequest_widget.dart';
import '../widget/suggestfriendlist.dart';

class Friendsrequests extends StatefulWidget {
  const Friendsrequests({super.key});

  @override
  State<Friendsrequests> createState() => _FriendsrequestsState();
}

class _FriendsrequestsState extends State<Friendsrequests> {
  @override
  void initState() {
    super.initState();
    context.read<FriendrequestlistBloc>().add(FriendrequestlistTrigger());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: ListView(
          children: [
            BlocBuilder<FriendrequestlistBloc, FriendrequestlistState>(
              builder: (context, state) {
                if (state is FriendrequestlistLoading) {
                  // return Editprofileloader();
                  return Gap(20);
                } else if (state is FriendrequestlistError) {
                  return Text(state.error);
                } else if (state is FriendrequestlistLoaded) {
                  List<Suggestdatum> dataList = state.model.data;
                  if (dataList.isNotEmpty) {
                    return Column(
                      children: [
                        Gap(20),
                        Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Friend requests ',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displayMedium,
                                  ),
                                  TextSpan(
                                    text: dataList.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(20),
                        Column(
                          children: List.generate(dataList.length, (index) {
                            return FriendRequestCard(data: dataList[index]);
                          }),
                        ),
                        Borderdevider(),
                      ],
                    );
                  } else {
                    return const Text("");
                  }
                } else {
                  return const Text("");
                }
              },
            ),

            // ====================================================================================
            BlocBuilder<SuggestfriendlistBloc, SuggestfriendlistState>(
              builder: (context, state) {
                if (state is SuggestfriendlistLoading) {
                  return Editprofileloader();
                } else if (state is SuggestfriendlistError) {
                  return Text(state.error);
                } else if (state is SuggestfriendlistLoaded) {
                  List<Suggestdatum> dataList = state.model.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "People you may know",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Gap(20),
                      Suggestfriendswidget(dataList: dataList),
                      Gap(10),
                      CustomButton(
                        verticalPadding: 10,
                        fontsize: 12,
                        text: "See all",
                        backgroundColor: kLightPrimaryColor,
                        textColor: kPrimaryColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            "/suggestfriendswidget",
                            arguments: {"dataList": dataList, "fullpage": true},
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return const Text("");
                }
              },
            ),

            Gap(hometabbottomgap),
          ],
        ),
      ),
    );
  }

  // 👥 Friend Request Card
}
