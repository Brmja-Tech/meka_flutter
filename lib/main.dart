import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meka/core/localization/translation_service.dart';
import 'package:meka/core/network/cache_helper/cache_manager.dart';
import 'package:meka/core/theme/light_theme.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_cubit.dart';
import 'package:meka/features/auth/presentation/views/login_screen.dart';
import 'package:meka/features/loader/presentation/blocs/loader_cubit.dart';
import 'package:meka/firebase_options.dart';
import 'package:meka/meka/meka_screen.dart';
import 'service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission(
    announcement: true,
    carPlay: true,
    criticalAlert: true,
  );
  // FirebaseMessaging.instance.subscribeToTopic('all');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final String? accessToken = await CacheManager.getAccessToken();
  final Widget initialScreen = (accessToken != null)
      ? const MekaScreen()
      : BlocProvider(
          create: (context) => sl<AuthBloc>(), child: const LoginScreen());
  runApp(LocalizationService.rootWidget(child: MyApp(initialScreen)));
}

class MyApp extends StatelessWidget {
  final Widget _initialScreen;

  const MyApp(
    this._initialScreen, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<UserBloc>()..getUser()),
        BlocProvider(create: (context) => sl<LoaderBloc>()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(750, 1334),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              title: 'Meka',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: LightTheme.theme,
              home: _initialScreen,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            );
          }),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
