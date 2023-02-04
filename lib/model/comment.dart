import 'package:flutter_application_testing_hack/model/story.dart';

class Comment {
  String text = "";
  final int commentId;
  Story? story;
  Comment({
    required this.commentId,
    required this.text,
  });

  factory Comment.fromJSON(Map<String, dynamic> json) {
    return Comment(
      commentId: json["id"],
      text: json["text"],
    );
  }
}
