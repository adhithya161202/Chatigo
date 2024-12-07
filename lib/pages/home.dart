import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/service/database.dart';
import 'package:chatapp/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String ?myName,myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;

  getthesharedpref()async{
    myName =await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic=await SharedPreferenceHelper().getUserPic();
    myUserName=await SharedPreferenceHelper().getUserName();
    myEmail=await SharedPreferenceHelper().getUserEmail();
    setState(() {
      
    });
  }

  ontheload()async{
    await getthesharedpref();
    chatRoomsStream=await DatabaseMethods().getChatRooms();
    setState(() {
      
    });
 }

 Widget ChatRoomList(){
  return StreamBuilder(stream:chatRoomsStream,
  builder: (context,AsyncSnapshot  snapshot){
      return snapshot.hasData?ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
        DocumentSnapshot ds=snapshot.data.doc.length;
        return _ChatRoomListTile(chatRoomId: ds.id, lastMessage: ds["lastMessage"], myUserName: myUserName!, time: ds["lastMessageSendTs"]);

      }):Center(child: CircularProgressIndicator(),);
  });
 }


 @override
 void initState(){
  super.initState();
  ontheload();
 }

initiateChat(String myUserName, String otherUserName) async {
  String chatRoomId = getChatRoomIdbyUsername(myUserName, otherUserName);

  Map<String, dynamic> chatRoomInfoMap = {
    "users": [myUserName, otherUserName],
    "createdAt": FieldValue.serverTimestamp(),
  };

  await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
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



  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    } else {
      setState(() {
        search = true;
      });

      var capitalizedValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      //if (queryResultSet.isEmpty ) {
        DatabaseMethods().Search(value).then((QuerySnapshot docs) {
          setState(() {
            for (int i = 0; i < docs.docs.length; ++i) {
              queryResultSet.add(docs.docs[i].data());
            }
          //    queryResultSet = docs.docs.map((doc) => doc.data()).toList();
          // tempSearchStore = queryResultSet.where((element) {
          //   return element['username'].toString().startsWith(capitalizedValue);
          // }).toList();
          });

        });
      } else {
        tempSearchStore = [];
        queryResultSet.forEach((element) {
          if (element['username'].toString().startsWith(capitalizedValue)) {
            setState(() {
              tempSearchStore.add(element);
            });
          }
        });
      //    setState(() {
      //   tempSearchStore = queryResultSet.where((element) {
      //     return element['username'].toString().startsWith(capitalizedValue);
      //   }).toList();
      // });
      
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 130, 117),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(248, 253, 237, 1),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              initiateSearch(value);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search User',
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 199, 199, 197),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : const Text(
                        "ChatiGo",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 245),
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      search = !search; // Toggle the search state
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      search ? Icons.close_rounded : Icons.search_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              height: search? MediaQuery.of(context).size.height/1.9
              :MediaQuery.of(context).size.height/1.2,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(248, 253, 237, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  search
                      ? ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          children: tempSearchStore.map((element) {
                            return buildResultCard(element);
                          }).toList(),
                        )
                      : ChatRoomList(),
                ],
              ),
        ),
          )
      ],
      )
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: ()async{
       
        setState(() {
          
        });
        var ChatRoomId=getChatRoomIdbyUsername(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap ={
          "users":[myUserName,data["username"]],
        };

       await DatabaseMethods().createChatRoom(ChatRoomId, chatRoomInfoMap);
        //await initiateChat(myUserName!, data["username"]);

         Navigator.push(context,MaterialPageRoute(builder: 
         (context) =>  Chatpage(name: data["Name"],profileurl: data["photo"],username: data["username"],
         )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(data["photo"],
                height: 50.0,width: 50.0,fit: BoxFit.cover,
                )
                ),
                SizedBox(width: 20.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      data["username"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatRoomListTile extends StatefulWidget {
  final String lastMessage ,chatRoomId,myUserName,time;

  _ChatRoomListTile({required this.chatRoomId,required this.lastMessage,required this.myUserName,required this.time});

  @override
  State<_ChatRoomListTile> createState() => __ChatRoomListTileState();
}

class __ChatRoomListTileState extends State<_ChatRoomListTile> {
  String profileUrl="" ,name="",username="",id="";

  getthisUserInfo()async{
    username= widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUserName,"");
    QuerySnapshot querySnapshot=await DatabaseMethods().getUserInfo(username.toUpperCase());
    name="${querySnapshot.docs[0]["Name"]}";
    profileUrl="${querySnapshot.docs[0]["photo"]}";
    id="${querySnapshot.docs[0]["Id"]}";
    setState(() {
      
    });
  }
  @override
  void initState(){
    getthisUserInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
      child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileUrl==""?CircularProgressIndicator():
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                profileUrl,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        username,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                    widget.lastMessage,
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                      Text(
                                        widget.time,
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: 5.0),
                                  
                                ],
                    ),
                 )
              ]
         )

    );
  }
}