import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/video_model.dart';

class YouTubeService {
  final String apiKey = 'AIzaSyB66WPR1LOqJCvFrpRLv514WciAC0sxG2w';

  Future<List<Video>> fetchVideos(String query) async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey';
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

  Future<List<Video>> fetchSuggestions(String videoId) async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?relatedToVideoId=$videoId&type=video&part=snippet&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Video> videos =
          (data['items'] as List).map((item) => Video.fromJson(item)).toList();
      return videos;
    } else {
      print('Failed to load video suggestions: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load video suggestions');
    }
  }
}
