import 'package:flutter/material.dart' show BuildContext, MediaQuery, Orientation;

extension IsPortrait on BuildContext {
  bool get isPortrait {
    final mediaQuery = MediaQuery.of(this);
    return mediaQuery.orientation == Orientation.portrait;
  }
}
