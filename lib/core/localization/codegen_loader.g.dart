// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "login": "تسجيل الدخول",
  "email": "البريد الإلكتروني",
  "password": "كلمة المرور",
  "remember": "تذكرني",
  "forgot": "نسيت كلمة المرور؟",
  "register": "إنشاء حساب"
};
static const Map<String,dynamic> en = {
  "login": "Login",
  "email": "Email",
  "password": "Password",
  "remember": "Remember Me",
  "forgot": "Forgot Password?",
  "register": "Create Account"
};

static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
