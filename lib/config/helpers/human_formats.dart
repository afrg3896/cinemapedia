


import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number) {
    int numberRevised = int.parse(number.toString().replaceAll('.', ''));
    final formatteNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en'
    ).format(numberRevised);

    return formatteNumber;
  }
}