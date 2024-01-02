import 'package:flutter/material.dart';

class NoConnectionPage extends StatelessWidget {
  final VoidCallback onReload;

  const NoConnectionPage({Key? key, required this.onReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.signal_wifi_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ups, no connection',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onReload,
              child: const Text('Reload'),
            ),
          ],
        ),
      ),
    );
  }
}
