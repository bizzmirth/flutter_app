import 'package:bizzmirth_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FancyVideoSlider extends StatefulWidget {
  final double tabHeight;
  final double phoneHeight;
  final List<String> videoUrls;

  const FancyVideoSlider({
    super.key,
    this.tabHeight = 500,
    this.phoneHeight = 250,
    this.videoUrls = const [
      'https://testca.uniqbizz.com/api/assets/video/slider/travel.mp4',
    ],
  });

  @override
  State<FancyVideoSlider> createState() => _FancyVideoSliderState();
}

class _FancyVideoSliderState extends State<FancyVideoSlider>
    with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentPage = 0;
  List<VideoPlayerController?> _controllers = [];
  bool _isDisposed = false;

  bool get isPhone {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width < 600;
  }

  double get height {
    return isPhone ? widget.phoneHeight : widget.tabHeight;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController();

    // ✅ make list growable to avoid "Cannot clear a fixed-length list" error
    _controllers = List<VideoPlayerController?>.filled(
      widget.videoUrls.length,
      null,
      growable: true,
    );

    // Initialize first video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _initializeController(0);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (_isDisposed) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseAllVideos();
    } else if (state == AppLifecycleState.resumed) {
      _resumeCurrentVideo();
    }
  }

  void _pauseAllVideos() {
    for (var controller in _controllers) {
      if (controller != null &&
          controller.value.isInitialized &&
          controller.value.isPlaying) {
        controller.pause();
      }
    }
  }

  void _resumeCurrentVideo() {
    if (_currentPage < _controllers.length &&
        _controllers[_currentPage] != null &&
        _controllers[_currentPage]!.value.isInitialized) {
      _controllers[_currentPage]!.play();
    }
  }

  Future<void> _initializeController(int index) async {
    if (_isDisposed ||
        index >= widget.videoUrls.length ||
        _controllers[index] != null) {
      return;
    }

    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrls[index]),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await controller.setVolume(0.0);
      await controller.setLooping(true);
      await controller.initialize();

      if (!_isDisposed && mounted) {
        setState(() {
          _controllers[index] = controller;
        });

        if (index == _currentPage &&
            WidgetsBinding.instance.lifecycleState ==
                AppLifecycleState.resumed) {
          await controller.play();
        }
      } else {
        await controller.dispose();
      }
    } catch (e) {
      Logger.error('Error initializing video $index: $e');
      if (!_isDisposed && mounted) {
        setState(() {
          _controllers[index] = null;
        });
      }
    }
  }

  Future<void> _disposeController(int index) async {
    if (index < _controllers.length && _controllers[index] != null) {
      final controller = _controllers[index]!;

      if (controller.value.isInitialized && controller.value.isPlaying) {
        await controller.pause();
      }

      await controller.dispose();

      if (mounted && !_isDisposed) {
        setState(() {
          _controllers[index] = null;
        });
      }
    }
  }

  void _handlePageChange(int newPage) {
    if (newPage == _currentPage || _isDisposed) return;

    if (_currentPage < _controllers.length &&
        _controllers[_currentPage] != null &&
        _controllers[_currentPage]!.value.isInitialized) {
      _controllers[_currentPage]!.pause();
      _controllers[_currentPage]!.seekTo(Duration.zero);
    }

    final oldPage = _currentPage;
    setState(() => _currentPage = newPage);

    _initializeController(newPage);
    if (newPage > 0) _initializeController(newPage - 1);
    if (newPage < widget.videoUrls.length - 1) {
      _initializeController(newPage + 1);
    }

    if (_controllers[newPage] != null &&
        _controllers[newPage]!.value.isInitialized) {
      _controllers[newPage]!.play();
    }

    Future.microtask(() async {
      for (int i = 0; i < _controllers.length; i++) {
        if (i < newPage - 1 || i > newPage + 1) {
          if (i != oldPage) {
            await _disposeController(i);
          }
        }
      }

      if (oldPage < newPage - 1 || oldPage > newPage + 1) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!_isDisposed) {
          await _disposeController(oldPage);
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);

    _pageController.dispose();

    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i] != null) {
        _controllers[i]!.pause();
        _controllers[i]!.dispose();
        _controllers[i] = null;
      }
    }

    // ✅ no need to clear manually — removing this prevents fixed-length list crash
    // _controllers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.videoUrls.length,
            onPageChanged: _handlePageChange,
            itemBuilder: (context, index) {
              final controller = _controllers[index];

              if (controller == null || !controller.value.isInitialized) {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }

              return Container(
                color: Colors.black,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              );
            },
          ),

          // Page indicators
          if (widget.videoUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.videoUrls.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
