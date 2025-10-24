import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AboutUsView extends GetView {
  const AboutUsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AboutUsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AboutUsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
