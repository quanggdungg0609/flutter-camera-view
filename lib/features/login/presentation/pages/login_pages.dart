import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/core/constants/constants.dart';
import 'package:flutter_camera_view/features/login/presentation/bloc/account/account_info.bloc.dart';
import 'package:flutter_camera_view/features/login/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_camera_view/injection_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  bool isRemember = false;
  // controllers
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountInfoBloc>(
          create: (_) => sl<AccountInfoBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
      ],
      child: BlocConsumer<AccountInfoBloc, AccountInfoState>(
        listener: (accountListenerContext, state) {
          if (state is AccountInfoFetchedState) {
            if (state.accountInfo != null) {
              setState(() {
                isRemember = true;
                accountController.text = state.accountInfo!.accountID;
                passwordController.text = state.accountInfo!.password;
              });
            }
          }
        },
        builder: (accountBuilderContext, state) {
          if (state is AccountInfoInitialState) {
            BlocProvider.of<AccountInfoBloc>(accountBuilderContext).add(FetchAccountInfoEvent());
          }
          return Container(
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
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
                      child: BlocListener<AccountInfoBloc, AccountInfoState>(
                        listener: (context, state) {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 35,
                              ),
                              child: Column(
                                children: [
                                  // Account and password text fields
                                  TextFormField(
                                    controller: accountController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: "Account ID",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    style: const TextStyle(color: Colors.black),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: "Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),

                                  // Remember me checked
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0, top: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Souviens-moi",
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                        Checkbox(
                                          value: isRemember,
                                          onChanged: (value) {
                                            isRemember = !isRemember;
                                            setState(() {
                                              isRemember = !isRemember;
                                              setState(() {});
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Sign In Text and Sign In Button
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 35)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: const Color.fromARGB(255, 3, 35, 126),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {},
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
