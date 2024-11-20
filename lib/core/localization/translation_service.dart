import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:meka/core/localization/codegen_loader.g.dart';
import 'package:meka/core/localization/locales.dart';

abstract interface class LocalizationService {
  static Future<void> init() async {
    await EasyLocalization.ensureInitialized();
  }

  static Widget rootWidget({required Widget child}) {
    return EasyLocalization(
      saveLocale: true,
      supportedLocales: const [Locales.english, Locales.arabic],
      path: 'assets/translations',
      startLocale: Locales.arabic,
      fallbackLocale: Locales.english,
      assetLoader: const CodegenLoader(),
      child: child,
    );
  }
}