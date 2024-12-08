import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/signin.dart';
import 'package:chatapp/service/database.dart';
import 'package:chatapp/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "", confirmPassword = "";
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> registration() async {
    if (password.isNotEmpty && password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String id = randomAlphaNumeric(10);
        String user=mailcontroller.text.replaceAll("@gmail.com","");
        
        String updateusername = user.replaceFirst(user[0], user[0].toUpperCase());
       // String updateusername = user[0].toUpperCase() + user.substring(1);
        String firstletter = user.substring(0,1).toUpperCase();
        
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "E-mail": mailcontroller.text,
          "username": updateusername.toUpperCase(),
          "SearchKey":firstletter,
          "photo":
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
          "Id": id,
        };

        await DatabaseMethods().addUserDetails(userInfoMap, id);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserDisplayName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserName(updateusername.toUpperCase());
       // await SharedPreferenceHelper().saveSearchKey(firstletter);
        await SharedPreferenceHelper().saveUserPic(
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registered Successfully!",
              style: TextStyle(fontSize: 20.0),
            )));
        //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> Home()));
        Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                "Password provided is too weak",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                "Account already exists",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Passwords do not match",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 174, 176, 39),
                    const Color.fromARGB(255, 18, 153, 137),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 160),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Create a new Account",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: const Color.fromARGB(255, 252, 255, 188),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        height: MediaQuery.of(context).size.height / 1.7,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInputField(
                                "Name",
                                namecontroller,
                                Icons.person,
                                "Please enter your name",
                              ),
                              SizedBox(height: 10.0),
                              buildInputField(
                                "Email",
                                mailcontroller,
                                Icons.mail,
                                "Please enter your email",
                              ),
                              SizedBox(height: 10.0),
                              buildInputField(
                                "Password",
                                passwordcontroller,
                                Icons.lock,
                                "Please enter your password",
                                obscureText: true,
                              ),
                              SizedBox(height: 10.0),
                              buildInputField(
                                "Confirm Password",
                                confirmPasswordcontroller,
                                Icons.lock,
                                "Please confirm your password",
                                obscureText: true,
                              ),
                              SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      email = mailcontroller.text;
                                      name = namecontroller.text;
                                      password = passwordcontroller.text;
                                      confirmPassword =
                                          confirmPasswordcontroller.text;
                                    });
                                    registration();
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 205, 243, 161),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SignUp",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 67, 61, 61),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Signin()));
                                    },
                                    child: Text(
                                      "SignIn",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 63, 159, 227),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      IconData icon, String validationMessage,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black38),
          ),
          child: TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validationMessage;
              }
              return null;
            },
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(icon, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
