# News Reader App

This is a minimal Flutter News Reader that fetches top headlines from NewsAPI.org and displays them in a list. It demonstrates usage of `http`, `FutureBuilder`, loading indicators, and error handling.

Setup

1. Install Flutter (if you haven't): https://flutter.dev/docs/get-started/install
2. In `lib/constants.dart` replace `YOUR_API_KEY_HERE` with your NewsAPI key (get one at https://newsapi.org/).
3. From the project folder run:

```bash
flutter pub get
flutter run
```

Notes

- The app uses `http` to fetch data and `url_launcher` to open articles in the browser.
- API limits: free NewsAPI keys are rate-limited; avoid rapid refresh loops.

Files added

- `lib/main.dart` — app entrypoint and routing.
- `lib/constants.dart` — API key and base URL.
- `lib/models/article.dart` — article model and JSON parsing.
- `lib/services/news_service.dart` — HTTP calls and error handling.
- `lib/screens/home_screen.dart` — list UI using `FutureBuilder`.
- `lib/screens/article_detail_screen.dart` — details + open in browser.

If you want, I can:

- Add search or category filters
- Add caching or offline mode
- Add unit tests for the service
