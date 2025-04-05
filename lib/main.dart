//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

//import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var logger = Logger();
  /*if (kDebugMode) {
  FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
}*/

// Listen to authentication state changes
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      // Use logger instead of print
      logger.i('User is currently signed out!');
    } else {
      logger.i('User is signed in!');
    }
  });

  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      
      home: ListScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthStateWidget(),
    );
  }
}

class AuthStateWidget extends StatelessWidget {
  const AuthStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Check the current user state
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${user.displayName}'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You are signed in as ${user.email}'),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: Text('Sign out'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Simulate a sign-in action (replace with actual sign-in flow)
              await FirebaseAuth.instance.signInAnonymously();
            },
            child: Text('Sign in anonymously'),
          ),
        ),
      );
    }
  }
}


//FirebaseDatabase database = FirebaseDatabase.instance;