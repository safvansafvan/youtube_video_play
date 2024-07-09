import 'dart:developer';

import 'package:flutter_youtube_video/model/video_model.dart';
import 'package:flutter_youtube_video/service/youtube_service.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  List<Video> videosList = [];
  List<Video> suggestedVideos = [];
  bool isLoading = false;
  bool suggetionLoading = false;
  int index = 0;

  Future<void> fetchVideos() async {
    isLoading = true;
    update();
    List<Video> videos =
        await YouTubeService.fetchVideos('Kotlin and android tutorials');
    videosList = videos;
    isLoading = false;
    update();
  }

  Future<void> fetchSuggetion({String? suggetion}) async {
    suggetionLoading = true;
    List<Video> videos =
        await YouTubeService.fetchVideos(suggetion ?? 'Programing');
    suggestedVideos.clear();
    suggestedVideos = videos;
    suggestedVideos.removeAt(index);
    suggetionLoading = false;
    update();
  }

  void updateIndexState(int ind) {
    index = ind;
    log(index.toString());
    update();
  }

  // @override
  // void onInit() {
  //   fetchVideos();
  //   super.onInit();
  // }
}
