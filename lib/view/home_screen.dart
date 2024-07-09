import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Image.asset(
          'assets/youtube.png',
          height: 20,
        ),
        actions: [
          Image.asset(
            'assets/stream.png',
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset(
              'assets/bell.png',
              height: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/search.png',
              height: 25,
            ),
          )
        ],
      ),
      body: GetBuilder<VideoController>(
        builder: (videoController) {
          return videoController.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: videoController.videosList.length,
                      itemBuilder: (context, index) {
                        final video = videoController.videosList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              playVideo(video);
                            },
                            child: AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                curve: Curves.linearToEaseOut,
                                verticalOffset: 50.0,
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
                                          image:
                                              NetworkImage(video.thumbnailUrl),
                                        ),
                                      ),
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
                                        video.title,
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }

  void playVideo(Video video) {
    Get.to(VideoScreen(video: video),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        transition: Transition.rightToLeft);
  }
}
