import 'package:chatapp/pages/chatpage.dart';
import 'package:chatapp/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
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
              decoration: const BoxDecoration(
                color: Color.fromRGBO(248, 253, 237, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: search
                  ? ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList(),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Chatpage()),
                            );
                          },
                          child: userCard("Adhithya", "Hello what are you doing?", "04:30"),
                        ),
                        const SizedBox(height: 20.0),
                        userCard("Adhithya", "Hello what are you doing?", "04:30"),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userCard(String name, String message, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.asset(
            "images/mess3.png",
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildResultCard(data) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["Name"],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    data["username"],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
