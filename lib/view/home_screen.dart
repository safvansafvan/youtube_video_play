import 'package:flutter/material.dart';
import 'package:flutter_youtube_video/controller/video_controller.dart';
import 'package:flutter_youtube_video/model/video_model.dart';
import 'package:get/get.dart';
import 'youtube_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Get.find<VideoController>().fetchVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Videos'),
      ),
      body: GetBuilder<VideoController>(builder: (videoController) {
        return videoController.isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ListView.builder(
                  itemCount: videoController.videosList.length,
                  itemBuilder: (context, index) {
                    final video = videoController.videosList[index];
                    return ListTile(
                      leading: Image.network(video.thumbnailUrl),
                      title: Text(video.title),
                      onTap: () {
                        videoController.updateIndexState(index);
                        playVideo(video, context);
                      },
                    );
                  },
                ),
              );
      }),
    );
  }

  void playVideo(Video video, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreen(video: video),
      ),
    );
  }
}
