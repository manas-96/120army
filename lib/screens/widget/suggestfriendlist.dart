import '../../exports.dart';
import '../../global.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../services/main_service.dart';
import '../../statemanagment/suggestfriendlist/suggestfriendlist_bloc.dart';
import 'suggestfriendlistwidget.dart';
import 'dart:async';
import 'toast.dart';

class Suggestfriendswidget extends StatefulWidget {
  const Suggestfriendswidget({
    super.key,
    required this.dataList,
    this.fullpage = false,
  });

  final List<Suggestdatum> dataList;
  final bool fullpage;

  @override
  State<Suggestfriendswidget> createState() => _SuggestfriendswidgetState();
}

class _SuggestfriendswidgetState extends State<Suggestfriendswidget> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  late List<Suggestdatum> _items;
  final Set<String> _hiddenItemIds = {};

  @override
  void initState() {
    super.initState();
    _items = widget.dataList;

    if (widget.fullpage) {
      _scrollController.addListener(_scrollListener);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 2500) {
      if (_debounce?.isActive ?? false) return;

      _debounce = Timer(const Duration(milliseconds: 300), () {
        context.read<SuggestfriendlistBloc>().add(SuggestfriendlistLoadMore());
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listView = BlocBuilder<SuggestfriendlistBloc, SuggestfriendlistState>(
      builder: (context, state) {
        bool hasReachedMax = false;

        if (state is SuggestfriendlistLoaded) {
          _items = state.model.data;
          hasReachedMax = _items.length >= state.model.total;
        }

        final visibleItemCount =
            widget.fullpage
                ? _items.length + (!hasReachedMax ? 1 : 0)
                : (_items.length >= 10 ? 10 : _items.length);

        return ListView.builder(
          controller: widget.fullpage ? _scrollController : null,
          itemCount: visibleItemCount,
          shrinkWrap: !widget.fullpage,
          padding: EdgeInsets.all(widget.fullpage ? kDefaultPadding : 0),
          physics:
              widget.fullpage
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index >= _items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                // child: Center(child: CircularProgressIndicator()),
              );
            }

            final currentItem = _items[index];

            if (_hiddenItemIds.contains(currentItem.id.toString())) {
              return const SizedBox.shrink();
            }

            return Mainfrieldlistwidgets(
              data: currentItem,
              onRemove: () async {
                try {
                  final value = await MainService().suggestfriendremoveService(
                    remove_user_id: currentItem.id,
                  );
                  if (value != null && value.status == "success") {
                    if (widget.fullpage) {
                      setState(() {
                        _hiddenItemIds.add(currentItem.id.toString());
                      });
                    } else {
                      context.read<SuggestfriendlistBloc>().add(
                        SuggestfriendlistTrigger(showLoading: false),
                      );
                    }
                  } else {
                    showGlobalSnackBar(
                      message: value?.msg ?? "Something went wrong.",
                    );
                  }
                } catch (e) {
                  showGlobalSnackBar(message: "Error: ${e.toString()}");
                }
              },
              addFriend: () async {
                try {
                  final value = await MainService().addfriendService(
                    friend_id: currentItem.id,
                  );
                  if (value != null && value.status == "success") {
                    showGlobalSnackBar(message: value.msg);
                    if (widget.fullpage) {
                      setState(() {
                        _hiddenItemIds.add(currentItem.id.toString());
                      });
                    } else {
                      context.read<SuggestfriendlistBloc>().add(
                        SuggestfriendlistTrigger(showLoading: false),
                      );
                    }
                  } else {
                    showGlobalSnackBar(
                      message: value?.msg ?? "Something went wrong.",
                    );
                  }
                } catch (e) {
                  showGlobalSnackBar(message: "Error: ${e.toString()}");
                }
              },
            );
          },
        );
      },
    );

    if (widget.fullpage) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            "People You May Know",
            style: TextStyle(fontSize: appbarTitle, color: Colors.white),
          ),
        ),
        body: listView,
      );
    }

    return listView;
  }
}
