import 'package:flutter/material.dart';
import 'package:flutter_youtube_video/model/video_model.dart';
import 'package:flutter_youtube_video/service/youtube_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final Video video;

  const YouTubePlayerScreen({super.key, required this.video});

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;
  List<Video> _suggestedVideos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    setState(() {
      _isLoading = true;
    });

    YouTubeService youTubeService = YouTubeService();
    List<Video> videos = await youTubeService.fetchVideos('Kotlin tutorials');
    setState(() {
      _suggestedVideos = videos;
      _isLoading = false;
    });
  }

  void playSuggestedVideo(Video video) {
    _controller.load(video.id);
    fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing ${widget.video.title}'),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _suggestedVideos.length,
                    itemBuilder: (context, index) {
                      final video = _suggestedVideos[index];
                      return ListTile(
                        leading: Image.network(video.thumbnailUrl),
                        title: Text(video.title),
                        onTap: () {
                          playSuggestedVideo(video);
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
