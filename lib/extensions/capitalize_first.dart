extension CapitalizeFirstLetter on String {
  String firstLetter() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
