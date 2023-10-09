import 'package:flutter/material.dart';

class ITabHeader extends StatelessWidget {
  const ITabHeader({
    super.key,
    required this.title,
    this.buttonTitle,
    this.buttonCallback,
  });

  final String title;
  final String? buttonTitle;
  final Function()? buttonCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: buttonTitle != null ? 5 : 25,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Color.fromARGB(213, 224, 224, 224),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              if (buttonTitle != null)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => buttonCallback?.call(),
                  child: Text(
                    buttonTitle!,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
