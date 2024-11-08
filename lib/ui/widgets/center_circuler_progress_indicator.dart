import 'package:flutter/material.dart';

class CenterCirculerProgressIndicator extends StatelessWidget {
  const CenterCirculerProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
