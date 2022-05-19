import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/home.dart';
import 'package:flutterfire_ui/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // ...
          return const SignInScreen(providerConfigs: [
            EmailProviderConfiguration(),
          ]);
        }
        // Render your application if authenticated
        return const Home();
      },
    );
  }
}
