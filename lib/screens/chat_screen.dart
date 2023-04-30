import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

   String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser;
      if(user != null) { // this mean that we do have a currently signed in user
        loggedInUser = user;
      //  print(loggedInUser.email);
      }
      }
      catch(e){
      print(e);
    }
  }

  // void getMessage() async {
  //  final message = await  _firestore.collection('message').get();
  //  for (var msg in message.docs){
  //    print(msg.data());
  //  }
  // }

  void messageStream () async {
    await for(var snapShot in _firestore.collection('message').snapshots()){
       for (var msg in snapShot.docs){
         print(msg.data());
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
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
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageTextController.clear();
                      // messageText + loggedInuser.email;
                      _firestore.collection('message').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
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
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('message').snapshots(),
        // The below snapshot is not same as the above snapshot the above is for
        // for the firebase query and this is use for the flutter async snapshot
        // because we working with the our stream builder.
        builder: (context, snapshot){
          if( !snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),

            );
          }

          final message = snapshot.data.docs.reversed; // This is how we can access the data insdie our async snapshot.
          List<messageBubble> messageBubbles = [];
          for( var msgs in message){

            final messageText = (msgs.data() as Map<String, dynamic>)['text'];
            final messageSender = (msgs.data() as Map<String, dynamic>)['sender'];
            final currentUser = loggedInUser.email;

            final messageBubbless =
            messageBubble(
                sender: messageSender,
                text: messageText,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubbless);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            ),
          );
        }
    );
  }
}


class messageBubble extends StatelessWidget {

  messageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender , style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),),
          Material(
            borderRadius: isMe ? BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30), bottomRight: Radius.circular(30)) : BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30), topRight: Radius.circular(30),),

            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text('$text',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15,

                ),),
            ),
          ),
        ],
      ),
    );
  }
}
