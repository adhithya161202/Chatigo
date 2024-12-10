import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/pages/signin.dart';
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

Widget ChatRoomList() {
  return StreamBuilder(
    stream: chatRoomsStream,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
        return Center(child: Text("No Chat Rooms Found"));
      }

      return ListView.builder(
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.docs[index];
          return _ChatRoomListTile(
            chatRoomId: ds.id,
            lastMessage: ds["lastMessage"],
            myUserName: myUserName!,
            time: ds["lastMessageSendTs"].toString(), // Convert to a string
          );
        },
      );
    },
  );
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
  List<String> users = [a, b];
  users.sort();
  return "${users[0]}_${users[1]}";
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

 
    DatabaseMethods().Search(capitalizedValue).then((QuerySnapshot docs) {
      setState(() {
        queryResultSet = docs.docs.map((doc) => doc.data()).toList();
        
        
        tempSearchStore = queryResultSet.where((element) {
          return element['username'].toString().toLowerCase().startsWith(value.toLowerCase());
        }).toList();
      });
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 130, 117),
   
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          search
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 253, 251),
                      borderRadius: BorderRadius.circular(8),
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
                        ),
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
                search = !search;
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Reduced padding
        decoration: const BoxDecoration(
          color: Color.fromRGBO(248, 253, 237, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: search
            ? ListView(
                children: tempSearchStore.map((element) {
                  return buildResultCard(element);
                }).toList(),
              )
            : ChatRoomList(),
      ),
    ),
  ],
),


    floatingActionButton: FloatingActionButton(
      onPressed: () async {

        await SharedPreferenceHelper().clearAll(); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      },
      tooltip: 'Logout',
      backgroundColor: const Color.fromARGB(255, 54, 160, 139),
      child: const Icon(Icons.logout),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        

         Navigator.push(context,MaterialPageRoute(builder: 
         (context) =>  Chatpage(name: data["Name"],profileurl: data["photo"],username: data["username"],
         )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
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
                height: 40.0,width: 40.0,fit: BoxFit.cover,
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


  getthisUserInfo() async {
  username = widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUserName, "");
  QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username.toUpperCase());

  if (querySnapshot.docs.isNotEmpty) {
    name = "${querySnapshot.docs[0]["Name"]}";
    profileUrl = "${querySnapshot.docs[0]["photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    // setState(() {});
    if (mounted) {
  setState(() {});
}

  } 
}

  @override
  void initState(){
    getthisUserInfo();
    super.initState();
  }



@override
Widget build(BuildContext context) {
  
  return GestureDetector(
    onTap: () {
      // Navigate to ChatPage with user info
      setState(() {
          
        });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chatpage(
            name: name.isNotEmpty ? name : username, // Use the retrieved name or username
            profileurl: profileUrl,
            username: username,
          ),
        ),
      );
    },
   
    child: Container(
       margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          profileUrl == ""
              ? const CircularProgressIndicator()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    profileUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
          const SizedBox(width: 15.0),
          // Chat Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                Text(
                  name.isNotEmpty ? name : username,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Text(
                    widget.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          // Timestamp
          Text(
            widget.time,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    ),
  );
}

 }
