// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/model/item.dart';
import '../ui/page/home_page.dart';
import '../ui/page/webview_page.dart';

class Routes {
  static const String homePage = '/';
  static const String webViewPage = '/web-view-page';
  static const all = <String>{
    homePage,
    webViewPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homePage, page: HomePage),
    RouteDef(Routes.webViewPage, page: WebViewPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    HomePage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomePage(),
        settings: data,
      );
    },
    WebViewPage: (data) {
      final args = data.getArgs<WebViewPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => WebViewPage(args.item),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// WebViewPage arguments holder class
class WebViewPageArguments {
  final Item item;
  WebViewPageArguments({@required this.item});
}
