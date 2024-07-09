import 'package:flutter/material.dart';
import 'package:flutter_youtube_video/controller/video_controller.dart';
import 'package:flutter_youtube_video/model/video_model.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final Video video;

  const YouTubePlayerScreen({super.key, required this.video});

  @override
  State<YouTubePlayerScreen> createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoController = Get.find<VideoController>();
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
    videoController.fetchSuggetion(suggetion: 'Programing Concepts');
  }

  void playSuggestedVideo(Video video) {
    final videoController = Get.find<VideoController>();
    _controller.load(video.id);
    videoController.fetchSuggetion(suggetion: 'Advanced Programing Concepts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
            child: Text(
              widget.video.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black54),
            ),
          ),
          GetBuilder<VideoController>(builder: (videoController) {
            return videoController.suggetionLoading == true
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(),
                  ))
                : Expanded(
                    child: ListView.builder(
                      itemCount: videoController.suggestedVideos.length,
                      itemBuilder: (context, index) {
                        final suggetion =
                            videoController.suggestedVideos[index];
                        return ListTile(
                          leading: Image.network(suggetion.thumbnailUrl),
                          title: Text(suggetion.title),
                          onTap: () {
                            playSuggestedVideo(suggetion);
                          },
                        );
                      },
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
