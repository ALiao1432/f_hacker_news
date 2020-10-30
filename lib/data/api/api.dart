import 'package:f_hacker_news/data/model/item.dart';

enum StoryType { best, news, top }

abstract class Api {
  static final storyTypeMap = {
    StoryType.best: 'beststories',
    StoryType.news: 'newstories',
    StoryType.top: 'topstories',
  };

  Future<Item> getItem(int id);
  Future<List<int>> getStories(StoryType type);
}

class NetworkException implements Exception {
  final String errorMsg;

  NetworkException(this.errorMsg);
}
