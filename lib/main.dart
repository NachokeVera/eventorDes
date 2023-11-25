import 'package:eventor/firebase_options.dart';
import 'package:eventor/screens/form_evento_page.dart';
import 'package:eventor/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return MaterialApp(
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
        "/formpage": (context) => const FormEvento(),
        "/homepage": (context) => const HomePage(),
      },
      home: const HomePage(),
    );
  }
}
