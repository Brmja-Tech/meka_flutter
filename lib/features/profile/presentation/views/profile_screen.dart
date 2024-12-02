import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/helper/functions.dart';
import 'package:meka/core/localization/locale_keys.g.dart';
import 'package:meka/core/localization/locales.dart';
import 'package:meka/core/network/http/api_consumer.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/user/user_state.dart';
import 'package:meka/features/auth/presentation/views/login_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.goWithNoReturn(BlocProvider(
                create: (context) => sl<AuthBloc>(),
                child: const LoginScreen()));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              final user = context.read<UserBloc>().state.user;

              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile picture
                  SvgPicture.asset(
                    'assets/svg/app_logo.svg',
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 20),
                  // Name and Email
                  Text(
                    user!.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  // Settings List
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blue),
                    title: Text(LocaleKeys.changeLanguage.tr()),
                    onTap: () {
                      if (context.locale == Locales.english) {
                        changeLang(locale: Locales.arabic, context: context);
                      } else {
                        changeLang(locale: Locales.english, context: context);
                      }
                      log('language is ${context.locale.languageCode}');
                      sl<ApiConsumer>().updateHeader(
                          {'Accept-Language': context.locale.languageCode});
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(LocaleKeys.logout.tr()),
                    onTap: () {
                      // CacheManager.clear();
                      context.read<AuthBloc>().logout();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
