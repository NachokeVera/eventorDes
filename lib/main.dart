import 'package:eventor/firebase_options.dart';
import 'package:eventor/screens/admin/admin_page.dart';
import 'package:eventor/screens/admin/form_evento_page.dart';
import 'package:eventor/screens/home_page.dart';
import 'package:eventor/screens/botones_page.dart';
import 'package:eventor/screens/login_page.dart';
import 'package:eventor/service/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().usuario,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Organizador',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 240, 220, 227),
              brightness: Brightness.light,
            ),
            textTheme: TextTheme(
              titleLarge: GoogleFonts.satisfy(fontSize: 30),
              //labelLarge: GoogleFonts.satisfy(),
            )),
        routes: {
          "/loginpage": (context) => const LoginPage(),
          "/formpage": (context) => const FormEvento(),
          "/homepage": (context) => const HomePage(),
          "/adminpage": (context) => const AdminPage(),
        },
        home: const BotonesPages(),
      ),
    );
  }
}
