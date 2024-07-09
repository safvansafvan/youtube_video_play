import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_youtube_video/controller/video_controller.dart';
import 'package:flutter_youtube_video/model/video_model.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.video});

  final Video video;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final videoController = Get.find<VideoController>();
  @override
  void initState() {
    super.initState();
    videoController.controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        hideControls: false,
      ),
    );

    setState(() {});

    videoController.controller.addListener(() {
      if (videoController.controller.value.isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });

    videoController.fetchSuggetion(suggetion: 'Programing Concepts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<VideoController>(builder: (videoController) {
        return SafeArea(
          child: Stack(
            children: [
              YoutubePlayerBuilder(
                  player: YoutubePlayer(
                      controller: videoController.controller,
                      onEnded: (metaData) {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        videoController.showSuggestionState(true);
                        videoController.updateSuggestionIndexState();
                        videoController.controller.pause();
                      },
                      progressIndicatorColor: Colors.red,
                      progressColors: ProgressBarColors(
                          backgroundColor: Colors.grey[600],
                          bufferedColor: Colors.grey[500],
                          playedColor: Colors.red,
                          handleColor: Colors.red)),
                  builder: (context, player) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        player,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16)
                              .copyWith(top: 8, bottom: 16),
                          child: Text(
                            widget.video.title,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xff0A0A0A),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GetBuilder<VideoController>(
                              builder: (videoController) {
                            return videoController.suggetionLoading == true
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 100),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : AnimationLimiter(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(top: 20),
                                      itemCount: videoController
                                          .suggestedVideos.length,
                                      itemBuilder: (context, index) {
                                        final suggetion = videoController
                                            .suggestedVideos[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              playSuggestedVideo(suggetion);
                                            },
                                            child: AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              child: SlideAnimation(
                                                curve: Curves.linearToEaseOut,
                                                verticalOffset: 50.0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 200,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Colors.black12),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              suggetion
                                                                  .thumbnailUrl),
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
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 16)
                                                          .copyWith(
                                                              top: 8,
                                                              bottom: 16),
                                                      child: Text(
                                                        suggetion.title,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xff0A0A0A),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                          }),
                        ),
                      ],
                    );
                  }),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton.filled(
                  onPressed: () {
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                ),
              ),
              (videoController.showSuggestion)
                  ? Positioned(
                      top: 0, left: 0, right: 0, child: _buildSuggestionCard())
                  : const SizedBox()
            ],
          ),
        );
      }),
    );
  }

  void playSuggestedVideo(Video video) {
    final videoController = Get.find<VideoController>();
    videoController.updateIndexState(videoController.index++);
    videoController.controller.load(video.id);
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

  // --------------------------------------------build video suggestion card --------------------------------------------

  Widget _buildSuggestionCard() {
    final v = Get.find<VideoController>();
    final video = v.suggestedVideos[v.suggestionIndex];
    return GetBuilder<VideoController>(builder: (videoController) {
      return Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 145,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            video.thumbnailUrl,
                          ),
                        )),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      video.title,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(
                            Color.fromARGB(255, 44, 44, 44)),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        videoController.controller.pause();
                        videoController.showSuggestionState(false);
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () {
                        videoController.controller.load(video.id);
                        videoController.showSuggestionState(false);
                      },
                      child: const Text(
                        'Play now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
