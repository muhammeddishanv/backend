import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'payment.controller.dart';

/*
  This is the view for the payment module.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Muhammed Shabeer OP
  date : 2025-08-07
  updated date : 2025-08-07
*/

/*
  PaymentView
  - Purpose: Placeholder view for payment-related flows (wallet, transactions).
  - Notes: Responsive scaffold used; controller handles business logic.
  - Header added 2025-10-23 (annotation only).
*/

class PaymentView extends GetResponsiveView<PaymentController> {
  PaymentView({super.key}) : super(alwaysUseBuilder: false);
  @override
  Widget phone() => Icon(Icons.phone, size: 75);
  @override
  Widget tablet() => Icon(Icons.tablet, size: 75);
  @override
  Widget desktop() => Icon(Icons.desktop_mac, size: 75);
}
