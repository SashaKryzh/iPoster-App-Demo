// ignore: camel_case_types
class iPoster {
  static const privacyPolicyLink = 'https://github.com/SashaKryzh';
}

class Currency {
  static const int UAH = 1;
  static const int USD = 2;
  static const int EUR = 3;

  static const String uanSymbol = 'грн';
  static const String usdSymbol = '\$';
  static const String eurSymbol = '€';

  static const Map<int, String> currencySymbols = {
    Currency.UAH: uanSymbol,
    Currency.USD: usdSymbol,
    Currency.EUR: eurSymbol,
  };
}

enum ContactOption {
  callAndMessage,
  onlyCall,
  onlyMessage,
}
