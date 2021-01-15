import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

//Locale资源类
class MyLocalizations {
  static Future<MyLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return MyLocalizations();
    });
  }

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String get title {
    return Intl.message(
      'odottemita_satsuei_flutter',
      name: 'title',
      desc: 'Title for this application',
    );
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) =>
      ['en', 'zh', 'ja'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<MyLocalizations> load(Locale locale) {
    print('$locale');
    return MyLocalizations.load(locale);
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
