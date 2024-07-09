import 'package:flutter/material.dart';
import 'package:flutter_youtube_video/model/video_model.dart';
import 'package:flutter_youtube_video/service/youtube_service.dart';
import 'youtube_player_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Video> _videos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    setState(() {
      _isLoading = true;
    });

    YouTubeService youTubeService = YouTubeService();
    List<Video> videos = await youTubeService.fetchVideos('Kotlin tutorials');
    setState(() {
      _videos = videos;
      _isLoading = false;
    });
  }

  void playVideo(Video video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreen(video: video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Videos'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                return ListTile(
                  leading: Image.network(video.thumbnailUrl),
                  title: Text(video.title),
                  onTap: () {
                    playVideo(video);
                  },
                );
              },
            ),
    );
  }
}
