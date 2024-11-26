import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meka/core/extensions/context.extension.dart';
import 'package:meka/core/stateless/custom_button.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_cubit.dart';
import 'package:meka/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:meka/features/auth/presentation/views/login_screen.dart';
import 'package:meka/service_locator/service_locator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(

      listener: (context, state) {
        if(state.isSuccess){
          context.goWithNoReturn(BlocProvider(
            create: (context)=>sl<AuthBloc>(),child: const LoginScreen())
          );
        }
      },
      child: Center(
        child: CustomElevatedButton(text: 'تسجيل خروج',
            width: context.screenWidth * 0.5,
            onPressed: () {
              context.read<AuthBloc>().logout();
            }),
      ),
    );
  }
}
