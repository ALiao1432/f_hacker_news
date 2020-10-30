part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Item> items;
  final bool hasReachMax;

  const HomeState({
    this.status = HomeStatus.initial,
    this.items = const <Item>[],
    this.hasReachMax = false,
  });

  @override
  List<Object> get props => [status, items, hasReachMax];

  HomeState copyWith({
    HomeStatus status,
    List<Item> items,
    bool hasReachMax,
  }) =>
      HomeState(
        status: status ?? this.status,
        items: items ?? this.items,
        hasReachMax: hasReachMax ?? this.hasReachMax,
      );
}
