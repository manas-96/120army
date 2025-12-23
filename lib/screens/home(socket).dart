// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import '../exports.dart';
import '../global.dart';
import '../services/pusher.dart';
import '../statemanagment/friendlist/friendlist_bloc.dart';
import '../statemanagment/homewalllist/homewalllist_bloc.dart';
import '../statemanagment/profillecoverchange/profillecoverchange_bloc.dart';
import '../statemanagment/rewardlist/rewardlist_bloc.dart';
import '../statemanagment/suggestfriendlist/suggestfriendlist_bloc.dart';
import '../statemanagment/weeklypc/weeklypc_bloc.dart';
import 'reelslist.dart';
import 'separate_push_post.dart';
import 'tabs/friendsrequest.dart';
import 'tabs/hometab.dart';
import 'tabs/notification.dart';
import 'tabs/profiletab.dart';
import 'tabs/weeklypc.dart';
import 'widget/screenwidget/profilepic_widget.dart';
import 'widget/toast.dart';

class Home extends StatefulWidget {
  final int initialTabIndex;
  const Home({super.key, this.initialTabIndex = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  DateTime? ctime;
  late TabController _tabController;
  late ValueNotifier<int> _selectedIndex;
  final List<int> _tabHistory = [];
  final ValueNotifier<int> notificationCount = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNavigation();
    });

    _tabController = TabController(length: 5, vsync: this);
    _tabController.index = widget.initialTabIndex;
    _selectedIndex = ValueNotifier<int>(widget.initialTabIndex);
    _tabHistory.add(widget.initialTabIndex);

    _tabController.animation!.addListener(() {
      final newIndex = _tabController.animation!.value.round();
      if (_selectedIndex.value != newIndex) {
        _selectedIndex.value = newIndex;

        if (newIndex == 0) {
          _tabHistory
            ..clear()
            ..add(0);
        } else if (_tabHistory.isEmpty || _tabHistory.last != newIndex) {
          _tabHistory.add(newIndex);
        }
      }
    });

    // Listen to Pusher events globally
    PusherService.instance.events.listen((event) {
      // ধরুন eventName হলো 'notification-count-update'
      if (event.eventName == 'notification-count-update') {
        // event.data হলো JSON string, parse করতে হবে
        final data = event.data;
        // data একটি Map<String, dynamic> হিসেবে পেতে হলে parse করুন
        // আপনার package এর উপর নির্ভর করে এটা decode করা লাগতে পারে

        // নিচের কোড ধরা হয়েছে data JSON string হলে:
        final parsed = jsonDecode(data);
        final count = parsed['count'] ?? 0;
        notificationCount.value = count;
      }
    });

