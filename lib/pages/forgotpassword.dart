import 'package:chatapp/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {

  String  email="";
  final _formalkey = GlobalKey<FormState>();


  TextEditingController usermailcontroller =TextEditingController();

  resetPassword()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Reset Email has been sent",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize:18.0))));
    }on FirebaseAuthException catch(e){
        if(e.code=="user-not-found"){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user found for that email",style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255),fontSize: 18.0),)));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
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
            Center(child: Text("Password Recovery",style: TextStyle(fontSize: 25.0,color:Colors.white,fontWeight:FontWeight.bold ),
            )),
          Center(
            child: Text(
              "Enter yout email",
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
              height: MediaQuery.of(context).size.height/3 ,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10),
              ),
             child:Form(
                key: _formalkey,
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
                  SizedBox(height: 40.0,),
                  GestureDetector(
                    onTap: (){
                      if(_formalkey.currentState!.validate()){
                        setState(() {
                          email=usermailcontroller.text;
                        });
                        resetPassword();
                      }                  
                    },
                      child: Center(
                        child: Container(
                          width: 120,
                          child: Material(
                            elevation:5.0 ,
                            borderRadius: BorderRadius.circular(10),
      
                              child: Container(
                                                 padding: EdgeInsets.all(10.0),
                                                 decoration: BoxDecoration(color: const Color.fromARGB(255, 61, 201, 30),
                                                 borderRadius: BorderRadius.circular(10),),
                              child: Center(
                                child: Text("Send email",
                                style: TextStyle(color: const Color.fromARGB(255, 255, 255, 254),
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
                  Text("Dont have an account? ",style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold)),
                  
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                    },
                    
                    
                    child: Text("SignUp",style: TextStyle(color: const Color.fromARGB(255, 63, 159, 227),fontSize: 14.0,fontWeight: FontWeight.bold))
                    )
                ]
              ),
            ],
          ),  
         )
        ],
      ),
    );
  }
}