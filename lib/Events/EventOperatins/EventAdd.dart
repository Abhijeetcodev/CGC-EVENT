import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

var ClubSelectedEvent = 'ACM';
class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late TextEditingController eventTilteInputController;
  late TextEditingController eventDiscriptionInputController;

  late TextEditingController eventDateInputController;

  late TextEditingController eventWriterInputController;

  late TextEditingController eventClubInputController;

  late TextEditingController eventContactInputController;
  late TextEditingController eventInstagramController;
  late TextEditingController eventGoogleformController;
  var data;
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventTilteInputController = TextEditingController();
    eventDiscriptionInputController = TextEditingController();
    eventDateInputController = TextEditingController();

    eventWriterInputController = TextEditingController();
    eventClubInputController = TextEditingController();
    eventContactInputController = TextEditingController();
    eventInstagramController = TextEditingController();
    eventGoogleformController = TextEditingController();

    // eventWriterInputController.addListener(() {
    //   prviewWriter = eventWriterInputController.text;
    // });
  }

  final user = FirebaseAuth.instance.currentUser!;

  var Number = 0;

  var boxFit = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitHeight,
    BoxFit.fitWidth,
  ];
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    Future pickImage() async {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image == null) return;
        final imageTemporary = File(image.path);

        setState(() {
          this.image = imageTemporary;
        });
      } on PlatformException catch (e) {
        print('Faild to pick image: $e');
      }
    }

    late String imgurl;
    Future<void> Upload(File? _image1) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      String filename = basename(_image1!.path);

      TaskSnapshot snapshot = await storage
          .ref()
          .child("Eventimages/" + filename + DateTime.now().toString())
          .putFile(_image1);
      if (snapshot.state == TaskState.success) {
        imgurl = await snapshot.ref.getDownloadURL();
      }
      DateTime currentPhoneDate = DateTime.now(); //DateTime

      Timestamp myTimeStamp =
          Timestamp.fromDate(currentPhoneDate); //To TimeStamp

      DateTime myDateTime = myTimeStamp.toDate();

      final int Claps = 0;

      try {
        FirebaseFirestore.instance
            .collection("Event")
            .add({
              "Name": eventWriterInputController.text,
              "Claps": Claps,
              "Image": imgurl.toString(),
              "ImageSize": Number,
              "EventName": eventTilteInputController.text,
              "EventDescription": eventDiscriptionInputController.text,
              "EventDate": eventDateInputController.text,
              "Contact": eventContactInputController.text,
              "Club": ClubSelectedEvent,
              "TimeStamp": myDateTime,
              "AdminImage": user.photoURL!,
              "Instagram": eventInstagramController.text,
              "GoogleForm": eventGoogleformController.text,
              "UserId": user.uid,
            })
            .then((value) {})
            .catchError((onError) => print(onError));

        final snackBar = SnackBar(content: Text("Your Image  is uploaded! ✅"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e.toString());
      }
    }

    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "PLEASE FILL THE FORM ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  eventTilteInputController.clear();
                  eventDateInputController.clear();
                  eventDiscriptionInputController.clear();
                  eventContactInputController.clear();
                  eventInstagramController.clear();
                  eventWriterInputController.clear();
                  eventClubInputController.clear();
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: ListView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        //  prviewWriter = text;
                        eventWriterInputController.text;
                      });
                    },
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      labelText: "Your Name",
                      border: OutlineInputBorder(),
                      hintText: 'Enter The Your Name',
                    ),
                    controller: eventWriterInputController,
                    maxLength: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: MyStatefulWidget(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      child: (image != null)
                          ? Image.file(image!, fit: boxFit[Number])
                          : Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('Assets/images/clubone.jpg'),
                                  fit: boxFit[Number],
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          pickImage();
                        },
                        icon: Icon(
                          FontAwesomeIcons.camera,
                        ),
                        label: Text("Pick Image"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          eventWriterInputController.clear();
                        },
                        icon: Icon(FontAwesomeIcons.trashAlt),
                        label: Text("Delete"),
                      ),
                    ],
                  )),
                  SizedBox(height: 15,),
                  TextField(
                    autofocus: true,
                    autocorrect: true,
                    onChanged: (text) {
                      setState(() {
                        //  prviewWriter = text;
                        eventTilteInputController.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Event Name",
                      border: OutlineInputBorder(),
                      hintText: 'Enter The Event Name',
                    ),
                    controller: eventTilteInputController,
                    maxLength: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 Align(
                    alignment: Alignment.topLeft,
                    child: ClubChoose(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.all(12),
                    height: 500,
                    width: 500,
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          eventDiscriptionInputController.text;
                        });
                      },
                      maxLines: 40,
                      maxLength: 2000,
                      controller: eventDiscriptionInputController,
                      decoration: InputDecoration(
                        labelText: "Event Description",
                        hintText: "Enter Event Description",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    autofocus: true,
                    autocorrect: true,
                    onChanged: (text) {
                      setState(() {
                        //  prviewWriter = text;
                        eventClubInputController.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Instagram",
                      border: OutlineInputBorder(),
                      hintText: 'Provide the link',
                    ),
                    controller: eventInstagramController,
                    maxLength: 150,
                  ),
                  TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      labelText: "Google Form",
                      border: OutlineInputBorder(),
                      hintText: 'Please Provide Google Form Link',
                    ),
                    controller: eventGoogleformController,
                    maxLength: 150,
                  ),
                  SizedBox(
                    height: 10,
                  ),
              
                
                  TextField(
                    controller: eventDateInputController,
                    decoration: InputDecoration(
                      labelText: "EVENT DATE",
                      icon: FaIcon(FontAwesomeIcons.calendar),
                    ),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
                      FocusScope.of(context).requestFocus(new FocusNode());

                      date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));

                      eventDateInputController.text =
                          DateFormat('d EE yyyy').format(date!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      labelText: "Contact",
                      border: OutlineInputBorder(),
                      hintText: 'Enter The Contact',
                    ),
                    controller: eventContactInputController,
                    maxLength: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 
                  Divider(
                    thickness: 3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (eventDiscriptionInputController.text.isNotEmpty &&
                            eventTilteInputController.text.isNotEmpty) {
                          DateTime currentPhoneDate = DateTime.now(); //DateTime

                          Timestamp myTimeStamp = Timestamp.fromDate(
                              currentPhoneDate); //To TimeStamp

                          DateTime myDateTime = myTimeStamp.toDate();
                          Upload(image);
                          Navigator.pop(context);

                        }
                      },
                      icon: FaIcon(FontAwesomeIcons.save),
                      label: Text("Save")),
                ],
              ),
            ),
          ]),
    );
  }

  Future _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(() => {
            data = picked.toString(),
            eventDateInputController.text = picked.toString()
          });
  }
}

var Number = 0;


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Contain';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          switch (newValue) {
            case 'Contain':
              Number = 0;
              break;
            case 'Cover':
              Number = 1;
              break;
            case 'Fill':
              Number = 2;
              break;
            case 'FitHeight':
              Number = 3;
              break;
            case 'FitWidth':
              Number = 4;
              break;
          }
        });
      },
      items: <String>['Contain', 'Cover', 'Fill', 'FitHeight', 'FitWidth']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}



class ClubChoose extends StatefulWidget {
  ClubChoose({Key? key}) : super(key: key);

  @override
  ClubChooseState createState() => ClubChooseState();
}

class ClubChooseState extends State<ClubChoose> {
  String dropdownValue = 'ACM';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          ClubSelectedEvent = newValue;
        });
      },
      items: <String>[
        'ACM',
        'TECH AMIGOS',
        'ARTISTIA',
        'CHAMPIONS',
        'PRAYAS',
        'PIXEL',
        'VIRASAT',
        'RANG MANCH',
        'FLAMING DESIRE',
        'GSDC'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}



