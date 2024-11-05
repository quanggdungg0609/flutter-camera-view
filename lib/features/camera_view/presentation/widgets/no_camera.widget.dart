import 'package:flutter/material.dart';

class NoCameraWidget extends StatelessWidget {
  const NoCameraWidget({super.key});

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
                AssetImage("assets/icons/no-video.png"),
                color: Colors.grey,
                size: 40,
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Text(
                "Il n'y a aucun camera connected",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.white24,
                      offset: Offset(1, 1),
                      blurRadius: 10,
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
