import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/localization/translation_service.dart';
import 'package:meka/core/theme/light_theme.dart';
import 'package:meka/features/auth/presentation/views/login_screen.dart';
import 'service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(LocalizationService.rootWidget(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Meka',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: LightTheme.theme,
            home: const LoginScreen(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        });
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
