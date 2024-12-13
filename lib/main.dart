import 'package:flutter/material.dart';
import 'package:flutter_cloudinary_file_upload/services/auth_service.dart';
import 'package:flutter_cloudinary_file_upload/views/Home.dart';
import 'package:flutter_cloudinary_file_upload/views/Login.dart';
import 'package:flutter_cloudinary_file_upload/views/Signup.dart';
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
      '/': (context) => const CheckUser(),
      '/upload': (context) => const Uploadarea(),
      '/login': (context) => const Login(),
      '/signup': (context) => const Signup(),
      '/home': (context) => const Home(),
    });
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState(){
    AuthService().isUserLoggedIn().then((value) {
      if(value){
        Navigator.pushReplacementNamed(context, '/home');
      }else{
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
