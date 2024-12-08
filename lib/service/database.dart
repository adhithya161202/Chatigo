import 'package:chatapp/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods{
  Future addUserDetails(Map<String,dynamic>userInfoMap,String id)async{
    return await FirebaseFirestore.instance
    .collection("users")
    .doc(id)
    .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemail(String email)async{
    return await FirebaseFirestore.instance
    .collection("users")
    .where("E-mail", isEqualTo: email)
    .get();
  }

  Future<QuerySnapshot>Search(String username)async{
    return await FirebaseFirestore.instance
    .collection("users").where("SearchKey",isEqualTo: username.substring(0,1).toUpperCase())
    .get();
  }

Future createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (!snapshot.exists) {
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
          print("Chat room created with ID: $chatRoomId");
    }else{
      print("Chat room with ID: $chatRoomId already exists");
      return true;
      
    }
  } catch (e) {
    print("Error in createChatRoom: $e");
  }
}


Future addMessage(String chatRoomId,String messageId,Map<String,dynamic>messageInfoMap)async{
  return FirebaseFirestore.instance
  .collection("chatrooms").doc(chatRoomId)
  .collection("chats").doc(messageId)
  .set(messageInfoMap);

}


 updateLastMessageSend(String chatRoomId,Map<String,dynamic>lastMessageInfoMap)async{
  return FirebaseFirestore.instance
  .collection("chatrooms")
  .doc(chatRoomId)
  .update(lastMessageInfoMap);
 }




  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId)async{
    return FirebaseFirestore.instance
    .collection("chatrooms")
    .doc(chatRoomId)
    .collection("chats")
    .orderBy("time",descending: true)
    .snapshots();
  }


  Future<QuerySnapshot> getUserInfo(String username)async{
    return await FirebaseFirestore.instance
    .collection("users")
    .where("username",isEqualTo:username)
    .get();
  }


  Future<Stream<QuerySnapshot>>getChatRooms()async{
    String? myUserName=await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
    .collection("chatroms")
    .orderBy("time",descending: true)
    .where("users",arrayContains: myUserName!.toUpperCase())
    .snapshots();
  }



}