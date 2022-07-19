import 'package:flutter/material.dart';
import 'package:infinite_scroll/item.dart';

class OneSliverListPage extends StatefulWidget {
  const OneSliverListPage({Key? key}) : super(key: key);

  @override
  State<OneSliverListPage> createState() => _OneSliverListPageState();
}

class _OneSliverListPageState extends State<OneSliverListPage> {
  final _scrollController = ScrollController();

  List<MyItem> myList = [];
  bool moreItemLoading = false;
  bool moreItemBeforeLoading = false;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    myList = List.generate(30, (i) => MyItem.defaultItem(i));
    super.initState();
  }

  void scrollListener() {
    var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels > nextPageTrigger) {
      addMoreItems();
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
    var extentAfter = _scrollController.position.extentAfter;
    setState(() {
      moreItemBeforeLoading = false;
      myList.insertAll(
        0,
        List.generate(
            30, (i) => MyItem.moreItemBefore(myList.first.id - 30 + i)),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent - extentAfter);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Example'),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add_more_items_before',
            onPressed: () => addMoreItemsBefore(),
            child: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}
