import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/google_sign_in.dart';
import 'package:flutter_application_7/pages/homepage.dart';
import 'package:flutter_application_7/pages/sign_up_page.dart';
import 'package:flutter_application_7/routes/routes.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        routes: {MyRoutes.homeroute: (context) => Signup()},
      ),
    );
  }
}
