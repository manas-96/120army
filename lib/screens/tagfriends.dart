import '../exports.dart';
import '../global.dart';
import '../model/suggest_friend_list_model.dart';
import '../shimmerloader/edit_profile_loader.dart';
import '../statemanagment/friendlist/friendlist_bloc.dart';
import '../statemanagment/locationtagfriends/locationtagfriends_bloc.dart';
import 'widget/cached_image.dart';

class Tagfriends extends StatefulWidget {
  final List realDataList;

  const Tagfriends({super.key, this.realDataList = const []});

  @override
  State<Tagfriends> createState() => _TagfriendsState();
}

class _TagfriendsState extends State<Tagfriends> {
  final Map<String, String> _selectedFriends = {}; // id -> name

  // Search state
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();

    // Pre-select from realDataList
    for (var friend in widget.realDataList) {
      if (friend["id"] != null && friend["name"] != null) {
        _selectedFriends[friend["id"]] = friend["name"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title:
            _isSearching
                ? TextFormField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search friends',
                    hintStyle: const TextStyle(color: Colors.white60),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: kPrimaryColor.withValues(alpha: 0.3),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                )
                : Text(
                  "Tag friends",
                  style: TextStyle(fontSize: appbarTitle, color: Colors.white),
                ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = "";
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: BlocBuilder<FriendlistBloc, FriendlistState>(
          builder: (context, state) {
            if (state is FriendlistLoading) {
              return Editprofileloader();
            } else if (state is FriendlistLoaded) {
              List<Suggestdatum> data = state.model.data;

              // Apply search filter
              if (_searchQuery.isNotEmpty) {
                data =
                    data
                        .where(
                          (f) =>
                              (f.firstName.toLowerCase().contains(
                                _searchQuery,
                              )) ||
                              (f.lastName.toLowerCase().contains(_searchQuery)),
                        )
                        .toList();
              }

              // ✅ Sort: selected friends first
              data.sort((a, b) {
                final aSelected = _selectedFriends.containsKey(a.id.toString());
                final bSelected = _selectedFriends.containsKey(b.id.toString());
                if (aSelected && !bSelected) return -1; // a first
                if (!aSelected && bSelected) return 1; // b first
                return 0;
              });

              if (data.isNotEmpty) {
                return ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final friend = data[index];
                    final isSelected = _selectedFriends.containsKey(
                      friend.id.toString(),
                    );

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        child:
                            friend.profileImage.isNotEmpty
                                ? MyImageWidget(
                                  imageUrl: friend.profileImage,
                                  radius: true,
                                )
                                : Image.asset("assets/images/user.png"),
                      ),
                      title: Wrap(
                        spacing: 4, // space between first and last name
                        children: [
                          Text(friend.firstName),
                          Text(friend.lastName),
                        ],
                      ),

                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedFriends[friend.id.toString()] =
                                  "${friend.firstName} ${friend.lastName}";
                            } else {
                              _selectedFriends.remove(friend.id.toString());
                            }
                          });

                          // Update BLoC with selected friend names
                          // context.read<LocationtagfriendsBloc>().add(
                          //   UpdateTargetFriends(
                          //     _selectedFriends.values.toList(),
                          //   ),
                          // );
                          context.read<LocationtagfriendsBloc>().add(
                            UpdateTargetFriends(
                              _selectedFriends.entries
                                  .map((e) => {"id": e.key, "name": e.value})
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("No friends found"));
              }
            } else if (state is FriendlistError) {
              return Center(child: Text(state.error));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
