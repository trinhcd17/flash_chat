import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore=FirebaseFirestore.instance;
CollectionReference listMessages=_firestore.collection('messages');

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  TextEditingController messageInput=TextEditingController();
  User _currentUser;
  String message;

  Future<void> getCurrentUser() async {
    try{
      final user=_auth.currentUser;
      _currentUser=user;
      print('Username: ${_currentUser.email}');
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context,WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageInput,
                      onChanged: (value) {
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      sendMessage();
                      messageInput.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    try{
      _firestore.collection('messages').add({
        'text':message,
        'sender':_currentUser.email,
      });
    }catch(e){
      print(e);
    }
  }
  
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages=snapshot.data.documents;
        List<MessageBubble>messagesWidgets=[];
        for(var message in messages){
          final messageText=message.data()['text'];
          final messageSender=message.data()['sender'];
          final messageBubble=MessageBubble(text: messageText,sender: messageSender);
          messagesWidgets.add(messageBubble);
        }
          return Expanded(
            child: ListView(
              children: messagesWidgets,
            ),
          );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text,this.sender});
  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),),
          SizedBox(height: 2,),
          Material(
            color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30),
              elevation: 5,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Text(text,style: TextStyle(color: Colors.white,fontSize: 15),)
              ),
          ),
        ],
      ),
    );
  }
}


