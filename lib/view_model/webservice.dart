import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_testing_hack/model/story.dart';
import 'package:flutter_application_testing_hack/view/helper/favorite_helper.dart';
import 'package:flutter_application_testing_hack/view_model/urlHelper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Webservice {
  final _favHelper = FavoriteHelper();

  Future<Response> getStory(int storyId) async {
    final response = await http.get(
      Uri.parse(
        UrlHelper.urlForStory(storyId),
      ),
    );

    try {
      return response;
    } catch (e) {
      return response;
    }
  }

  Future<Response> getStoryFavorite() async {
    int idStory = await _favHelper.getIdStory();
    final response = http.get(
      Uri.parse(
        UrlHelper.urlForStory(idStory),
      ),
    );

    debugPrint("Response: ${response}");
    try {
      return response;
    } catch (e) {
      return response;
    }
  }

  Future<List<Response>> getCommentsByStory(Story story) async {
    return Future.wait(
      story.commentIds.take(5).map(
        (commentId) {
          return http.get(
            Uri.parse(
              UrlHelper.urlForCommentById(commentId),
            ),
          );
        },
      ),
    );
  }

  Future<List<Response>> getTopStories() async {
    final response = await http.get(Uri.parse(UrlHelper.urlForTopStories()));
    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);
      print(storyIds);
      return Future.wait(
        storyIds.take(10).map(
          (storyId) {
            return getStory(storyId);
          },
        ),
      );
    } else {
      throw Exception("Unable to fetch data!");
    }
  }
}
