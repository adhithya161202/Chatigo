import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/forgotpassword.dart';
import 'package:chatapp/pages/home.dart';
import 'package:chatapp/pages/signup.dart';
import 'package:chatapp/service/database.dart';
import 'package:chatapp/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  String email="" ,password="" ,name="",pic="",username="",id="";
  TextEditingController usermailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  final _formkey=GlobalKey<FormState>();
 
   @override
    void initState() {
    super.initState();
    FirebaseAuth.instance.setLanguageCode('en'); 
    }

//    Future<void>userLogin() async{
    
//    try{
//       await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     
//     QuerySnapshot querySnapshot =await DatabaseMethods().getUserbyemail(email);
  
//     name="${querySnapshot.docs[0]["Name"]}";
//     username="${querySnapshot.docs[0]["username"]}";
//     pic="${querySnapshot.docs[0]["photo"]}";
//     id="${querySnapshot.docs[0]["Id"]}";

//     await SharedPreferenceHelper().saveUserDisplayName(name);
//     await SharedPreferenceHelper().saveUserName(username);
//     await SharedPreferenceHelper().saveUserId(id);
//     await SharedPreferenceHelper().saveUserPic(pic);
   
// ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               "Login Successfully!",
//               style: TextStyle(fontSize: 20.0),
//             )));
//         //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> Home()));
//         Future.delayed(Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => Home()));
//       });
//     }
//     on FirebaseAuthException catch(e){
//       if(e.code=='user-not-found'){
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("No user found for that email",
//           style: TextStyle(fontSize: 18.0,color: Colors.black
//           ))));
//       }
//       else if(e.code=='wrong-password'){
//          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red,
//           content: Text("Wrong password",
//           style: TextStyle(fontSize: 18.0,color: Colors.black),),),);
      
//       }

//    }
//   }
  

userLogin() async {


  try {
    // Sign in with email and password
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password:password,
      
    );
   

    if (userCredential.user != null) {
      print("User signed in successfully");

      // Get user data from Firestore
      QuerySnapshot querySnapshot = await DatabaseMethods().getUserbyemail(email);
      if (querySnapshot.docs.isNotEmpty) {
        // Extract user data from Firestore document
        name = querySnapshot.docs[0]["Name"];
        username = querySnapshot.docs[0]["username"];
        pic = querySnapshot.docs[0]["photo"];
        id = querySnapshot.docs[0]["Id"];

        // Save data to shared preferences
        await SharedPreferenceHelper().saveUserDisplayName(name);
        await SharedPreferenceHelper().saveUserName(username);
       // await SharedPreferenceHelper().saveUserEmail(email);
        await SharedPreferenceHelper().saveUserId(id);
        await SharedPreferenceHelper().saveUserPic(pic);

        // Navigate to Home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        // Handle
        // case where user data is not found in Firestor
       
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "User data not found.",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ));
      }
    } else {
      // Handle case where FirebaseAuth fails to sign in
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Failed to sign in. Please try again.",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ));
    }
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase errors
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "No user found for that email.",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ));
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Incorrect password.",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ));
    }
  }
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        child: 
        Stack(//overlap 2 widgets
        children: [
          Container(
            height: MediaQuery.of(context).size.height/4.0,
            width: MediaQuery.of(context).size.width, //mediaQuery= highlyresponsive

            decoration: BoxDecoration(
              gradient : LinearGradient(colors: [const Color.fromARGB(255, 174, 176, 39),const Color.fromARGB(255, 18, 153, 137)],begin: Alignment.topLeft ,end: Alignment.bottomRight ),
              borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 160))
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:70.0),
            child: Column(children: [
              Center(child: Text("SignIn",style: TextStyle(fontSize: 25.0,color:Colors.white,fontWeight:FontWeight.bold ),
              )),
            Center(
              child: Text(
                "Login to your account",
                style: TextStyle(fontSize: 18.0,color:const Color.fromARGB(255, 252, 255, 188),fontWeight:FontWeight.w500 
              ),
            )
           ),
          SizedBox(height: 20.0,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
               child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal:20.0),
                height: MediaQuery.of(context).size.height/2.0 ,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10),
                ),
               child:Form(
                key: _formkey,
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email",style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500 )  ,),
                    SizedBox(height: 10.0,),
                    Container(
                      // padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(border: Border.all(width:1.0,color: Colors.black38 )),
                      child: TextFormField(
                        controller: usermailcontroller,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return "please enter email";
                          }
                          return null;
                        } ,
                        decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.mail_outline,color: const Color.fromARGB(255, 73, 189, 148),),) ,
                      ),
                    ),
                    Text(
                      "Password",
                      style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500 )  ,),
                    SizedBox(height: 10.0,),
                    Container(
                      // padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(border: Border.all(width:1.0,color: Colors.black38 )),
                       child: TextFormField(
                        controller: userpasswordcontroller,
                        validator: (value){
                          if(value==null ||value.isEmpty){
                            return "please enter password";
                          }
                          return null;
                        } ,
                        decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(Icons.lock_clock_outlined,color: Colors.blue,),
                        ) ,
                        obscureText: true,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                         onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgotpassword()));
                      },
                      
                        child: Text("Forgot password?",style: TextStyle(color: const Color.fromARGB(255, 73, 128, 224),fontSize: 14.0,fontWeight: FontWeight.w500 ),
                        ),
                      )
                      ),
                      SizedBox(height: 40.0),
                    GestureDetector(
                      onTap: (){
                          
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            email=usermailcontroller.text;
                            password=userpasswordcontroller.text;
                          });
                        }
                        userLogin();
                      },
                        child: Center(
                          child: Container(
                            width: 100,
                            child: Material(
                              elevation:5.0 ,
                              borderRadius: BorderRadius.circular(10),

                                child: Container(
                                                   padding: EdgeInsets.all(10.0),
                                                   decoration: BoxDecoration(color: const Color.fromARGB(255, 205, 243, 161),
                                                   borderRadius: BorderRadius.circular(10),),
                                child: Center(
                                  child: Text("SignIn",
                                  style: TextStyle(color: const Color.fromARGB(255, 67, 61, 61),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500 ),
                                    ),
                                    )
                                  ),
                                
                              ),
                            ),
                            ),
                      ),
                        ],
                        ),
               ),
                    ),
                  ),
                ),
               // SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account? ",style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold)
                    ),
                    
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                      },
                      
                      
                      child: Text("SignUp",style: TextStyle(color: const Color.fromARGB(255, 63, 159, 227),fontSize: 14.0,fontWeight: FontWeight.bold))
                      )
                  ],
                ),
              ],
            ),  
           )
          ],
        ),
      ),
    );
  }
}

