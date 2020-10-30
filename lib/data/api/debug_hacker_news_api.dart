import 'dart:convert';

import 'package:f_hacker_news/data/model/item.dart';
import 'package:f_hacker_news/injection/injection.dart';
import 'package:injectable/injectable.dart';

import 'api.dart';

@Singleton(as: Api, env: [Env.debug])
class DebugHackerNewsApi implements Api {
  @override
  Future<Item> getItem(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    const fakeData = '''{
          "by": "dinomad",
          "descendants": 3,
          "id": 24588122,
          "score": 4,
          "time": 1601026151,
          "title": "Things Elixir's Phoenix Framework Does Right",
          "type": "story",
          "url": "https://scorpil.com/post/things-elixirs-phoenix-framework-does-right/"
        }''';
    final json = jsonDecode(fakeData) as Map<String, dynamic>;
    final item = Item.fromJson(json);
    return item;
  }

  @override
  Future<List<int>> getStories(StoryType type) async {
    await Future.delayed(const Duration(seconds: 5));
    const fakeData = [
      24752348,
      24748488,
      24751212,
      24751540,
      24750263,
      24750588,
      24745290,
      24751264,
      24744437,
      24748793,
      24746160,
      24751786,
      24749238,
      24750620,
      24750110,
      24743716,
      24744928,
      24743984,
      24744867,
      24744879,
      24744445,
      24745194,
      24745563,
      24743484,
      24745281,
      24737911,
      24749040,
      24747927
    ];
    return List.from(fakeData);
  }
}
