import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    this.isTransparent = false,
    Key? key,
  }) : super(key: key);

  final bool isTransparent;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isTransparent ? Colors.transparent : const Color.fromRGBO(0, 0, 0, 0.5),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
