extension StringExtension on String {
  String capitalizeString() {
    if (this == "" || isEmpty) {
      return this;
    } else {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
  }
}