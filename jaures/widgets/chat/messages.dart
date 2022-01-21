import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telephony/telephony.dart';

import 'package:flutter_complete_guide/widgets/chat/message_bubble.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);
  //final String title;
  static const routeName = '/Messages';

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
//class Messages extends StatelessWidget {

  backgrounMessageHandler(SmsMessage message) async {
    //Handle background message
    // Use plugins
    //Vibration.vibrate(duration: 500);
  }
  onBackgroundMessage(SmsMessage message) {
    debugPrint("onBackgroundMessage called");
  }

  final Telephony telephony = Telephony.instance;
  String _message = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _valueSms = TextEditingController();
  List<SmsMessage> _messages;
  bool _permissionsGranted; //= await telephony.requestPhoneAndSmsPermissions;

  @override
  void initState() {
    super.initState();
    _phoneController.text = '+237698203203'; //'+237656153698'
    _msgController.text = 'Salut Jaures :)';
    _valueSms.text = '2'; //nombre d'envoi par clique
    //initPlatformState();
  }

  _sendSMS() async {
    int _sms = 0;
    while (_sms < int.parse(_valueSms.text)) {
      telephony.sendSms(to: _phoneController.text, message: _msgController.text);
      _sms++;
    }
  }

  _getSMS() async {
    setState(() async {
      //final bool? result = await telephony.requestPhoneAndSmsPermissions;
      _permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      if (_permissionsGranted != null && _permissionsGranted) {
        _messages = await telephony.getInboxSms(
          columns: [
            SmsColumn.ID,
            SmsColumn.ADDRESS,
            SmsColumn.BODY,
            SmsColumn.DATE
          ],
          filter: SmsFilter.where(SmsColumn.ADDRESS).like(_phoneController.text),
          sortOrder: [
            OrderBy(SmsColumn.DATE, sort: Sort.DESC),
            OrderBy(SmsColumn.ID)
          ],
        ); //.equals(_phoneController.text)
      }
      //if (!mounted) return;
    });
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
      if (message.body != null) {
        _message = message.body;
        //String s1 = "Latitude : 4.050673 Longitude : 9.747857 \n Wind Speed : 0.06 kph My Module Is Working. Mewan Indula Pathirage. Try With This Link. http://www.latlong.net/Show-Latitude-Longitude.html http://maps.google.com/maps?q=4.050673,9.747857";
        //String s2 = "Latitude : 4.050673\nLongitude : 9.747857\nWind Speed : 0.06 kph\nMy Module Is Working. Mewan Indula Pathirage. Try With This Link.\nhttp://www.latlong.net/Show-Latitude-Longitude.html\nhttp://maps.google.com/maps?q=4.050673,9.747857";
        String s = _message.replaceAll("\n", " ");
        List parts = s.split(":");
        var lat = (parts[1]).split("Longitude")[0].split(" ")[1];
        var long = parts[2].split(" ")[1];
        //print('Lat:${lat}m  Long:${long}m');

      } else {
        _message = "Error reading message body.";
      }
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    //final bool? result = await telephony.requestPhoneAndSmsPermissions;
    _permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (_permissionsGranted != null && _permissionsGranted) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //return FutureBuilder(
    //future: FirebaseAuth.instance.currentUser(),
    //builder: (ctx, futureSnapshot) {
    if (false) //(futureSnapshot.connectionState == ConnectionState.waiting)
    {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (_messages != null)
        for (var msg in _messages) {
          print(msg.body);
          print(msg.address);
          print(msg.date.toString());
          print(msg.dateSent);
          print(msg.subject);
        }

      return SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 300,
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (_messages != null)
                Container(
                  width: double.infinity,
                  height: 180,
                  margin: EdgeInsets.all(10),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                      _messages[index].body,
                      _messages[index].address,
                      true, //isMe
                      //key: ValueKey(chatDocs[index].documentID),
                    ),
                  ),
                ),
              Text("Dernier SMS reçu: " + _message),
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.send,
                ),
                onPressed: () {
                  _getSMS();
                  initPlatformState();
                  //_permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
                },
              ),
            ],
          ),
        ),
      );
    }
    /*
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['username'],
                  chatDocs[index]['userId'] == futureSnapshot.data.uid,
                  key: ValueKey(chatDocs[index].documentID),
                ),
              );
            });
			*/
    //},
    //)	;
  }
}
