import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(' ', '');

    if (newText.length > 9) {
      return oldValue;
    }

    if (newText.length > 2 && newText.length <= 5) {
      newText = newText.substring(0, 2) + ' ' + newText.substring(2);
    } else if (newText.length > 5) {
      newText = newText.substring(0, 2) +
          ' ' +
          newText.substring(2, 5) +
          ' ' +
          newText.substring(5);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
