import 'package:fx_flame/extensions/string_extension.dart';

String? dateValidator(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Please select date time';
  }

  return null;
}

String? volumeValidator(String? milkVolume) {
  if(!milkVolume.isValidate) {
    return 'Please enter Milk Volume';
  }

  return null;
}

