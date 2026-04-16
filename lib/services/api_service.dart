import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/models/post_model.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load posts. Status code: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
