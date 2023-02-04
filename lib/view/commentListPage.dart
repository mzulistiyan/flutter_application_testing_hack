import 'package:flutter/material.dart';
import 'package:flutter_application_testing_hack/model/comment.dart';
import 'package:flutter_application_testing_hack/model/story.dart';
import 'package:flutter_application_testing_hack/view/helper/color_helper.dart';
import 'package:flutter_application_testing_hack/view/helper/favorite_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentListPage extends StatefulWidget {
  final List<Comment> comments;
  final Story story;
  final int index;

  CommentListPage(
      {required this.story, required this.comments, required this.index});

  @override
  State<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  final _favHelper = FavoriteHelper();
  void _unFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(widget.story.time);
    // 12 Hour format:
    var d12 = DateFormat('MM/dd/yyyy').format(dt);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('index : ${widget.index}');
              _favHelper.saveToken(widget.index);
            },
            icon: const Icon(Icons.star),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            widget.story.title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'By : ${widget.story.by}',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Created By : $d12',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text('Deskripsi'),
          Text(
            widget.story.teks,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                return cardDetailKomentar(widget.comments, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Material cardDetailKomentar(List<Comment> comments, int index) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 300,
              child: Text(
                comments[index].text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                "${1 + index}",
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
