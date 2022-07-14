import 'dart:async';

import 'package:flutter/material.dart';

class TwoSliverWithAppBarPage extends StatefulWidget {
  const TwoSliverWithAppBarPage({Key? key}) : super(key: key);

  @override
  State<TwoSliverWithAppBarPage> createState() =>
      _TwoSliverWithAppBarPageState();
}

class _TwoSliverWithAppBarPageState extends State<TwoSliverWithAppBarPage> {
  List<int> top = [];
  List<int> bottom = List<int>.generate(10, (i) => i + 1);

  Future<void> _refresh() async {
    // In a real application we would probably fetch data here.
    // Let's simulate by setting a timer:
    Timer(
      const Duration(milliseconds: 500),
      () {
        addItems();
      },
    );
    return;
  }

  void addItems() {
    setState(() {
      for (var i = 0; i < 3; i++) {
        top.add(-top.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('second-sliver-list');
    return Scaffold(
      body: Container(
        color: Colors.green[200],
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: const Text(
                    'Press on button, or scroll to the top to refresh',
                  ),
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  leading: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: addItems,
                  ),
                ),
              )
            ];
          },
          body: Builder(builder: (context) {
            return RefreshIndicator(
              displacement: 20.0,
              onRefresh: _refresh,
              child: SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  center: centerKey,
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.green[200 + top[index] % 4 * 100],
                            height: 100 + top[index] % 4 * 20.0,
                            child: Text('Item: ${top[index]}'),
                          );
                        },
                        childCount: top.length,
                      ),
                    ),
                    SliverList(
                      key: centerKey,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.green[200 + bottom[index] % 4 * 100],
                            height: 100 + bottom[index] % 4 * 20.0,
                            child: Text('Item: ${bottom[index]}'),
                          );
                        },
                        childCount: bottom.length,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
