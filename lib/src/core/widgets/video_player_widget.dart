import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String initialVideoId;

  const VideoPlayerWidget({
    Key? key,
    required this.initialVideoId,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  YoutubePlayerController? youtubePlayerController;

  @override
  void initState() {
    super.initState();
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.initialVideoId,
      params: const YoutubePlayerParams(
        autoPlay: true,
        loop: true,
        enableCaption: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: youtubePlayerController,
    );
  }
}
