import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'not_found.controller.dart';

/*
  This page will show a 404 error when a route is not found.
  It provides a user-friendly message and a button to navigate back to the previous page.

  created by : Muhammed Shabeer OP
  date : 2025-08-14
  updated date : 2025-08-14
*/

class NotFoundView extends GetView<NotFoundController> {
  const NotFoundView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Not Found'), centerTitle: true),
      body: Column(
        //big container
        children: [
          Expanded(
            child: Center(
              child: Text(
                '404 - Not Found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Go Back'),
            ),
          ),
        ],
      ),
    );
  }
}
