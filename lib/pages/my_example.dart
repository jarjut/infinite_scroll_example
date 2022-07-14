import 'package:flutter/material.dart';
import 'package:infinite_scroll/item.dart';

class MyExamplePage extends StatefulWidget {
  const MyExamplePage({Key? key}) : super(key: key);

  @override
  State<MyExamplePage> createState() => _MyExamplePageState();
}

class _MyExamplePageState extends State<MyExamplePage> {
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
    print(_scrollController.position.maxScrollExtent);

    // print('maxExtent: ${_scrollController.position.maxScrollExtent} '
    //     'minExtent: ${_scrollController.position.minScrollExtent} '
    //     'exBefore: ${_scrollController.position.extentBefore} '
    //     'exAfter: ${_scrollController.position.extentAfter} ');
  }

  Future<void> addMoreItems() async {
    if (moreItemLoading) return;
    setState(() => moreItemLoading = true);
    await Future.delayed(const Duration(seconds: 2));
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
    await Future.delayed(const Duration(seconds: 2));
    print(_scrollController.position.maxScrollExtent);
    var extentAfter = _scrollController.position.extentAfter;
    setState(() {
      moreItemBeforeLoading = false;
      myList.insertAll(
        0,
        List.generate(
            30, (i) => MyItem.moreItemBefore(myList.first.id - 30 + i)),
      );
      print(_scrollController.position.maxScrollExtent);
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent - extentAfter);
    });
    print(_scrollController.position.maxScrollExtent);
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
          FloatingActionButton(
            heroTag: 'add_single_item',
            onPressed: () => setState(() {
              myList.add(MyItem(myList.last.id + 1, 'More Single item'));
            }),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
