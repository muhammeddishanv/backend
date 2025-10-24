import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UnlockContentView extends GetView {
  const UnlockContentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnlockLessionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UnlockLessionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
