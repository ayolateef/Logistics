//import 'dart:html';/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/chatusers.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';
import 'conversationlist.dart';

class ChatPage extends StatefulWidget {
  final Function(String)? callback;
  const ChatPage({Key? key, this.callback}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final RestDataService _restDataService = serviceLocator<RestDataService>();

  List<ChatUsers> chatUsers = [];
  // ChatUsers("Jane Russel", "Awesome Setup", "assets/5.jpg", "Now", true),
  // ChatUsers(
  //     "Glady's Murphy", "That's Great", "assets/5.jpg", "Yesterday", true),
  // ChatUsers(
  //     "Jorge Henry", "Hey where are you?", "assets/5.jpg", "31 Mar", true),
  // ChatUsers("Philip Fox", "Busy! Call me in 20 mins", "assets/5.jpg",
  //     "28 Mar", false),
  // ChatUsers("Debra Hawkins", "Thankyou, It's awesome", "assets/5.jpg",
  //     "23 Mar", false),
  // ChatUsers("Jacob Pena", "will update you in evening", "assets/5.jpg",
  //     "17 Mar", true),
  // ChatUsers("Andrey Jones", "Can you please share the file?", "assets/5.jpg",
  //     "24 Feb", true),
  // ChatUsers("John Wick", "How are you?", "assets/5.jpg", "18 Feb", true),
  _getAllChatUser(String token) async {
    chatUsers = await _restDataService.getChatsUSers(token);
    setState(() {
      chatUsers = chatUsers;
    });
  }

  Future<List<ChatUsers>> getChat() async {
    if (mounted) {
      //String adminusername =
      //     Provider.of<AccountViewModel>(context, listen: false).adminuser;
      String username =
          Provider.of<CreateAccountViewModel>(context, listen: false)
              .logonusername;
      String token =
          Provider.of<CreateAccountViewModel>(context, listen: false).token;

      print("got herw");

      chatUsers = await _restDataService.getChatsUSers(token);
      print(chatUsers.length);
      setState(() {});
      return chatUsers;
    }
  }

  Stream<List<ChatUsers>> getNumbers(Duration refreshTime) async* {
    if (!mounted) {
      return;
    }

    if (mounted) {
      while (true) {
        await Future.delayed(refreshTime);
        yield await getChat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 38),
          child: Scaffold(
              body: StreamBuilder(
                  stream: getNumbers(const Duration(seconds: 2)),
                  initialData: chatUsers,
                  // ignore: missing_return
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.done) {
                      return const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      );
                    }
                    if (stream.hasData) {
                      chatUsers = stream.data as List<ChatUsers>;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "Conversations",
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 2, bottom: 2),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.pink[50],
                                      ),
                                      child: Row(
                                        children: const <Widget>[
                                          Icon(
                                            Icons.add,
                                            color: Colors.pink,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Add New",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 16),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade600),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: EdgeInsets.all(8),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade100)),
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: chatUsers.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ConversationList(
                                  name: chatUsers[index].name ?? '',
                                  messageText:
                                      chatUsers[index].messageText ?? '',
                                  imageUrl: chatUsers[index].imageURL ?? '',
                                  time: chatUsers[index].time ?? '',
                                  isMessageRead:
                                      chatUsers[index].status ?? false,
                                  //     (index == 0 || index == 3) ? true : false,
                                  callback: widget.callback!,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  })),
        ),
      ],
    );
  }
}
