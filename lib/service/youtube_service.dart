import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/video_model.dart';

class YouTubeService {
  final String apiKey = 'AIzaSyB66WPR1LOqJCvFrpRLv514WciAC0sxG2w';

  Future<List<Video>> fetchVideos(String query) async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&q=$query&type=video&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Video> videos =
          (data['items'] as List).map((item) => Video.fromJson(item)).toList();
      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<List<Video>> fetchSuggestedVideos(String videoId) async {
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=snippet&relatedToVideoId=$videoId&type=video&key=$apiKey';

    print('Requesting URL: $url'); // Log the URL for debugging

    final response = await http.get(Uri.parse(url));

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

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
