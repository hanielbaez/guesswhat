//Flutter and Dart import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

//Self import
import 'package:Tekel/ui/pages/loadingPage.dart';
import 'package:Tekel/costumTheme.dart';
import 'package:Tekel/providerSetup.dart';
import 'package:Tekel/core/custom/customMobileOrientation.dart';
import './router.dart' as router;

void main() {
  setPortraitOrientation();
  return runApp(EasyLocalization(child: MyApp()));
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    return MultiProvider(
      providers: providers,
      child: EasyLocalizationProvider(
        data: data,
        child: MaterialApp(
          title: 'Tekel',
          theme: costumTheme,
          home: LoadingPage(),
          onGenerateRoute: router.generateRoute,
          initialRoute: '/',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasylocaLizationDelegate(locale: data.locale, path: 'assets/langs'),
          ],
          supportedLocales: [Locale('en', 'US'), Locale('es', 'US')],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          locale: data.savedLocale,
        ),
      ),
    );
  }
}
