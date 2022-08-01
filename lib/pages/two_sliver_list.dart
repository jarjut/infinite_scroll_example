import 'package:flutter/material.dart';
import 'package:infinite_scroll/item.dart';

class TwoSliverListPage extends StatefulWidget {
  const TwoSliverListPage({Key? key}) : super(key: key);

  @override
  State<TwoSliverListPage> createState() => _TwoSliverListPageState();
}

class _TwoSliverListPageState extends State<TwoSliverListPage> {
  final _scrollController = ScrollController();

  List<MyItem> olderList = [];
  List<MyItem> myList = [];

  bool moreItemLoading = false;
  bool moreItemBeforeLoading = false;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    myList = List.generate(30, (i) => MyItem.defaultItem(i));
    olderList = List.generate(
        30,
        (i) => MyItem.defaultItem(
            olderList.isEmpty ? -i - 1 : olderList.last.id - i - 1));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(-90);
    });
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
      myList.addAll(
        List.generate(30, (i) => MyItem.moreItem(myList.last.id + i + 1)),
      );
    });
  }

  Future<void> addMoreItemsBefore() async {
    if (moreItemBeforeLoading) return;
    setState(() => moreItemBeforeLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      moreItemBeforeLoading = false;
      olderList.addAll(
        List.generate(
            30,
            (i) => MyItem.moreItemBefore(
                olderList.isEmpty ? -i - 1 : olderList.last.id - i - 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('second-sliver-list');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Sliver List'),
      ),
      body: RefreshIndicator(
        onRefresh: () => addMoreItemsBefore(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          center: centerKey,
          slivers: [
            if (moreItemBeforeLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = olderList[index];
                  return ListTile(
                    title: Text('${item.id} ${item.name}'),
                  );
                },
                childCount: olderList.length,
              ),
            ),
            SliverList(
              key: centerKey,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = myList[index];
                  return ListTile(
                    title: Text('${item.id} ${item.name}'),
                  );
                },
                childCount: myList.length,
              ),
            ),
            if (moreItemLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