    if (widget.initialTabIndex == 0) {
      context.read<WeeklypcBloc>().add(WeeklypcTrigger());
    }
    context.read<SuggestfriendlistBloc>().add(SuggestfriendlistTrigger());
    context.read<RewardlistBloc>().add(RewardlistEventLoaded());
    context.read<FriendlistBloc>().add(FriendlistTrigger());
    context.read<HomewalllistBloc>().add(const HomewalllistFetch(1));
    context.read<ProfillecoverchangeBloc>().add(LoadProfileCoverEvent());
  }

  void handleNavigation() async {
    // small splash animation delay
    await Future.delayed(const Duration(milliseconds: 500));

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (!mounted) return;

    // 🔥 1. FRIEND REQUEST RECEIVED
    if (initialMessage != null &&
        initialMessage.data["type"] == "FRIEND_REQ_RECV") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home(initialTabIndex: 2)),
      );
      return;
    }

    // 🔥 2. FRIEND REQUEST ACCEPTED
    if (initialMessage != null &&
        initialMessage.data["type"] == "FRIEND_REQ_ACCEPT") {
      Navigator.of(context).pushNamed("/profile");
      return;
    }

    // 🔥 3. AMEN / COMMENT / POST OPEN
    if (initialMessage != null &&
        initialMessage.data["reference_table_id"] != null) {
      Navigator.of(context).pushNamed(
        "/separate-push-post",
        arguments: {"post_id": initialMessage.data["reference_table_id"]},
      );
      return;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.white),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) async {
          if (_tabHistory.length > 1) {
            _tabHistory.removeLast();
            final previousIndex = _tabHistory.last;
            _tabController.index = previousIndex;
            _selectedIndex.value = previousIndex;
          } else {
            DateTime now = DateTime.now();
            if (ctime == null ||
                now.difference(ctime!) > const Duration(seconds: 2)) {
              ctime = now;
              showGlobalSnackBar(message: "Press Back Button Again to Exit");
            } else {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          }
        },
        child: SafeArea(
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, index, _) {
              return NestedScrollView(
                headerSliverBuilder:
                    (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: index != 1 ? 50 : 0,
                          child:
                              index != 1
                                  ? Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          'assets/images/logo-02.png',
                                          width: 120,
                                        ),
                                        SizedBox(
                                          width: 40,
                                          child: Center(
                                            child: GestureDetector(
                                              onTapDown: (
                                                TapDownDetails details,
                                              ) {
                                                const double offsetY = 20;
                                                showMenu(
                                                  context: context,
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                        details
                                                            .globalPosition
                                                            .dx,
                                                        details
                                                                .globalPosition
                                                                .dy +
                                                            offsetY,
                                                        details
                                                            .globalPosition
                                                            .dx,
                                                        details
                                                                .globalPosition
                                                                .dy +
                                                            offsetY,
                                                      ),
                                                  items: const [
                                                    PopupMenuItem(
                                                      value: "post",
                                                      child: Text(
                                                        "Create Post",
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: "reels",
                                                      child: Text(
                                                        "Create Clips",
                                                      ),
                                                    ),
                                                  ],
                                                ).then((value) {
                                                  if (value == "post") {
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamed("/createpost");
                                                  } else if (value == "reels") {
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamed("/reelspost");
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(34),
                                                  color: kPrimaryColor,
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(_buildTabBar()),
                      ),
                    ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    Hometab(key: PageStorageKey('homeTab')),
                    Reelslist(),
                    Friendsrequests(),
                    Weeklypc(),
                    Notificationtab(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, index, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: kPrimaryColor,
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.center,
                onTap: (newIndex) {
                  if (newIndex == 0) {
                    _tabHistory
                      ..clear()
                      ..add(0);
                  } else if (_tabHistory.isEmpty ||
                      _tabHistory.last != newIndex) {
                    _tabHistory.add(newIndex);
                  }
                  _selectedIndex.value = newIndex;
                  _tabController.animateTo(newIndex);
                },
                tabs: [
                  _buildTabWithBadge(
                    isSelected: index == 0,
                    filledIcon: 'assets/icons/home_filled.svg',
                    outlineIcon: 'assets/icons/home_outline.svg',
                  ),
                  _buildTab(
                    index == 1,
                    'assets/icons/reels_filled.svg',
                    'assets/icons/reels_outline.svg',
                  ),
                  _buildTab(
                    index == 2,
                    'assets/icons/friends_filled.svg',
                    'assets/icons/friends_outline.svg',
                  ),
                  _buildTab(
                    index == 3,
                    'assets/icons/pray_filled.svg',
                    'assets/icons/pray_outline.svg',
                  ),
                  _buildTab(
                    index == 4,
                    'assets/icons/notification_filled.svg',
                    'assets/icons/notification_outline.svg',
                  ),
                ],
              ),
            ),
            _buildProfileButton(),
          ],
        );
      },
    );
  }

  Widget _buildTabWithBadge({
    required bool isSelected,
    required String filledIcon,
    required String outlineIcon,
  }) {
    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            isSelected ? filledIcon : outlineIcon,
            width: 28,
            height: 28,
            colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
          ),
          Positioned(
            right: -6,
            top: -6,
            child: ValueListenableBuilder<int>(
              valueListenable: notificationCount,
              builder: (context, count, _) {
                if (count <= 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(bool isSelected, String filledIcon, String outlineIcon) {
    return Tab(
      icon: SvgPicture.asset(
        isSelected ? filledIcon : outlineIcon,
        width: 28,
        height: 28,
        colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildProfileButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/profile");
      },
      child: SizedBox(
        width: 50,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              width: 36,
              height: 36,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: const ProfileImageWidget(size: 36),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _TabBarDelegate(this.child);

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 48, // <-- এই লাইনটা যোগ হয়েছে শুধু (height fix)
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
