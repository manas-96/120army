import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import '../model/listpost_model.dart';
import '../services/main_service.dart';
import '../exports.dart';
import 'widget/postdetailstext.dart';
import 'widget/likecommentshare.dart';

class Reelslist extends StatefulWidget {
  const Reelslist({super.key});

  @override
  State<Reelslist> createState() => _ReelslistState();
}

class _ReelslistState extends State<Reelslist> {
  List<PostlistDatum> reelsList = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  final PageController _pageController = PageController();

  int _currentPlayingIndex = 0;
  int _preloadIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadReels();
    _pageController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final currentPage = _pageController.page?.round() ?? 0;
    if (currentPage != _currentPlayingIndex) {
      setState(() {
        _currentPlayingIndex = currentPage;
        _preloadIndex = currentPage + 1;
      });
    }

    if (_pageController.position.pixels >=
            _pageController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMore) {
      _loadMoreReels();
    }
  }

  Future<void> _loadReels() async {
    try {
      setState(() {
        isLoading = true;
        currentPage = 1;
      });

      final data = await MainService().reelsListService(page: currentPage);
      final loadedReels = data.data.where((r) => r.files.isNotEmpty).toList();

      setState(() {
        reelsList = loadedReels;
        isLoading = false;
        hasMore = data.data.isNotEmpty;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients && reelsList.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _pageController.jumpToPage(0);
          });
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error loading Clips: $e");
    }
  }

  Future<void> _loadMoreReels() async {
    if (isLoadingMore || !hasMore) return;

    try {
      setState(() {
        isLoadingMore = true;
      });

      final nextPage = currentPage + 1;
      final data = await MainService().reelsListService(page: nextPage);
      final newReels = data.data.where((r) => r.files.isNotEmpty).toList();

      setState(() {
        reelsList.addAll(newReels);
        currentPage = nextPage;
        isLoadingMore = false;
        hasMore = data.data.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        isLoadingMore = false;
      });
      log("Error loading more Clips: $e");
    }
  }

  Future<void> _refreshReels() async {
    try {
      final data = await MainService().reelsListService(page: 1);
      final loadedReels = data.data.where((r) => r.files.isNotEmpty).toList();

      setState(() {
        reelsList = loadedReels;
        currentPage = 1;
        hasMore = data.data.isNotEmpty;
        _currentPlayingIndex = 0;
        _preloadIndex = -1;
      });

      if (_pageController.hasClients && reelsList.isNotEmpty) {
        _pageController.jumpToPage(0);
      }
    } catch (e) {
      log("Error refreshing Clips: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Refresh failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteReel(int index, int reelId) {
    setState(() {
      reelsList.removeAt(index);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients && reelsList.isNotEmpty) {
        final newIndex =
            index >= reelsList.length ? reelsList.length - 1 : index;
        _pageController.jumpToPage(newIndex);
      }
    });

    MainService().deletepostService(id: reelId);
  }

  @override
  void dispose() {
    _pageController.removeListener(_scrollListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.white,
        strokeWidth: 2.0,
        onRefresh: _refreshReels,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: reelsList.length + (hasMore ? 1 : 0),
          onPageChanged: (index) {
            if (index < reelsList.length) {
              setState(() {
                _currentPlayingIndex = index;
                _preloadIndex = index + 1;
              });
            }
          },
          itemBuilder: (context, index) {
            if (index >= reelsList.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final reel = reelsList[index];
            return ReelItem(
              key: ValueKey('reel_${reel.id}_$index'),
              videoUrl: reel.files[0].fileUrls,
              index: index,
              item: reel,
              onDelete: () => _deleteReel(index, reel.id),
              shouldPlay: index == _currentPlayingIndex,
              shouldPreload:
                  index == _preloadIndex && _preloadIndex < reelsList.length,
            );
          },
        ),
      ),
    );
  }
}

// -------------------- Reel Item --------------------
class ReelItem extends StatefulWidget {
  final String videoUrl;
  final int index;
  final PostlistDatum item;
  final VoidCallback onDelete;
  final bool shouldPlay;
  final bool shouldPreload;

