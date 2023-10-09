import 'package:flutter/material.dart';

class IBox extends StatelessWidget {
  const IBox({
    super.key,
    required this.title,
    required this.child,
    this.buttonTitle,
    this.buttonCallback,
    this.addCallback,
    this.editCallback,
    this.prefixIcon,
  });

  final String title;
  final Widget child;
  final Icon? prefixIcon;
  final String? buttonTitle;
  final Function? buttonCallback;
  final Function? addCallback;
  final Function? editCallback;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.5, color: Color.fromARGB(213, 224, 224, 224)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (prefixIcon != null) prefixIcon!,
                    SizedBox(width: size.width * .02),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (editCallback != null)
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: IconButton(
                          icon: const Icon(
                            Icons.drive_file_rename_outline,
                          ),
                          iconSize: 18,
                          onPressed: () => editCallback?.call(),
                        ),
                      ),
                    if (addCallback != null)
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 18,
                          onPressed: () => addCallback?.call(),
                        ),
                      )
                  ],
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
          child,
        ],
      ),
    );
  }
}
