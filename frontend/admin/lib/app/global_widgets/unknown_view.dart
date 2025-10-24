import 'package:flutter/material.dart';

// Simple fallback view shown when an unknown/404 route is visited.
class UnknownView extends StatelessWidget {
  const UnknownView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page not found')));
  }
}
