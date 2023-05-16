

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PermissionScreen extends StatefulWidget {

  const PermissionScreen({super.key});

  @override
  State createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {

  final GlobalKey<FormState> _key = GlobalKey();


  @override
  void initState() {
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                scrollController.animateTo(100,
                    duration: const Duration(seconds: 1), curve: Curves.easeIn);
              },
              child: const Text("go top")),
          Expanded(
            flex: 1,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 100,
              itemBuilder: (context, index) {
                return const Text('This is it.');
              },
            ),
          ),
        ],
      ),
    );
  }

}