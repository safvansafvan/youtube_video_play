import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        showLiveFullscreenButton: false,
        hideControls: false,
      ),
    );
    videoController.fetchSuggetion(suggetion: 'Programing Concepts');
  }

  void playSuggestedVideo(Video video) {
    final videoController = Get.find<VideoController>();
    videoController.updateIndexState(videoController.index++);
    _controller.load(video.id);
    videoController.fetchSuggetion(suggetion: handleSugeetions());
  }

  String handleSugeetions() {
    final videoController = Get.find<VideoController>();
    switch (videoController.index) {
      case 1:
        return 'Advanced Programing Concepts';
      case 2:
        return 'Node js And Flutter';

      case 3:
        return 'Oops concepts';

      case 4:
        return 'Data structure and algorithm';
      case 5:
        return 'Mechine learning and Ai';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(top: 8, bottom: 16),
              child: Text(
                widget.video.title,
                maxLines: 2,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff0A0A0A)),
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
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: videoController.videosList.length,
                        itemBuilder: (context, index) {
                          final suggetion =
                              videoController.suggestedVideos[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                playSuggestedVideo(suggetion);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                suggetion.thumbnailUrl))),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/play.png',
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 16)
                                        .copyWith(top: 8, bottom: 16),
                                    child: Text(
                                      suggetion.title,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xff0A0A0A)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
