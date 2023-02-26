import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
// import 'package:intent/intent.dart' as android_intent;
// import 'package:intent/action.dart' as android_action;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../../model/ChatMessage.dart';
import '../../model/chatmessagedto.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../viewmodel/createaccount.dart';

class ChatDetailPage extends StatefulWidget {
  String? username;
  final Function(String)? callback;
  //ChatPage({Key key, this.callback} ) : super(key: key);
  ChatDetailPage({Key? key, this.callback, @required this.username})
      : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

const socketUrl =
    'http://ec2-13-59-232-253.us-east-2.compute.amazonaws.com:30122/websocket-chat';

class _ChatDetailPageState extends State<ChatDetailPage> {
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  List<ChatMessage> messages = [];

  StompClient? stompClient;

  String message = "";
  String usernames = "";

  var editControllerMsg = TextEditingController();

  getmessages(String token) async {
    String? username =
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .chatusername;
    String url =
        "http://ec2-13-59-232-253.us-east-2.compute.amazonaws.com:30122/messages2/all/admin/$username";
    //  print("got herw");
    messages = await _restdataService.getMessage(token, url);
    //  print("got herw 2");
    //  print(messages);
    setState(() {
      messages = messages;
    });
  }

  Future<List<ChatMessage>?>? getChat() async {
    if (mounted) {
      //String adminusername =
      //     Provider.of<AccountViewModel>(context, listen: false).adminuser;
      String? username =
          Provider.of<CreateAccountViewModel>(context, listen: false)
              .chatusername;
      //   print("username -$username");
      String token =
          Provider.of<CreateAccountViewModel>(context, listen: false).token;
      //  print("Admin $adminusername");
      String url =
          "http://ec2-13-59-232-253.us-east-2.compute.amazonaws.com:30122/messages2/all/admin/$username";
      //    print("got herw $url");

      messages = await _restdataService.getMessage(token, url);
      print(messages.length);
      setState(() {});
      return messages;
    }
    return null;
  }

  _launchURL() async {
    // Replace 12345678 with your tel. no.
    // String phone =
    //     Provider.of<AccountViewModel>(context, listen: false).adminphone;

    // android_intent.Intent()
    //   ..setAction(android_action.Action.ACTION_DIAL)
    //   ..setData(Uri(scheme: "tel", path: phone))
    //   ..startActivity().catchError((e) => print(e));
  }

  Stream<List<ChatMessage>> getNumbers(Duration refreshTime) async* {
    if (!mounted) return;

    if (this.mounted) {
      while (true) {
        await Future.delayed(refreshTime);
        yield await getChat();
      }
    }
  }

  initClient(String? token) async {
    try {
      if (stompClient != null && stompClient!.connected) {
        print("already connected");
        return;
      }
      if (stompClient == null) {
        //  stompClient.deactivate();
        stompClient = StompClient(
          config: StompConfig.SockJS(
            url: socketUrl,
            stompConnectHeaders: {
              'Authorization': 'Bearer $token', // please note <<<<<
            },
            webSocketConnectHeaders: {
              'Authorization': 'Bearer $token', // please note <<<<<
            },
            onStompError: (StompFrame frame) {
              print(
                  'A stomp error occurred in web socket connection :: ${frame.body}');
            },
            onWebSocketError: (dynamic frame) {
              print(
                  'A Web socket error occurred in web socket connection :: ${frame.toString()}');
            },
            onDebugMessage: (dynamic frame) {
              print(
                  'A debug error occurred in web socket connection :: ${frame.toString()}');
            },
            onConnect: onConnect,
            heartbeatIncoming: 3,
          ),
        );

        stompClient?.activate();
        print("stomp connected");
        print(stompClient?.connected);
      }
    } catch (e) {
      print('An error occurred ${e.toString()}');
    }
  }

  void onConnect(StompClient client, StompFrame frame) {
    String url = "/topic/chat";
    print("subscribe 1");
    client.subscribe(
      destination: url,
      callback: (StompFrame frame) {
        print("Check frame");
        if (frame.body != null) {
          List<dynamic> result = json.decode(frame.body);
          print("frame body not null");
          List<ChatMessage> values = <ChatMessage>[];
          if (result.isNotEmpty) {
            for (int i = 0; i < result.length; i++) {
              ChatMessage notify = ChatMessage.fromJson(result[i]);
              print("message 1");
              values.add(notify);
            }
          }

          //     print(result['messages']);
          //     setState(() => messages = values);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    super.initState();
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    initClient(token);
    usernames = widget.username!;
    //  getmessages(token);
  }

  @override
  void dispose() {
    // stompClient.deactivate();
    super.dispose();
  }

  _sendClientMessage() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');

    String formattedDate = formatter.format(now);
    String? username =
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .chatusername;
    //     Provider.of<AccountViewModel>(context, listen: false).adminuser;
    String adminusername =
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .logonusername;
    ChatRequestDTO2 chatRequestDTO2 = ChatRequestDTO2(
        adminusername, username!, editControllerMsg.text, formattedDate);
    print(editControllerMsg.text);
    print("stomp connected here");
    print(stompClient?.connected);
    if (stompClient != null && stompClient!.connected) {
      stompClient?.send(
          destination: '/app/chatadmin',
          body: jsonEncode(chatRequestDTO2.toJson()),
          headers: {});
      setState(() {
        editControllerMsg.clear();
      });
    } else {
      // stompClient.activate();
      print(editControllerMsg.text);
      print("stomp connected2");
      print(stompClient?.connected);
    }
  }

  // _callNumber(String phoneNumber) async {
  //   String number = phoneNumber;
  //   await FlutterPhoneDirectCaller.callNumber(number);
  // }

  @override
  Widget build(BuildContext context) {
    String? username =
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .chatusername;
    return Stack(
      children: <Widget>[
        Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 38),
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                flexibleSpace: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            widget.callback!("chatpage");
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        const CircleAvatar(
                          backgroundImage: AssetImage("assets/5.jpg"),
                          maxRadius: 20,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                username ?? '',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Online",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     _launchURL();
                        //   },
                        //   icon: Icon(
                        //     Icons.phone,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              body: StreamBuilder(
                  stream: getNumbers(const Duration(seconds: 2)),
                  initialData: messages,
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
                      messages = stream.data as List<ChatMessage>;

                      return Stack(
                        children: <Widget>[
                          ListView.builder(
                            itemCount: messages.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10, bottom: 90),
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment:
                                      (messages[index].messageType == "receiver"
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (messages[index].messageType ==
                                              "receiver"
                                          ? Colors.grey.shade200
                                          : Colors.blue[200]),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      messages[index].messageContent ?? '',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                              return null;
                            },
                          ),
                          // SizedBox(
                          //   height: 200,
                          // ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 10, top: 10),
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: double.infinity,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: editControllerMsg,
                                      decoration: const InputDecoration(
                                          hintText: "Write message...",
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {
                                      _sendClientMessage();
                                    },
                                    backgroundColor: Colors.blue,
                                    elevation: 0,
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ))
      ],
    );
  }
}
