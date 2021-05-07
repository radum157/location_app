import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/tracker/home.dart';
import 'package:flutter_app/pages/auth_login/login.dart';
import 'package:flutter_app/services/authentication.dart';
import 'package:flutter_app/services/location.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Initialize the app with Firebase and Flutter
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set up providers for the authentication and location services
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (context) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        StreamProvider(
          create: (context) => LocationService().locationStream,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        initialRoute: '/authWrapper',
        routes: {
          '/authWrapper': (context) => AuthWrapper(),
        },
      ),
    );
  }
}

// Checks if the user is authenticated
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return LoginPage();
  }
}
