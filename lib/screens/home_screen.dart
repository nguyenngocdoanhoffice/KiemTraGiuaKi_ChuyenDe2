import 'package:flutter/material.dart';
import 'package:my_app/screens/about_screen.dart';
import 'package:my_app/screens/contact_screen.dart';
import 'package:my_app/providers/news_provider.dart';
import 'package:my_app/screens/detail_screen.dart';
import 'package:my_app/screens/favorite_screen.dart';
import 'package:my_app/screens/policy_screen.dart';
import 'package:my_app/widgets/news_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateFromDrawer(Widget screen) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  void initState() {
    super.initState();

    // Load news once after first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NewsProvider>();
      if (provider.posts.isEmpty) {
        _loadNews();
      }
    });
  }

  Future<void> _loadNews() async {
    final provider = context.read<NewsProvider>();
    await provider.fetchPosts();

    if (!mounted) {
      return;
    }

    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
      provider.clearError();
    }
  }

  void _openFavorites() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(curved),
              child: const FavoriteScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.newspaper, size: 42, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'News App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _navigateFromDrawer(const HomeScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About (Giới thiệu)'),
              onTap: () => _navigateFromDrawer(const AboutScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact (Liên hệ)'),
              onTap: () => _navigateFromDrawer(const ContactScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Policy (Chính sách)'),
              onTap: () => _navigateFromDrawer(const PolicyScreen()),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Personal News'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadNews,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh news',
          ),
          IconButton(
            onPressed: _openFavorites,
            icon: const Icon(Icons.favorite_outline),
            tooltip: 'Favorites',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: provider.searchPosts,
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
            Expanded(child: _buildBody(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(NewsProvider provider) {
    if (provider.isLoading && provider.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadNews,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.newspaper_outlined,
                        size: 56,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        provider.searchQuery.isEmpty
                            ? 'No news available.'
                            : 'No result matches your search.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pull down to refresh news list.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNews,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.posts.length,
        itemBuilder: (context, index) {
          final post = provider.posts[index];

          return NewsCard(
            post: post,
            isFavorite: provider.isFavorite(post.id),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DetailScreen(post: post)),
              );
            },
          );
        },
      ),
    );
  }
}
