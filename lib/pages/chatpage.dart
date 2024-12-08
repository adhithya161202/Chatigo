import 'package:chatapp/pages/home.dart';
import 'package:chatapp/service/database.dart';
import 'package:chatapp/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Chatpage extends StatefulWidget {
 String name,profileurl,username;
 Chatpage({required this.name,required this.profileurl,required this.username});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {

  TextEditingController messagecontroller=  TextEditingController();
  String? myUserName,myProfilePic,myName,myEmail,messageId,chatRoomId;
  Stream? messageStream;

getthesharedpref()async{
  myUserName=await SharedPreferenceHelper().getUserName();
  myProfilePic=await SharedPreferenceHelper().getUserPic();
  myName=await SharedPreferenceHelper().getUserDisplayName();
  myEmail=await SharedPreferenceHelper().getUserEmail();
  chatRoomId=getChatRoomIdbyUsername(widget.username,myUserName!);
  setState(() {
    
  });
}
ontheload()async{
  await getthesharedpref();
  await getAndSetMessages();
  setState(() {
    
  });
}

@override
void initState(){
  super.initState();
  ontheload();
}

 String getChatRoomIdbyUsername(String a, String b) {
  // Sort usernames alphabetically to ensure consistency.
  //if (a.compareTo(b) > 0) {
   if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a"; // Correct way to generate the chat room ID with even segments
  } else {
    return "$a\_$b"; // Ensure it's always consistent
  }
}
Widget chatMessageTile(String message,bool sendByMe){
  return Row(mainAxisAlignment: sendByMe?MainAxisAlignment.end:MainAxisAlignment.start,
  children: [
  Flexible(child: Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
    decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft:Radius.circular(24),bottomRight: sendByMe?Radius.circular(0):Radius.circular(24),topRight: Radius.circular(24),bottomLeft: sendByMe?Radius.circular(24):Radius.circular(0)),
    color:sendByMe?Color.fromARGB(255, 142, 231, 206): Color.fromARGB(255, 235, 239, 226)),
    child:  Text(
                      message,
                      style: TextStyle(
                      color: Colors.black,
                      fontSize:15.0,
                      fontWeight:FontWeight.w500),
                      
                    ),
 
  ))
  ],);
}

Widget chatMessage(){
  return StreamBuilder(stream: messageStream, 
  builder: (context,AsyncSnapshot snapshot){
    return snapshot.hasData? ListView.builder(
      padding: EdgeInsets.only(bottom: 90.0,top: 130.0),
      itemCount: snapshot.data.docs.length,
      reverse:true,
      itemBuilder:(context,index) {
        DocumentSnapshot ds=snapshot.data.docs[index];
        return chatMessageTile(ds["message"], myUserName==ds["sendBy"]);
      }): Center(
        child: CircularProgressIndicator(),
      );
  });
}


addMessage(bool sendClicked){
  if(messagecontroller.text!=""){
    String message=messagecontroller.text;
    messagecontroller.text="";

    DateTime now=DateTime.now();
    String formattedDate = DateFormat('h:mma').format(now);
    Map<String ,dynamic>messageInfoMap={
      "message":message,
      "sendBy":myUserName,
      "ts":formattedDate,
      "time":FieldValue.serverTimestamp(),
      "imgUrl":myProfilePic,
    };
    messageId ??= randomAlphaNumeric(10);

    DatabaseMethods().addMessage(chatRoomId!, messageId!, messageInfoMap)
    .then((value){
      Map<String,dynamic>lastMessageInfoMap={
        "lastMessage":message,
        "lastMessageSendTs":formattedDate,
        "lastMessageSendBy":myUserName,
      };
      DatabaseMethods().updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
      if(sendClicked){
        messageId=null;
      }
    });
  }
}

getAndSetMessages()async{
  messageStream= await DatabaseMethods().getChatRoomMessages(chatRoomId);
  setState(() {
    
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 85, 85),
      body: Container(
        padding: EdgeInsets.only(top:40),
        child: Stack(
          children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.12,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 251, 251, 242),
              borderRadius: BorderRadius.only(
              topLeft:Radius.circular(30),
              topRight: Radius.circular(30) )

            ),
            child: chatMessage()),
            Padding(
              padding: const EdgeInsets.only( left: 20.0, right: 20.0),
              child: Row(
                children: [
                   GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                    },
                     child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Color.fromARGB(255, 255, 255, 245),
                                       ),
                   ),
                   SizedBox(width: 120.0),
                   Padding(
                     padding: const EdgeInsets.only( left: 20.0, right: 20.0),
                     child: Row(
                       children: [
                         Text(
                          widget.name,
                          style: TextStyle(
                            color: Color.fromARGB(255, 232, 237, 248),
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                       ],
                     ),
                   ),
                ],
              ),
            ),
                  
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(10),
                        
                        child: Container(
                          margin: EdgeInsets.only(left:20.0 ,right: 20.0,bottom: 10.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(blurRadius:10.0,color: Colors.black.withOpacity(0.3)),
                            ],
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: 
                              
                                  TextField(
                                    controller: messagecontroller,
                                    
                                    decoration: InputDecoration(
                                      
                                      border: InputBorder.none,
                                      hintText: "Type a message",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: 
                                      GestureDetector(
                                        onTap: (){
                                          addMessage(true);
                                        },  
                                      child: Icon(Icons.send_rounded))
                                    ),
                                  ),
                                
                                ),
                              
                            ),
                          ),
                        ),
                      ]
                    ),
                  )
                );     
  }
}
