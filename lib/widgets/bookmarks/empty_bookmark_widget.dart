import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final String message;
  final String imagePath;

  const EmptyDataWidget(
      {Key? key, required this.message, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ],
      ),
    );
  }
}
