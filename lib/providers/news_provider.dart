import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider extends ChangeNotifier {
  NewsProvider({required ApiService apiService}) : _apiService = apiService {
    loadFavorites();
  }

  final ApiService _apiService;
  static const String _favoritesStorageKey = 'favorite_posts';

  List<PostModel> _allPosts = <PostModel>[];
  List<PostModel> _filteredPosts = <PostModel>[];
  List<PostModel> _favorites = <PostModel>[];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<PostModel> get posts => _filteredPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<PostModel> get favoritePosts => List<PostModel>.from(_favorites);

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allPosts = await _apiService.fetchPosts();
      _applySearch();
    } catch (_) {
      _errorMessage = 'Could not fetch news. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPosts(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
  }

  bool isFavorite(int postId) => _indexOfFavorite(postId) != -1;

  Future<void> toggleFavorite(PostModel post) async {
    final index = _indexOfFavorite(post.id);

    if (index != -1) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(post);
    }

    await saveFavorites();
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> favoriteJsonList =
          prefs.getStringList(_favoritesStorageKey) ?? <String>[];

      _favorites = favoriteJsonList.map((jsonItem) {
        final Map<String, dynamic> data =
            jsonDecode(jsonItem) as Map<String, dynamic>;

        return PostModel(
          id: data['id'] as int? ?? 0,
          title: data['title'] as String? ?? '',
          body: data['body'] as String? ?? '',
          imageUrl: data['imageUrl'] as String? ?? 'https://picsum.photos/200',
          publishedAt:
              DateTime.tryParse(data['publishedAt'] as String? ?? '') ??
              DateTime.now(),
        );
      }).toList();

      notifyListeners();
    } catch (_) {
      _favorites = <PostModel>[];
    }
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteJsonList = _favorites
        .map(
          (post) => jsonEncode({
            'id': post.id,
            'title': post.title,
            'body': post.body,
            'imageUrl': post.imageUrl,
            'publishedAt': post.publishedAt.toIso8601String(),
          }),
        )
        .toList();

    await prefs.setStringList(_favoritesStorageKey, favoriteJsonList);
  }

  int _indexOfFavorite(int postId) {
    return _favorites.indexWhere((post) => post.id == postId);
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredPosts = List<PostModel>.from(_allPosts);
      return;
    }

    _filteredPosts = _allPosts
        .where((post) => post.title.toLowerCase().contains(_searchQuery))
        .toList();
  }
}
