import 'package:flutter/material.dart' show Color, Colors;

const APP_NAME = 'mill';

class AppTheme {
  static const green = Color(0xFF006401);
  static const red = Color(0xFFC61112);
  static final greyBackground = Colors.grey[100]!;
  static const textColor = Colors.black87;
  static const shadeColor = Color(0xFF006401); // Green
  static const backgroundColor = Color(0xFFf3f3f5); // Background color for Container
  static const avatarText = Colors.white; // Avatar Text inside Circle
  static const buttonBorder = Color(0xFFECEAEA); // Border around button
  static const buttonBackground = Colors.white; // Background color of button
  static const tabbarColor = Color(0xFFDFDFDF);
  static const greenButton = Color(0xFF8FBC8B); // Green Button Background
  static const bottomAppBarColor = Color(0xFF2F4050);
  static const bottomAppBarIconColor = Color(0xFFADADAD);
  static const bottomAppBarIconShadowColor = Color(0xFF293846);
  static const bottomAppBarIconActiveColor = Colors.white;
}

const kContractTypes = {
  'GATEWOOD': {'id': '0', 'position': 0, 'name': 'Gatewood'}, // CHANGE BACK TO '1' AFTER NEW IMPORT
  'MODIFIED_GATEWOOD': {'id': '1', 'position': 1, 'name': 'Modified Gatewood'},
  'MODIFIED_GATEWOOD_HAULING': {'id': '2', 'position': 2, 'name': 'Modified Gatewood & Hauling'},
  'HARVEST': {'id': '3', 'position': 3, 'name': 'Harvest'},
  'SALES_CONTRACT': {'id': '4', 'position': 4, 'name': 'Sales Contract'},
  'TRANSFER': {'id': '5', 'position': 5, 'name': 'Transfer'},
};
