import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:f_hacker_news/data/api/api.dart';
import 'package:f_hacker_news/data/model/item.dart';
import 'package:f_hacker_news/injection/injection.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final api = getIt<Api>();
  Map<int, Item> _items = {};
  final itemPerLoad = 25;
  int currentItemIndex;
  List<int> stories;

  HomeCubit() : super(const HomeState());

  Future<void> refresh(StoryType type) async {
    emit(
      state.copyWith(
        status: HomeStatus.initial,
      ),
    );
    await getStories(type);
  }

  Future<void> getStories(StoryType type) async {
    if (state.hasReachMax) {
      emit(state);
      return;
    }
    try {
      if (state.status == HomeStatus.initial) {
        stories = await api.getStories(type);
        await _getItems(stories.sublist(0, itemPerLoad));
        emit(state.copyWith(
          status: HomeStatus.success,
          items: _items.values.toList(),
        ));
        return;
      }
      if (currentItemIndex >= stories.length) {
        emit(state.copyWith(hasReachMax: true));
        return;
      }
      final int subListEndIndex = currentItemIndex + itemPerLoad;
      final subStories = stories.sublist(
        currentItemIndex,
        subListEndIndex > stories.length ? stories.length : subListEndIndex,
      );
      await _getItems(subStories);
      emit(state.copyWith(
        status: HomeStatus.success,
        items: _items.values.toList(),
        hasReachMax: false,
      ));
    } on Exception {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _getItems(List<int> ids) async {
    await Future.wait(ids.map((s) => _getItem(s)));
    currentItemIndex = _items.length;
  }

  Future<void> _getItem(int id) async {
    try {
      final item = await api.getItem(id);
      _items.putIfAbsent(id, () => item);
    } on NetworkException {}
  }

  List<Item> getItemsFromRange(int start, int end) {
    return _items.values.toList().sublist(start, end);
  }

  List<Item> getItems() {
    return _items.values.toList();
  }
}