  const ReelItem({
    super.key,
    required this.videoUrl,
    required this.index,
    required this.item,
    required this.onDelete,
    required this.shouldPlay,
    required this.shouldPreload,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  BetterPlayerController? _controller;
  bool _isDisposed = false;
  bool _isLoading = true; // ✅ loader flag
  bool isLiking = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _initializePlayer();
    }

    if (oldWidget.shouldPlay != widget.shouldPlay) {
      _handlePlayPause();
    }
  }

  void _initializePlayer() {
    final screenAspectRatio =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .width /
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .height;
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
    );

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: widget.shouldPlay,
        looping: true,
        expandToFill: true,
        aspectRatio: 9 / 16,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
      ),

      betterPlayerDataSource: dataSource,
    );

    _controller!.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        setState(() {
          _isLoading = false; // video ready
        });
      }
    });

    if (!widget.shouldPlay) {
      _controller!.pause();
    }
  }

  void _handlePlayPause() {
    if (_controller == null || _isDisposed) return;

    if (widget.shouldPlay) {
      _controller!.play();
    } else {
      _controller!.pause();
    }
  }

  void _disposeController() {
    _isDisposed = true;
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child:
              _controller != null
                  ? _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : LayoutBuilder(
                        builder: (context, constraints) {
                          final videoSize =
                              _controller!.videoPlayerController?.value.size;

                          final double innerWidth =
                              videoSize?.width ?? constraints.maxWidth;
                          final double innerHeight =
                              videoSize?.height ?? constraints.maxHeight;

                          // check vertical vs horizontal
                          final isVertical =
                              (videoSize?.height ?? 1) >=
                              (videoSize?.width ?? 1);

                          return SizedBox.expand(
                            child: FittedBox(
                              fit: isVertical ? BoxFit.cover : BoxFit.contain,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: innerWidth,
                                height: innerHeight,
                                child: BetterPlayer(controller: _controller!),
                              ),
                            ),
                          );
                        },
                      )
                  : const Center(child: CircularProgressIndicator()),
        ),

        Positioned(
          left: 16,
          bottom: 30,
          right: 16,
          child: Postdetailstext(
            index: widget.index,
            item: widget.item,
            onDelete: widget.onDelete,
            reele: true,
          ),
        ),

        Positioned(
          right: 10,
          bottom: 120,
          child: Likecommentshare(
            reels: true,
            postid: widget.item.id.toString(),
            commentcount: widget.item.commentCount,
            likescount: widget.item.likes,
            isLiked: widget.item.isLiked,
            author_id: widget.item.userId.toString(),
            main_post_id: widget.item.id.toString(),
            onLikeToggle: () async {
              if (isLiking) return; // rapid tap ignore
              setState(() => isLiking = true); // lock

              final currentLiked = widget.item.isLiked == 1; // 1 = liked

              try {
                final response = await MainService().likeunlikeService(
                  id: widget.item.id,
                  isLiked: currentLiked,
                  author_id: widget.item.userId.toString(),
                  type: "reels",
                  author_name: widget.item.name,
                );

                // API success হলে update
                if (response?.status == "success") {
                  setState(() {
                    widget.item.isLiked = currentLiked ? 0 : 1;
                    widget.item.likes += currentLiked ? -1 : 1;
                  });
                }
              } finally {
                if (mounted) setState(() => isLiking = false); // unlock
              }
            },
          ),
        ),

        // ✅ Bottom Linear Progress Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child:
              _controller != null
                  ? BetterPlayerProgressBar(controller: _controller!)
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// -------------------- Custom Progress Bar --------------------
class BetterPlayerProgressBar extends StatefulWidget {
  final BetterPlayerController controller;
  const BetterPlayerProgressBar({super.key, required this.controller});

  @override
  State<BetterPlayerProgressBar> createState() =>
      _BetterPlayerProgressBarState();
}

class _BetterPlayerProgressBarState extends State<BetterPlayerProgressBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.videoPlayerController?.addListener(_update);
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.videoPlayerController?.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = widget.controller.videoPlayerController?.value.position;
    final duration = widget.controller.videoPlayerController?.value.duration;

    double progress = 0.0;
    if (position != null && duration != null && duration.inMilliseconds > 0) {
      progress = position.inMilliseconds / duration.inMilliseconds;
    }

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.white.withOpacity(0.3),
      color: Colors.blue,
      minHeight: 3,
    );
  }
}
