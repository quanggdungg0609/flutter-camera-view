import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/login/presentation/bloc/account/account_info.bloc.dart';
import 'package:flutter_camera_view/features/login/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_camera_view/features/login/presentation/widgets/login_section.widget.dart';
import 'package:flutter_camera_view/injection_container.dart';

class LoginPages extends StatelessWidget {
  const LoginPages({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountInfoBloc>(
          create: (context) => sl<AccountInfoBloc>()..add(FetchAccountInfoEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 35, top: 120),
                child: const Text(
                  "Welcome\nBack",
                  style: TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45),
                  child: const LoginSectionWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
