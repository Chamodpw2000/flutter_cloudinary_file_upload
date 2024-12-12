import 'package:flutter/material.dart';
import 'package:flutter_cloudinary_file_upload/views/Home.dart';
import 'package:flutter_cloudinary_file_upload/views/UploadArea.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Online Drive', theme: ThemeData(), routes: {
      '/': (context) => const Home(),
      '/upload': (context) => const Uploadarea()
    });
  }
}
