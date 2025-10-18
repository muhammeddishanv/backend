import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_edit_subject_controller.dart';

class AdminEditSubjectView extends GetView<AdminEditSubjectController> {
  const AdminEditSubjectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminEditSubjectView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminEditSubjectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
