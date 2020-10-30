import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:f_hacker_news/cubit/home/home_cubit.dart';
import 'package:f_hacker_news/data/api/api.dart';
import 'package:f_hacker_news/data/model/item.dart';
import 'package:f_hacker_news/router/router.gr.dart';
import 'package:f_hacker_news/ui/widget/hacker_news_item.dart';
import 'package:f_hacker_news/ui/widget/loading_heart_beat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  Timer _debounceTimer;
  StoryType _storyType = StoryType.top;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.bloc<HomeCubit>().getStories(_storyType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: CustomRefreshIndicator(
        onRefresh: _onRefresh,
        builder: (context, child, controller) {
          if (controller.isIdle) {
            return child;
          }
          return const Center(
            child: LoadingHeartBeat(),
          );
        },
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.initial:
              case HomeStatus.loading:
                return _buildLoadingState();
              case HomeStatus.success:
                return _buildLoadedState(state);
              case HomeStatus.failure:
              default:
                return _buildLoadError();
            }
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async =>
      context.bloc<HomeCubit>().refresh(_storyType);

  AppBar _buildAppBar() => AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: Search(),
            ),
          ),
        ],
        backgroundColor: const Color(0xfff4f4eb).withOpacity(.5),
        title: const Text(
          'Hacker News',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildLoadingState() {
    return const Center(
      child: LoadingHeartBeat(),
    );
  }

  Widget _buildLoadedState(HomeState state) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      itemCount:
          state.hasReachMax ? state.items.length : state.items.length + 1,
      itemBuilder: (context, id) {
        if (id >= state.items.length) {
          return const LoadingHeartBeat();
        } else {
          final item = state.items[id];
          return HackerNewsItem(
            onItemTap: _onNewsItemTap,
            item: item,
          );
        }
      },
    );
  }

  void _onNewsItemTap(Item item) {
    ExtendedNavigator.of(context).push(
      Routes.webViewPage,
      arguments: WebViewPageArguments(item: item),
    );
  }

  Widget _buildLoadError() {
    return const LoadingHeartBeat(color: Colors.red);
  }

  void _onScroll() {
    if (_isBottom) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer.cancel();
      }
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        context.bloc<HomeCubit>().getStories(_storyType);
      });
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * .9);
  }
}

class Search extends SearchDelegate {
  final _suggestItemCount = 12;
  Item item;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        ExtendedNavigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return HackerNewsItem(
      item: item,
      onItemTap: (item) => onHackerNewsItemTap(context, item),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final allItems = context.bloc<HomeCubit>().getItems();
    final suggestItems = allItems
      ..sort((i1, i2) => compareDescendants(i1.descendants, i2.descendants))
      ..sublist(0, _suggestItemCount);
    final queryItems = allItems
        .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final isQueryEmpty = query.isEmpty;
    return ListView.builder(
      itemCount: isQueryEmpty ? _suggestItemCount : queryItems.length,
      itemBuilder: (context, id) {
        return HackerNewsItem(
          item: isQueryEmpty ? suggestItems[id] : queryItems[id],
          onItemTap: (item) => onHackerNewsItemTap(context, item),
        );
      },
    );
  }

  int compareDescendants(int descendants1, int descendants2) {
    if (descendants1 == null && descendants2 == null) {
      return 0;
    }
    if (descendants1 == null) {
      return 1;
    }
    if (descendants2 == null) {
      return -1;
    }
    return descendants2 - descendants1;
  }

  void onHackerNewsItemTap(BuildContext context, Item item) {
    ExtendedNavigator.of(context).push(
      Routes.webViewPage,
      arguments: WebViewPageArguments(item: item),
    );
  }
}
