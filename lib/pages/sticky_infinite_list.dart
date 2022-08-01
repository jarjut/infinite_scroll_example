import 'package:flutter/material.dart';
import 'package:infinite_scroll/item.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

class StickyInfiniteListPage extends StatefulWidget {
  const StickyInfiniteListPage({Key? key}) : super(key: key);

  @override
  State<StickyInfiniteListPage> createState() => _StickyInfiniteListPageState();
}

class _StickyInfiniteListPageState extends State<StickyInfiniteListPage> {
  final _scrollController = ScrollController();

  List<MyItem> newerList = [];
  List<MyItem> olderList = [];

  bool moreItemLoading = false;
  bool moreItemBeforeLoading = false;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    olderList = List.generate(30, (i) => MyItem.defaultItem(i));
    newerList = List.generate(
        30,
        (i) => MyItem.defaultItem(
            newerList.isEmpty ? -i - 1 : newerList.last.id - i - 1));
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _scrollController.jumpTo(-90);
    // });
    super.initState();
  }

  void scrollListener() {
    var thresholdPixels = 1200;
    var nextPageTrigger =
        _scrollController.position.maxScrollExtent - thresholdPixels;
    var previousPageTrigger =
        _scrollController.position.minScrollExtent + thresholdPixels;

    if (_scrollController.position.pixels > nextPageTrigger) {
      addMoreItems();
    }

    if (_scrollController.position.pixels < previousPageTrigger) {
      addMoreItemsBefore();
    }
  }

  Future<void> addMoreItems() async {
    if (moreItemLoading) return;
    setState(() => moreItemLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      moreItemLoading = false;
      olderList.addAll(
        List.generate(30, (i) => MyItem.moreItem(olderList.last.id + i + 1)),
      );
    });
  }

  Future<void> addMoreItemsBefore() async {
    if (moreItemBeforeLoading) return;
    setState(() => moreItemBeforeLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      moreItemBeforeLoading = false;
      newerList.addAll(
        List.generate(
            30,
            (i) => MyItem.moreItemBefore(
                newerList.isEmpty ? -i - 1 : newerList.last.id - i - 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticky Infinite List'),
      ),
      body: InfiniteList(
        controller: _scrollController,
        direction: InfiniteListDirection.multi,
        builder: (context, index) {
          final item =
              index < 0 ? newerList[index.abs() - 1] : olderList[index];
          return InfiniteListItem(
            contentBuilder: (context) => ListTile(
              title: Text('${item.id} ${item.name}'),
            ),
          );
        },
        negChildCount: newerList.length,
        posChildCount: olderList.length,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
