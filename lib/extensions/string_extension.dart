extension StringExtension on String {
  String get upper => toUpperCase();

  String get lower => toLowerCase();
}

extension StringValidatorExtension on String? {
  bool get isValidate => this != null && this!.isNotEmpty;
}