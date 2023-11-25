import 'package:flutter/material.dart';

class BotonesPages extends StatelessWidget {
  const BotonesPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, "/adminpage"),
            child: const Text('Admin'),
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, "/homepage"),
            child: const Text('guess'),
          ),
        ],
      ),
    );
  }
}
