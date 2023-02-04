class Story {
  final String title;
  List<int> commentIds = [];
  final int? score;
  final String by;
  final String teks;
  final int time;
  final int id;

  Story({
    required this.title,
    required this.commentIds,
    this.score,
    required this.by,
    required this.teks,
    required this.time,
    required this.id,
  });

  factory Story.fromJSON(Map<String, dynamic> json) {
    return Story(
      title: json["title"],
      score: json["score"],
      commentIds: json["kids"] == null ? [] : json["kids"].cast<int>(),
      by: json["by"] ?? '',
      teks: json["text"] ?? 'Teks kosong',
      time: json["time"] ?? 0,
      id: json["id"] ?? 0,
    );
  }
}
