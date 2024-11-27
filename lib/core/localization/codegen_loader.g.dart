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
  "register": "إنشاء حساب",
  "dontHaveAccount": "ليس لديك حساب؟",
  "clickHere": "انقر هنا",
  "alreadyHaveAccount": "لديك حساب بالفعل؟",
  "signUp": "تسجيل",
  "continueWith": "أو الاستمرار مع",
  "registerNow": "سجل الآن",
  "name": "الاسم",
  "phone": "الهاتف",
  "signInNow": "قم بتسجيل الدخول",
  "createYourAccount": "إنشاء حسابك",
  "enterYourEmailPlease": "ادخل البريد الالكتروني",
  "resendOTP": "اعاده الارسال",
  "resetPassword": "تغيير كلمه السر",
  "sendOTP": "ارسال الرمز",
  "enterCode": "ادخل الرمز",
  "confirmPassword": "تأكيد كلمة المرور",
  "rider": "سائق",
  "driver": "عميل",
  "maps": "خرائط",
  "newPassword": "كلمه المرور الجديدة",
  "changeLanguage": "تغيير اللغه",
  "logout": "تسجيل خروج"
};
static const Map<String,dynamic> en = {
  "login": "Login",
  "email": "Email",
  "password": "Password",
  "remember": "Remember Me",
  "forgot": "Forgot Password?",
  "register": "Create Account",
  "dontHaveAccount": "Don\\'t have an account?",
  "alreadyHaveAccount": "Already have an account?",
  "signUp": "Sign Up",
  "clickHere": "Click here",
  "continueWith": "Continue with",
  "registerNow": "Register Now",
  "name": "Name",
  "phone": "Phone",
  "createYourAccount": "Create your account",
  "signInNow": "Sign in now",
  "enterCode": "Enter Code",
  "enterYourEmailPlease": "Enter your Email please",
  "resendOTP": "Resend OTP",
  "sendOTP": "Send OTP",
  "resetPassword": "Reset Password",
  "newPassword": "New Password",
  "rider": "Rider",
  "driver": "Driver",
  "maps": "Maps",
  "confirmPassword": "Confirm Password",
  "logout": "Logout",
  "changeLanguage": "Change Language"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
