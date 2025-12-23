import '../../exports.dart';
import '../../global.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../statemanagment/searchfriendlist/searchfriendlist_bloc.dart';
import 'suggestfriendlistwidget.dart';

class Friendlistwidget extends StatefulWidget {
  final List<Suggestdatum> dataList;

  const Friendlistwidget({super.key, required this.dataList});

  @override
  State<Friendlistwidget> createState() => _FriendlistwidgetState();
}

class _FriendlistwidgetState extends State<Friendlistwidget> {
  final ScrollController _scrollController = ScrollController();
  late SearchfriendlistBloc _bloc;

  final Set<String> hiddenIds = {};

  @override
  void initState() {
    super.initState();
    _bloc = context.read<SearchfriendlistBloc>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 1500) {
        if (!_bloc.isLoadingMore) {
          _bloc.add(
            SearchfriendlistTrigger(
              page: _bloc.currentPage + 1,
              aLoading: true,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: kDefaultPadding),
      controller: _scrollController,
      itemCount: widget.dataList.length + 1, // Add loader
      itemBuilder: (context, index) {
        if (index < widget.dataList.length) {
          final item = widget.dataList[index];

          if (hiddenIds.contains(item.id.toString())) {
            return const SizedBox.shrink(); // Hide the item
          }

          return Mainfrieldlistwidgets(
            removeStatus: false,
            searchlist: true,
            data: item,
            onRemove: () {},
            addFriend: () {},
          );
        } else {
          // return widget.dataList.length >= 10
          //     ? Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: Center(child: CircularProgressIndicator()),
          //     )
          //     : SizedBox.shrink();
        }
        return null;
      },
    );
  }
}
