import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cloudinary_file_upload/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 120),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                  const Text("Get Started with your Account"),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Please enter your email" : null,
                      controller: emailController,
                      decoration: const InputDecoration(
                          label: Text("Email"),
                          hintText: "Email",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      validator: (value) => value!.length < 8
                          ? "Password Should be at least 8 Charactors"
                          : null,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text("Password"),
                          hintText: "Password",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {

                          // print("Email: ${emailController.text}");
                          // print("Password: ${passwordController.text}");

                          AuthService().signInWithEmail(emailController.text, passwordController.text).then((value) {
                            if(value == 'Signed in'){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
                              Navigator.pushReplacementNamed(context, '/home');
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value, style: TextStyle(color: Colors.white),), backgroundColor: Colors.red,));

                            }
                          });
                        }
                      
                        
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text("Sign Up"),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
