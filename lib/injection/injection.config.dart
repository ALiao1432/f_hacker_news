// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../data/api/api.dart';
import '../data/api/debug_hacker_news_api.dart';
import '../data/api/hacker_news_api.dart';

/// Environment names
const _debug = 'debug';
const _release = 'release';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);

  // Eager singletons must be registered in the right order
  gh.singleton<Api>(DebugHackerNewsApi(), registerFor: {_debug});
  gh.singleton<Api>(HackerNewsApi(), registerFor: {_release});
  return get;
}
