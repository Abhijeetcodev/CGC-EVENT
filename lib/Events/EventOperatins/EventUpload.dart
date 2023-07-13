import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cgc_event/Events/Screens/EventPageScreen.dart';

class UpdateEvent extends StatefulWidget {
  const UpdateEvent({Key? key}) : super(key: key);

  @override
  _UpdateEventState createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {z
  TextEditingController eventTilteInputController =
      TextEditingController(text: event.titleEventfun);

  TextEditingController eventDiscriptionInputController =
      TextEditingController(text: event.discriptionfun);

  TextEditingController eventDateInputController =
      TextEditingController(text: event.dateofEventfun);

  TextEditingController eventWriterInputController =
      TextEditingController(text: event.WriterNamefun);

  TextEditingController eventClubInputController =
      TextEditingController(text: event.Clubfun);


  TextEditingController eventContactInputController =
      TextEditingController(text: event.contact);
  TextEditingController  eventInstagramController =  TextEditingController(text:event.instagramLinkFun);
 TextEditingController eventGoogleformController = TextEditingController(text: event.googleFormfun);
  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser!;
      DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            " FILL OUT THE FORM TO UPDATE ",
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
                    maxLength: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    autofocus: true,
                    autocorrect: true,
                    onChanged: (Text) {
                      setState(() {
                        eventClubInputController.text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Club/Community",
                      border: OutlineInputBorder(),
                      hintText: 'Enter The Club/Community Name',
                    ),
                    controller: eventClubInputController,
                    maxLength: 20,
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
                      maxLines: 25,
                      maxLength: 1000,
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
                  // TextField(
                  //   autofocus: true,
                  //   autocorrect: true,
                  //   decoration: InputDecoration(
                  //     labelText: "Event Date",
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter The Event venue And Time',
                  //   ),
                  //   controller: eventDateInputController,
                  //   maxLength: 20,
                  // ),
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
                  Text(
                    'Preview: ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(user.photoURL!),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(eventWriterInputController.text),
                                ],
                              ),
                              Text(DateFormat('d EE yyyy')
                                  .format(myTimeStamp.toDate())),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              Text(
                                eventTilteInputController.text,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                eventDiscriptionInputController.text,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    // visible: Admin,
                                    child: IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.edit,
                                          size: 15,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  Visibility(
                                    // visible: Admin,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        FontAwesomeIcons.trashAlt,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 5.0, 20.0, 5.0),
                                  child: Text(
                                    eventClubInputController.text,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (eventDateInputController.text.isNotEmpty &&
                            eventDiscriptionInputController.text.isNotEmpty &&
                            eventTilteInputController.text.isNotEmpty &&
                            
                             eventWriterInputController.text.isNotEmpty
                            && eventContactInputController.text.isNotEmpty) {

                             DateTime currentPhoneDate = DateTime.now(); //DateTime

Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp

DateTime myDateTime = myTimeStamp.toDate();    
                          FirebaseFirestore.instance
                              .collection("Event")
                              .doc(event.idOfEventfun)
                              .update({
                            "EventName": eventTilteInputController.text,
                            "EventDescription":
                                eventDiscriptionInputController.text,
                            "EventDate": eventDateInputController.text,
                            "Name": eventWriterInputController.text,
                          
                            "Contact": eventContactInputController.text,
                            "Club": eventClubInputController.text,
                            "TimeStamp" : myTimeStamp,
                            "AdminImage": user.photoURL!,
                            "Instagram": eventInstagramController.text,
                            "GoogleForm": eventGoogleformController.text,
                            "UserId" : user.uid,
                            
                          }).then((value) {
                            Navigator.pop(context);
                            eventTilteInputController.clear();
                            eventDateInputController.clear();
                            eventDiscriptionInputController.clear();
                          }).catchError((onError) => print(onError));
                        }
                      },
                      child: Text("Upadte")),
                ],
              ),
            ),
          ]),),]),
    );
  }
}
