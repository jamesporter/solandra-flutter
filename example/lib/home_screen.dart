import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Solandra Examples"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((ctx, idx) {
              return MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/${idx + 1}',
                    );
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Example ${idx + 1}")));
            }, childCount: 4))
          ],
        ));
  }
}
