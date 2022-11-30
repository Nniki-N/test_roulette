import 'package:flutter/material.dart';
import 'package:test_roulette/ui/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  const myApp = MyApp();

  runApp(myApp);
}

