import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/video.dart';

const API_KEY = 'AIzaSyDY6VfmiP9u4sDZF7FG6gEJdesJuJBkz_k';
const API_KEY_THAIS = 'AIzaSyAepTnzGeA7Ji9AFMIbpf1SpEzJxaKDBnw';
//const api1 = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10";
//const api2 = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken";
//const api3 = "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json";

class Api {

  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {

    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY_THAIS&maxResults=10"
    );

    return decode(response);

  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY_THAIS&maxResults=10&pageToken=$_nextToken"
    );

    return decode(response);
  }

  List<Video> decode(http.Response response) {

    if (response.statusCode == 200) {
      var decode = json.decode(response.body);

      _nextToken = decode['nextPageToken'];

      List<Video> videos = decode['items'].map<Video>(
          (map){
            return Video.fromJson(map);
          }
      ).toList();

      return videos;
    } else {
      throw Exception("Failed to load videos");
    }

  }
}