import 'dart:ui';
import 'package:flutter/material.dart';
import '../screens/baby_registration_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlurOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IgnorePointer(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Center(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.registerBabyInfoTitle,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    AppLocalizations.of(context)!.registerBabyInfoContents,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BabyRegistrationForm()),
                      );
                    },
                    child: Text(
                        AppLocalizations.of(context)!.registerBabyInfoButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
