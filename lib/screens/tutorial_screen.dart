import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/exercise.dart';

class TutorialScreen extends StatefulWidget {
  final Exercise exercise;

  const TutorialScreen({super.key, required this.exercise});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.exercise.tutorialUrl == null) {
      setState(() {
        _error = 'No tutorial available for this exercise';
        _isLoading = false;
      });
      return;
    }

    try {
      VideoPlayerController controller;
      
      if (widget.exercise.tutorialUrl!.startsWith('http')) {
        // Network URL
        controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.exercise.tutorialUrl!),
        );
      } else {
        // Asset path
        controller = VideoPlayerController.asset(widget.exercise.tutorialUrl!);
      }

      await controller.initialize();
      controller.setLooping(true);
      await controller.play();

      setState(() {
        _controller = controller;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tutorial: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exercise.name} Tutorial'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Video player
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : _error != null
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : _controller != null
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : const SizedBox(),
              ),
            ),
          ),

          // Controls
          if (_controller != null && !_isLoading && _error == null)
            Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller!.value.isPlaying) {
                          _controller!.pause();
                        } else {
                          _controller!.play();
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.replay,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      _controller!.seekTo(Duration.zero);
                      _controller!.play();
                    },
                  ),
                ],
              ),
            ),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      widget.exercise.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                if (widget.exercise.description != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.exercise.description!,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Watch the animation carefully and follow the proper form',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
