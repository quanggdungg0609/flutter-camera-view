import 'package:flutter/material.dart';
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
  TextEditingController account = TextEditingController();
  TextEditingController password = TextEditingController();

  void getData() async {
    final storage = sl<FlutterSecureStorage>();

    final accountValue = await storage.read(key: "account");
    final passwordValue = await storage.read(key: "password");

    if (accountValue != null || passwordValue != null) {
      account.text = accountValue ?? "";
      password.text = passwordValue ?? "";
      isRemember = true;
      setState(() {});
    }
    // if (await sl<FlutterSecureStorage>().read(key: "account") != null) {
    //   account.text = (await sl<FlutterSecureStorage>().read(key: "account"))!;
    //   isRemember = true;
    //   setState(() {});
    // }

    // if (await sl<FlutterSecureStorage>().read(key: "password") != null) {
    //   password.text = (await sl<FlutterSecureStorage>().read(key: "password"))!;
    //   isRemember = true;
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
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
            Container(),
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
                            controller: account,
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
                            controller: password,
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
          ],
        ),
      ),
    );
  }
}
