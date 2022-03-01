import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayBackground extends StatefulWidget {
  final String videoAssset;
  final bool playVideo;
  final Function onVideoEnded;
  final Function onTab;

  const VideoPlayBackground(
      {Key key,
      this.playVideo,
      this.videoAssset,
      this.onVideoEnded,
      this.onTab})
      : super(key: key);

  @override
  _VideoPlayBackgroundState createState() => _VideoPlayBackgroundState();
}

class _VideoPlayBackgroundState extends State<VideoPlayBackground> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoAssset)
    // _controller = VideoPlayerController.network('https://drive.google.com/uc?id=1ZRX9Eu71MIaC604Apb6DGQywU82bjlFe')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
    _controller.addListener(() => checkVideo(widget.onVideoEnded));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InkWell(
        onTap: () {
          _controller.pause();
          widget.onTab();
        },
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size?.width ?? 0,
                  height: _controller.value.size?.height ?? 0,
                  child: widget.playVideo ? VideoPlayer(_controller) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    print("DISPOSE");
  }

  void checkVideo(onVideoEnded) {
    if (_controller.value.position == _controller.value.duration) {
      onVideoEnded();
    } else if (!widget.playVideo && _controller.value.isPlaying) {
      _controller.pause();
    }
  }
}
