import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/forgotpassword.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/signin.dart';
import 'package:chatapp/pages/signup.dart';
import 'package:chatapp/pages/splashscreen.dart';
import 'package:chatapp/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChattApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
    
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 80, 177, 65)),
        useMaterial3: true,
      ),
      home: Signin(),
      // home:FutureBuilder(future: AuthMethods().getCurrentUser() ,builder: (context,AsyncSnapshot<dynamic> snapshot){
      //   if(snapshot.hasData){
      //     return Home();
      //   }
      //   else{
      //     return SplashScreen();
      // }
     // })
    );
  }
}

