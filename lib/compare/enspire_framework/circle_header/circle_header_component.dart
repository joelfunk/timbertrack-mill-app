import 'package:flutter/material.dart';

import 'package:mobiletrack_dispatch_flutter/constants/constants.dart' as theme_colors;

class CircleHeaderComponent extends StatelessWidget {
  const CircleHeaderComponent({
    Key? key,
    required this.circleInitials1,
    required this.circleInitials2,
    required this.headerTextLine1,
    this.editCallback,
    this.headerTextLine2,
    this.line1FontSize = 16,
    this.line1FontWeight = FontWeight.normal,
    this.line2FontSize = 14,
    this.line2FontWeight = FontWeight.bold,
  }) : super(key: key);

  final String circleInitials1;
  final String circleInitials2;
  final String headerTextLine1;
  final String? headerTextLine2;
  final double line1FontSize;
  final FontWeight line1FontWeight;
  final double line2FontSize;
  final FontWeight line2FontWeight;

  final Function()? editCallback;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.0,
                width: 80.0,
                child: CircleAvatar(
                  backgroundColor: theme_colors.AppTheme.shadeColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (circleInitials1.isNotEmpty)
                        Text(
                          circleInitials1,
                          style: const TextStyle(
                            fontSize: 14,
                            color: theme_colors.AppTheme.avatarText,
                          ),
                        ),
                      Text(
                        circleInitials2.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: theme_colors.AppTheme.avatarText,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headerTextLine1,
                      style: TextStyle(
                        fontSize: line1FontSize,
                        color: theme_colors.AppTheme.textColor,
                        fontWeight: line1FontWeight,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),

                    // Show company name if exists
                    if (headerTextLine2?.isNotEmpty ?? false)
                      Column(
                        children: [
                          const SizedBox(height: 2.5),
                          Text(
                            headerTextLine2!,
                            style: TextStyle(
                              fontSize: line2FontSize,
                              color: theme_colors.AppTheme.textColor,
                              fontWeight: line2FontWeight,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.mode_edit),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashColor: Colors.transparent,
                  splashRadius: 20,
                  onPressed: () {
                    editCallback?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
