import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_create_subject_controller.dart';

class AdminCreateSubjectView extends GetView<AdminCreateSubjectController> {
  const AdminCreateSubjectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminCreateSubjectView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminCreateSubjectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
