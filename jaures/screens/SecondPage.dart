import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/screens/MainPage.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);
  //final String title;
  static const routeName = '/MyGeoLocalizationClass';

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  /*######################################################################################*/
  StreamSubscription _locationSubscription;
  Location _locationTracker = new Location();
  static final LatLng sourceLocation00 = LatLng(4.050673, 9.747857);
  LatLng sourceLocation;
  Marker marker;
  Circle circle;
  int _locationIndex;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; //
  GoogleMapController _controller;

  /*######################################################################################*/
  final Telephony telephony = Telephony.instance;
  String _message;
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
    _valueSms.text = '2'; //NOMBRE D'ENVOI par clique
    sourceLocation = LatLng(4.050673, 9.747857);
    _message = "";
    _locationIndex = 3;
    //initPlatformState();
  }

  /*######################################################################################*/
  _sendSMS() async {
    int _sms = 0;
    while (_sms < int.parse(_valueSms.text)) {
      telephony.sendSms(to: _phoneController.text, message: _msgController.text);
      _sms++;
    }
  }

  _getSMS() async {
    setState(() async {
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
        _message = _messages.last.toString();
      }
    });
  }

  /*######################################################################################*/
  Future<LocationData> getLocation22(LatLng asyncsourceLocation) async {
    var location = await _locationTracker.getLocation();
    var location2 = LocationData.fromMap({
      'latitude': sourceLocation.latitude,
      'longitude': sourceLocation.longitude,
      'accuracy': location.accuracy,
      'altitude': location.altitude,
      'speed': location.speed,
      'speedAccuracy': location.speedAccuracy,
      'heading': location.heading,
      'time': location.time,
      'isMock': location.isMock,
      'verticalAccuracy': location.verticalAccuracy,
      'headingAccuracy': location.headingAccuracy,
      'elapsedRealtimeNanos': location.elapsedRealtimeNanos,
      'elapsedRealtimeUncertaintyNanos': location.elapsedRealtimeUncertaintyNanos,
      'satelliteNumber': location.satelliteNumber,
      'provider': location.provider
    });
    return location2;
  }

  onMessage(SmsMessage message) async {
    setState(() async {
      // _message = message.body ?? "Error reading message body.";
      if (message.body != null) {
        _message = message.body;
        //if (message.address == _phoneController.value)
        //String s1 = "Latitude : 4.050673 Longitude : 9.747857 \n Wind Speed : 0.06 kph My Module Is Working. Mewan Indula Pathirage. Try With This Link. http://www.latlong.net/Show-Latitude-Longitude.html http://maps.google.com/maps?q=4.050673,9.747857";
        //String s2 = "Latitude : 4.050673\nLongitude : 9.747857\nWind Speed : 0.06 kph\nMy Module Is Working. Mewan Indula Pathirage. Try With This Link.\nhttp://www.latlong.net/Show-Latitude-Longitude.html\nhttp://maps.google.com/maps?q=4.050673,9.747857";
        String s = _message.replaceAll("\n", " ");
        List parts = s.split(":");
        var lat = (parts[1]).split("Longitude")[0].split(" ")[1];
        var long = parts[2].split(" ")[1];
        //print('Lat:${lat}m  Long:${long}m');
        sourceLocation = LatLng(double.tryParse(lat) ?? sourceLocation.latitude, double.tryParse(long) ?? sourceLocation.longitude);
        _message = "Lat : " + sourceLocation.latitude.toString() + " Long : " + sourceLocation.longitude.toString() + "";

        Uint8List imageData = await getMarker();
        var location = await getLocation22(sourceLocation);
        updateMarkerAndCircle(location, imageData);
        /*
	      ScaffoldMessenger.of(ctx).showSnackBar(
	        SnackBar(
	          content: Text(_message),
	          backgroundColor: Theme.of(ctx).errorColor,
	          duration: Duration(seconds: 6, milliseconds: 500),
	        ),
        );
        */
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

  backgrounMessageHandler(SmsMessage message) async {
    //Handle background message
    // Use plugins
    //Vibration.vibrate(duration: 500);
  }
  onBackgroundMessage(SmsMessage message) {
    debugPrint("onBackgroundMessage called");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (_permissionsGranted != null && _permissionsGranted) {
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }
  }

  /*######################################################################################*/

  static final CameraPosition initialLocation = CameraPosition(
    target: sourceLocation00,
    zoom: 14.4746,
    tilt: 0, //80
    bearing: 30,
  );

//  var _dist;
/*
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  } // to delete !!!!

  Future<void> _addMarker(tmp_lat, tmp_lng) async {
    var markerIdVal = _locationIndex.toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/garcon.png', 100);

    // creating a new MARKER
    final Marker marker = Marker(
      icon: BitmapDescriptor.fromBytes(markerIcon),
      markerId: markerId,
      position: LatLng(tmp_lat, tmp_lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: 'boop'),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  } // !!!!
  */

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/images/fille.png");
    ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 80);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
    // return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      //marker = Marker(markerId: MarkerId("home"), position: latlng, rotation: newLocalData.heading, draggable: false, zIndex: 2, flat: true, anchor: Offset(0.5, 0.5), icon: BitmapDescriptor.fromBytes(imageData));
      marker = Marker(markerId: MarkerId("home"), position: latlng, rotation: marker.rotation, draggable: false, zIndex: 2, flat: true, anchor: Offset(0.5, 0.5), icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(circleId: CircleId("eleve"), radius: newLocalData.accuracy, zIndex: 1, strokeColor: Colors.blue, center: latlng, fillColor: Colors.blue.withAlpha(70));
      // adding a new marker to map
      //markers[MarkerId("home")] = marker; ???
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      //_dist = await _getPosition();
      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          var zoom = _controller.getZoomLevel();
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            //bearing: 192.8334901395799, //
            target: LatLng(newLocalData.latitude, newLocalData.longitude), //
            //tilt: 0, //
            zoom: double.tryParse(zoom.toString()), //18.00 //
          )));
          //updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

/*
SmsMessage {
  int? id;
  String? address;
  String? body;
  int? date;
  int? dateSent;
  bool? read;
  bool? seen;
  String? subject;
  int? subscriptionId;
  int? threadId;
  SmsType? type;
  SmsStatus? status;
*/
  /*######################################################################################*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carte Lat : " + sourceLocation.latitude.toString() + " Long : " + sourceLocation.longitude.toString() + ""),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Numero de l"enfant'),
                      onChanged: (value) {
                        setState(() {
                          initPlatformState();
                        });
                      },
                    ),
                  ),
                  IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                        Icons.send,
                      ),
                      onPressed: () async {
                        _getSMS();
                        initPlatformState();
                      }),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 30,
              //child: RaisedButton(
              //onPressed: () {
              //Navigator.pop(context);
              //Navigator.of(context).pushReplacementNamed(MainPage.routeName);
              //},
              //              child: Text("Latitude : " + _locationTracker.getLocation().toString() + " Longitude :" + _locationTracker.getLocation().longitude.toString()),
              child: Text('Message : ' + _message), //_getPosition(),
              //),
            ),
            if (_messages != null)
              Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.all(20),
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
            Container(
              width: double.infinity,
              height: 400,
              child: GoogleMap(
                mapType: MapType.normal, //hybrid
                initialCameraPosition: initialLocation,
                //myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                markers: Set.of((marker != null)
                    ? [
                        marker
                        //markers
                      ]
                    : []),
                circles: Set.of((circle != null)
                    ? [
                        circle
                      ]
                    : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () async {
            //_getSMS();
            getCurrentLocation();
            //initPlatformState();
          }),
    );
  }
}
