import 'package:flutter/material.dart';
import 'package:infinite_scroll/pages/my_example.dart';
import 'package:infinite_scroll/pages/two_sliver_list.dart';
import 'package:infinite_scroll/pages/two_sliver_with_app_bar.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('My Example'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyExamplePage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Two Sliver List'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TwoSliverListPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Two Sliver with Sliver App Bar'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TwoSliverWithAppBarPage(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
