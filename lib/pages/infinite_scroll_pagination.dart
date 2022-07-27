import 'package:flutter/material.dart';
import 'package:infinite_scroll/item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteScrollPaginationPage extends StatefulWidget {
  const InfiniteScrollPaginationPage({Key? key}) : super(key: key);

  @override
  State<InfiniteScrollPaginationPage> createState() =>
      _InfiniteScrollPaginationPageState();
}

class _InfiniteScrollPaginationPageState
    extends State<InfiniteScrollPaginationPage> {
  List<MyItem> myList = [];
  static const _pageSize = 30;

  final PagingController<int, MyItem> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Future.delayed(const Duration(seconds: 1), () {
        return List.generate(30, (i) => MyItem(pageKey + i + 1, 'Item'));
      });
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Pagination'),
      ),
      body: Column(
        children: [
          const Text(
              'This package cannot be used to infinite load on both sides.'),
          Expanded(
            child: PagedListView<int, MyItem>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<MyItem>(
                itemBuilder: (context, item, index) => ListTile(
                  title: Text('${item.id} ${item.name}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
