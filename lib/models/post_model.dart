class PostModel {
  final int id;
  final String title;
  final String body;
  final String imageUrl;
  final DateTime publishedAt;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final postId = json['id'] as int? ?? 0;

    return PostModel(
      id: postId,
      title: (json['title'] as String? ?? '').trim(),
      body: (json['body'] as String? ?? '').trim(),
      imageUrl: 'https://picsum.photos/seed/news-$postId/600/360',
      publishedAt: DateTime.now().subtract(Duration(days: postId % 7)),
    );
  }
}
