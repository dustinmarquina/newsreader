import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  Future<void> _openInBrowser(BuildContext context) async {
    final uri = Uri.tryParse(article.url);
    if (uri == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid URL')));
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    if (!await canLaunchUrl(uri)) {
      messenger.showSnackBar(const SnackBar(content: Text('Could not open URL')));
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.sourceName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(article.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()),
            const SizedBox(height: 12),
            Text(article.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (article.publishedAt != null)
              Text(article.publishedAt!.toLocal().toString(),
                  style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            if (article.description != null) Text(article.description!),
            const SizedBox(height: 12),
            if (article.content != null) Text(article.content!),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _openInBrowser(context),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open in browser'),
            )
          ],
        ),
      ),
    );
  }
}
