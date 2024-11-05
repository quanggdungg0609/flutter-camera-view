import 'package:flutter/material.dart';

class ConnectFailedWidget extends StatelessWidget {
  const ConnectFailedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        heightFactor: 1 / 3,
        widthFactor: 4 / 5, // Adjust if you want a narrower container
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(5, 5),
                blurRadius: 5,
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageIcon(
                AssetImage("assets/icons/no-connection.png"),
                color: Colors.redAccent,
                size: 40,
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Échec de connexion",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.redAccent,
                      offset: Offset(0.5, 0.5),
                      blurRadius: 0.5,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
