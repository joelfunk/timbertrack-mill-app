import 'package:flutter/material.dart' show BuildContext, MediaQuery;

extension IsTablet on BuildContext {
  bool get isTablet {
    final mediaQuery = MediaQuery.of(this);
    return mediaQuery.size.shortestSide >= 600;
  }
}
