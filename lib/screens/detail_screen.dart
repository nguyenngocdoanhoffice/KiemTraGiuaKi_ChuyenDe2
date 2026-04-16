import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/providers/news_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    final isFavorite = provider.isFavorite(post.id);
    final dateText = DateFormat('dd MMM yyyy').format(post.publishedAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => provider.toggleFavorite(post),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.redAccent : null,
            ),
            tooltip: 'Favorite',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                post.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image_outlined, size: 42),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 18),
                const SizedBox(width: 6),
                Text(
                  dateText,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              post.body,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
