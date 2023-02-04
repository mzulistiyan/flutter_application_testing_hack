import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_testing_hack/model/comment.dart';
import 'package:flutter_application_testing_hack/model/story.dart';
import 'package:flutter_application_testing_hack/view/helper/color_helper.dart';
import 'package:flutter_application_testing_hack/view_model/webservice.dart';
import 'package:google_fonts/google_fonts.dart';

import 'commentListPage.dart';

class TopArticleList extends StatefulWidget {
  @override
  _TopArticleListState createState() => _TopArticleListState();
}

class _TopArticleListState extends State<TopArticleList> {
  List<Story> _stories = [];
  Story? storyFav;

  @override
  void initState() {
    _populateTopStories();
    _getStoryFavorite();
    super.initState();
  }

  void _getStoryFavorite() async {
    final response = await Webservice().getStoryFavorite();

    setState(() {
      final story = Story.fromJSON(jsonDecode(response.body));
      storyFav = story;
    });
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  void _navigateToShowCommentsPage(
      BuildContext context, int index, int idStory) async {
    final story = _stories[index];
    final responses = await Webservice().getCommentsByStory(story);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentListPage(
          story: story,
          comments: comments,
          index: idStory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Top Stories"),
        backgroundColor: ColorHelper.primary,
      ),
      body: Column(
        children: [
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.black.withOpacity(0.3),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    storyFav?.title ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Score : 100',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Jumlah Komentar : 10',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: const Color(0xff999999),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _populateTopStories();
                _getStoryFavorite();
              },
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                // Generate 100 widgets that display their index in the List.
                children: List.generate(_stories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToShowCommentsPage(
                          context, index, _stories[index].id);
                    },
                    child: cardDetailTimeline(
                      _stories,
                      index,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );

    //   body: ListView.builder(
    //     itemCount: _stories.length,
    //     itemBuilder: (_, index) {
    //       return ListTile(
    //         onTap: () {
    //           _navigateToShowCommentsPage(context, index);
    //         },
    //         title: Text(_stories[index].title,
    //             style: const TextStyle(fontSize: 18)),
    //         trailing: Container(
    //           decoration: const BoxDecoration(
    //               color: Colors.green,
    //               borderRadius: BorderRadius.all(Radius.circular(16))),
    //           alignment: Alignment.center,
    //           width: 50,
    //           height: 50,
    //           child: Padding(
    //             padding: const EdgeInsets.all(12.0),
    //             child: Text(
    //               "${_stories[index].commentIds.length}",
    //               style: const TextStyle(
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  Material cardDetailTimeline(List<Story> _stories, int index) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.black.withOpacity(0.3),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _stories[index].title,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Score : ${_stories[index].score}',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Jumlah Komentar : ${_stories[index].commentIds.length}',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: const Color(0xff999999),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
