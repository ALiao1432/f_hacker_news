import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:f_hacker_news/data/api/api.dart';
import 'package:f_hacker_news/data/api/interceptor/retry_on_connection_change_interceptor.dart';
import 'package:f_hacker_news/data/model/item.dart';
import 'package:f_hacker_news/injection/injection.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: Api, env: [Env.release])
class HackerNewsApi implements Api {
  final _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  final _dio = Dio();

  HackerNewsApi() {
    _dio
      ..options.baseUrl = _baseUrl
      ..options.connectTimeout = 10 * 1000
      ..options.receiveTimeout = 10 * 1000
      ..interceptors.add(
        RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
            dio: _dio,
            connectivity: Connectivity(),
          ),
        ),
      );
  }

  @override
  Future<Item> getItem(int id) async {
    try {
      final response = await _dio.request(
        '/item/$id.json',
        options: RequestOptions(method: 'GET'),
      );
      final data = response.data as Map<String, dynamic>;
      final result = Item.fromJson(data);
      return Future.value(result);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<List<int>> getStories(StoryType type) async {
    try {
      final response = await _dio.request(
        '/${Api.storyTypeMap[type]}.json',
        options: RequestOptions(method: 'GET'),
      );
      return Future.value(List<int>.from(response.data as Iterable));
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
