import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../model/video_model.dart';

class YouTubeService {
  //static String apiKey = 'AIzaSyB66WPR1LOqJCvFrpRLv514WciAC0sxG2w';
  //static String apiKey = 'AIzaSyBSlNBYkvE4bkrsY50GSpoNWTlhNAfrOmI';
  static String apiKey = 'AIzaSyCJZN05G9fV-C3aoVJZ7DPcF7OoyYLSCT4';

  static Future<List<Video>> fetchVideos(String query) async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&q=$query&type=video&key=$apiKey';
    log(url.toString());
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log(response.body, name: 'response');
      final List<Video> videos =
          (data['items'] as List).map((item) => Video.fromJson(item)).toList();
      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  static Future<List<Video>> fetchSuggestedVideos(String videoId) async {
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&relatedToVideoId=$videoId&type=video&key=$apiKey';
    log('Requesting URL: $url');
    final response = await http.get(Uri.parse(url));
    log('Response status code: ${response.statusCode}');
    log('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Video> suggestedVideos =
          (data['items'] as List).map((item) => Video.fromJson(item)).toList();
      return suggestedVideos;
    } else {
      final error = json.decode(response.body);
      throw Exception(
          'Failed to load suggested videos: ${error['error']['message']}');
    }
  }
}
