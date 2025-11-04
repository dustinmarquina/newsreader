import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/news_service.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> _futureArticles;

  @override
  void initState() {
    super.initState();
    _futureArticles = NewsService.fetchTopHeadlines();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureArticles = NewsService.fetchTopHeadlines();
    });
    await _futureArticles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Article>>(
          future: _futureArticles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final articles = snapshot.data ?? [];
            if (articles.isEmpty) {
              return const Center(child: Text('No articles found'));
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final a = articles[index];
                return ListTile(
                  leading: a.urlToImage != null
                      ? Image.network(a.urlToImage!,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image))
                      : const Icon(Icons.image, size: 48),
                  title: Text(a.title,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(a.sourceName),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(article: a),
                    ));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
