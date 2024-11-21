import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

navTo(BuildContext context, Widget widget, String? routeName) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(
          name: routeName,
        )));

navToAndRemoveUntil(BuildContext context, Widget widget, {String? routeName}) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => widget,
          settings: RouteSettings(name: routeName)),
          (route) => false,
    );
final RegExp numberRegex = RegExp(r'^\d+(\.\d+)?$');

void logger(message) => Logger().d(message);

void loggerError(message) => Logger().e(message);

void loggerWarn(message) => Logger().w(message);