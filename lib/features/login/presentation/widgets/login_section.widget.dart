import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_view/features/login/presentation/bloc/account/account_info.bloc.dart';
import 'package:flutter_camera_view/features/login/presentation/bloc/auth/auth_bloc.dart';
import 'package:toastification/toastification.dart';

class LoginSectionWidget extends StatefulWidget {
  const LoginSectionWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginSectionWidgetState createState() => _LoginSectionWidgetState();
}

class _LoginSectionWidgetState extends State<LoginSectionWidget> {
  bool isRemember = false;
  // controllers
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountInfoBloc, AccountInfoState>(
          listener: (BuildContext accountInfoContext, state) {
            if (state is AccountInfoNormalState) {
              if (state.accountInfo != null) {
                setState(() {
                  isRemember = true;
                  accountController.text = state.accountInfo!.accountID;
                  passwordController.text = state.accountInfo!.password;
                });
              }
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (authContext, state) {
            if (state is Authenticated) {
              toastification.show(
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: const Text("Authenticated"),
                applyBlurEffect: true,
                alignment: Alignment.bottomCenter,
                autoCloseDuration: const Duration(seconds: 2),
                showProgressBar: false,
                closeButtonShowType: CloseButtonShowType.none,
              );

              if (isRemember) {
                BlocProvider.of<AccountInfoBloc>(context).add(
                  SaveAccountInfoEvent(
                    accountID: accountController.text,
                    password: passwordController.text,
                  ),
                );
              } else {
                BlocProvider.of<AccountInfoBloc>(context).add(ClearAccountInfoEvent());
              }
            }
          },
        )
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 35,
            ),
            child: Form(
              key: _formKey,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ne laissez pas le champ du compte vide";
                      }
                      return null;
                      // TODO: Maybe add more logic to validate
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ne laisse pas le champ du mot de passe vide";
                      }
                      return null;
                      // TODO: Maybe add more logic to validate
                    },
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
                            setState(() {
                              isRemember = !isRemember;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Sign In Text and Sign In Button
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 35,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                LoginEvent(accountController.text, passwordController.text),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
