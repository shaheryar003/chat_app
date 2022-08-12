
import 'package:chat_app/screens/homescreen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirebaseFirestore _firestore=FirebaseFirestore.instance;
class ChatScreen extends StatefulWidget {
  static const String id='chatscreen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatcontrollor=TextEditingController();

  String? textMessage;
  final _auth=FirebaseAuth.instance;
  User? loggedInUser;
  @override
  void initState() {
    getCurrentUser();
    getUserData();
    super.initState();
  }

  void getUserData(){

    var snapShot=FirebaseFirestore.instance.collection("AppUser").doc(_auth.currentUser!.uid.toString()).get();

   
  }

  void getCurrentUser()async
  {
    try {
      final user = _auth.currentUser;
      if (user != _auth.currentUser) {
        loggedInUser = user;
        
      }
    }
    catch (e) {

    }
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('FLASH CHAT',style: TextStyle(color: Colors.white,fontSize: 30),),
        actions: [
          IconButton(
              onPressed:(){
                Navigator.pushNamed(context, LoginScreen.id);
              } ,
              icon: const Icon(Icons.logout_outlined),),

                IconButton(
              onPressed:(){
                Navigator.pushNamed(context, home.id);
              } ,
              icon: const Icon(Icons.face),),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot?>(
              stream:  _firestore
                  .collection('messages')
                  .orderBy('time', descending: false)//add this
                  .snapshots(),
              builder: (context,snapshot){
                List<MessageBubble> messageWidget=[];
             
                    final messages=snapshot.data!.docs.reversed;
                    for(var message in messages)
                      {
                        final messageText=message['text'];
                        final messageSender=message['sender'];
                      //  final messageTime = (message['time'] as Timestamp).toDate();
                        final curretUserEmail=loggedInUser?.email;
                        final messageWidgett=MessageBubble(messageText,messageSender,curretUserEmail==messageSender);
                        messageWidget.add(messageWidgett);
                      }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: messageWidget,
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: chatcontrollor,

                    onChanged: (value){
                      textMessage=value;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.lightBlueAccent,width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.lightBlueAccent,width: 2),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: MaterialButton(
                    child: Icon(Icons.send,color: Colors.green,),
                    onPressed: ()async{
                     await _firestore.collection('messages').add({
                        'text':textMessage,
                        'sender':loggedInUser?.email,
                       'time': FieldValue.serverTimestamp(),
                      });
                      
                     setState((){
                       chatcontrollor.clear();
                    
                       
                     });
                    
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class MessageBubble extends StatelessWidget {
  MessageBubble(this.messageText,this.messageSender,this.isMe,);
  bool isMe;
  final String messageText;
  final String messageSender;
  //final DateTime time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10,right: 10,bottom: 5,left: 10),
            child: Text('$messageSender'),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              elevation: 7,
              borderRadius: BorderRadius.circular(20),
              color: isMe?Colors.lightBlueAccent:Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('$messageText',maxLines: 80,overflow:TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:16,
                    color: isMe?Colors.white:Colors.black,),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}














