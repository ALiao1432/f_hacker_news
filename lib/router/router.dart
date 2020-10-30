import 'package:auto_route/auto_route_annotations.dart';
import 'package:f_hacker_news/ui/page/home_page.dart';
import 'package:f_hacker_news/ui/page/webview_page.dart';

@MaterialAutoRouter(routes: [
  MaterialRoute(page: HomePage, initial: true),
  MaterialRoute(page: WebViewPage),
])
class $Router {}
