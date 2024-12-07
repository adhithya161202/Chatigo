import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 85, 85),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color.fromARGB(255, 255, 255, 245),
                ),
                const SizedBox(width: 100.0),
                const Text(
                  "Adhithya",
                  style: TextStyle(
                    color: Color.fromARGB(255, 227, 227, 214),
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 20.0, right: 5),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 235, 239, 226),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2.0,
                    ),
                    alignment: Alignment.bottomRight,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 142, 231, 206),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Hello how was your day?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 1.5,
                    ),
                    alignment: Alignment.topLeft,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 217, 221, 139),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "It was great",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0), // Add bottom padding
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  
                                  decoration: InputDecoration(
                                    
                                    border: InputBorder.none,
                                    hintText: "Type a message",
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              
                              ),
                              Container(
                                child: 
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.send, color: const Color.fromARGB(255, 103, 127, 136),),
                                )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
