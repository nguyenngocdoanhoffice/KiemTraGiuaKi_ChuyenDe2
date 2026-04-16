import 'package:flutter/material.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  NewsProvider({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  final Set<int> _favoriteIds = <int>{};

  List<PostModel> _allPosts = <PostModel>[];
  List<PostModel> _filteredPosts = <PostModel>[];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<PostModel> get posts => _filteredPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<PostModel> get favoritePosts =>
      _allPosts.where((post) => _favoriteIds.contains(post.id)).toList();

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

  bool isFavorite(int postId) => _favoriteIds.contains(postId);

  void toggleFavorite(PostModel post) {
    if (isFavorite(post.id)) {
      _favoriteIds.remove(post.id);
    } else {
      _favoriteIds.add(post.id);
    }
    notifyListeners();
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
