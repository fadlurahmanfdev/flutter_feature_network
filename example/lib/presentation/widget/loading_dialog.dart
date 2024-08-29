import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
