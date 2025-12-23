import '../../../exports.dart';
import '../../../model/listpost_model.dart';
import '../../../statemanagment/homewalllist/homewalllist_bloc.dart';
import '../../section_widget/postsection.dart';

class Walllist extends StatefulWidget {
  const Walllist({super.key});

  @override
  State<Walllist> createState() => _WalllistState();
}

class _WalllistState extends State<Walllist> {
  late HomewalllistBloc _bloc;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<HomewalllistBloc>();
    _bloc.add(HomewalllistFetch(page));
  }

  Future<void> _handleRefresh() async {
    context.read<HomewalllistBloc>().add(
      const HomewalllistFetch(1, showLoader: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomewalllistBloc, HomewalllistState>(
      builder: (context, state) {
        if (state is HomewalllistLoading && page == 1) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomewalllistLoaded) {
          List<PostlistDatum> finalData = state.posts;
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 100) {
                  page++;
                  _bloc.add(HomewalllistLoadMore(page));
                }
                return false;
              },
              child: ListView.builder(
                itemCount:
                    state.hasReachedMax
                        ? state.posts.length
                        : state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.posts.length) {
                    final item = finalData[index];
                    // widget section
                    return Postsection(
                      index: index,
                      item: item,
                      onDelete: () {
                        setState(() {
                          finalData.removeAt(index);
                        });
                      },
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        } else if (state is HomewalllistError) {
          return Center(child: Text(state.error));
        } else {
          return Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
