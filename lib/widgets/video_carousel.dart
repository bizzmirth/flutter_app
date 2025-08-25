import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FancyVideoSlider extends StatefulWidget {
  final double tabHeight;
  final double phoneHeight;
  final List<String> videoUrls;

  const FancyVideoSlider({
    Key? key,
    this.tabHeight = 500,
    this.phoneHeight = 250,
    this.videoUrls = const [
      // "https://testca.uniqbizz.com/api/assets/video/slider/info.mp4",
      "https://testca.uniqbizz.com/api/assets/video/slider/travel.mp4",
    ],
  }) : super(key: key);

  @override
  _FancyVideoSliderState createState() => _FancyVideoSliderState();
}

class _FancyVideoSliderState extends State<FancyVideoSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  List<VideoPlayerController?> _controllers = [];
  bool _isDisposed = false;

  // Determine if the device is a phone based on screen width
  bool get isPhone {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width < 600; // Typical breakpoint for phones
  }

  // Get the appropriate height based on device type
  double get height {
    return isPhone ? widget.phoneHeight : widget.tabHeight;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);

    // Initialize with null controllers
    _controllers =
        List<VideoPlayerController?>.filled(widget.videoUrls.length, null);

    // Only initialize the first video
    _initializeController(0);
  }

  Future<void> _initializeController(int index) async {
    if (_isDisposed ||
        index >= widget.videoUrls.length ||
        _controllers[index] != null) return;

    try {
      final controller = VideoPlayerController.network(
        widget.videoUrls[index],
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      controller.setVolume(0.0);
      controller.setLooping(true);

      await controller.initialize();

      if (!_isDisposed) {
        setState(() {
          _controllers[index] = controller;
        });

        // Auto-play if it's the current page
        if (index == _currentPage) {
          controller.play();
        }
      }
    } catch (e) {
      print('Error initializing video $index: $e');
      // Don't rethrow, just continue
    }
  }

  void _disposeController(int index) {
    if (index < _controllers.length && _controllers[index] != null) {
      _controllers[index]!.dispose();
      setState(() {
        _controllers[index] = null;
      });
    }
  }

  void _handlePageChange(int newPage) {
    if (newPage == _currentPage) return;

    // Pause and reset old video
    if (_currentPage < _controllers.length &&
        _controllers[_currentPage] != null) {
      _controllers[_currentPage]!.pause();
      _controllers[_currentPage]!.seekTo(Duration.zero);
    }

    setState(() => _currentPage = newPage);

    // Initialize current + adjacent
    _initializeController(newPage);
    if (newPage > 0) _initializeController(newPage - 1);
    if (newPage < widget.videoUrls.length - 1)
      _initializeController(newPage + 1);

    // Play current video when ready
    if (_controllers[newPage] != null &&
        _controllers[newPage]!.value.isInitialized) {
      _controllers[newPage]!.play();
    }

    // Dispose all others to free buffers
    for (int i = 0; i < _controllers.length; i++) {
      if (i < newPage - 1 || i > newPage + 1) {
        _disposeController(i);
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();

    for (var controller in _controllers) {
      if (controller != null) {
        controller.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, // Use the responsive height
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
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }

              return Container(
                color: Colors.black,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              );
            },
          ),

          // Page indicators
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
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
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
