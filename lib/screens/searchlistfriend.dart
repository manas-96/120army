import 'dart:async';

import '../exports.dart';
import '../global.dart';
import '../shimmerloader/edit_profile_loader.dart';
import '../statemanagment/searchfriendlist/searchfriendlist_bloc.dart';
import 'widget/friendlistwidget.dart';

class Searchfriendlist extends StatefulWidget {
  const Searchfriendlist({super.key});

  @override
  State<Searchfriendlist> createState() => _SearchfriendlistState();
}

class _SearchfriendlistState extends State<Searchfriendlist> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Timer? _debounce; // ⬅️ Add this

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });

    context.read<SearchfriendlistBloc>().add(SearchfriendlistTrigger());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel(); // cancel debounce
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 2), () {
      context.read<SearchfriendlistBloc>().add(
        SearchfriendlistTrigger(page: 1, searchText: value),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: SizedBox(
          height: 40,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            builder: (context, value, _) {
              return TextFormField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white60),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon:
                      value.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.white),
                            onPressed: () {
                              _searchController.clear();
                              _debounce?.cancel();
                              context.read<SearchfriendlistBloc>().add(
                                SearchfriendlistTrigger(),
                              );
                            },
                          )
                          : null,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: kPrimaryColor.withValues(alpha: 0.3),
                ),
                onChanged: _onSearchChanged, // ⬅️ Debounced function
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: BlocBuilder<SearchfriendlistBloc, SearchfriendlistState>(
          builder: (context, state) {
            if (state is SearchfriendlistLoading) {
              return Editprofileloader();
            } else if (state is SearchfriendlistError) {
              return Text(state.error);
            } else if (state is SearchfriendlistLoaded) {
              return Friendlistwidget(dataList: state.dataList);
            } else {
              return const Text("");
            }
          },
        ),
      ),
    );
  }
}
