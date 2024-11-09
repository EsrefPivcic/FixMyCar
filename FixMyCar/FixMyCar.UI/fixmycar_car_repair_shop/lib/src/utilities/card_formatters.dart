import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(' ', '');

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 16) {
      return oldValue;
    }

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i % 4 == 0 && i != 0) {
        formattedText += ' ';
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll('/', '');

    newText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 4) {
      return oldValue;
    }

    if (newText.length > 2) {
      newText = newText.substring(0, 2) + '/' + newText.substring(2);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CVVFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 4) {
      return oldValue;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
