import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cgc_event/Events/Screens/EventPageScreen.dart';


class Eventdetails extends StatefulWidget {
  const Eventdetails({Key? key}) : super(key: key);

  @override
  State<Eventdetails> createState() => _EventdetailsState();
}


var boxFit = [
  BoxFit.contain,
  BoxFit.cover,
  BoxFit.fill,
  BoxFit.fitHeight,
  BoxFit.fitWidth,
];

class _EventdetailsState extends State<Eventdetails> {
  @override
  Widget build(BuildContext context) {
    Timestamp? myDateTime = event.dateTimefun;
    Color? _colorsHeart = Colors.amber;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
          color: Colors.black,),
          
          onPressed: () {
            FirebaseFirestore.instance
                .collection("Event")
                .doc(event.idOfEventfun)
                .update({
              'Claps': event.Clapsfun,
            });
            Navigator.pop(context);
          },
          
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.1),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            
                            Expanded(
                              //(MediaQuery.of(context).size.width)
                              child: Container(
                                width: MediaQuery.of(context).size.width ,
                                child: Text(
   
                                  event.titleEventfun!,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 5,
                                ),
                              ),
                            ),
                          
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(event.imagefun!),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(event.WriterNamefun!),
                                    Text(
                                      DateFormat('d EE yyyy').format(
                                        myDateTime!.toDate(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                              Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 5.0, 20.0, 5.0),
                                child: Text(
                                  event.Clubfun!,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                         Container(
                              height: 350,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                
                                image: DecorationImage(
                                  fit: boxFit[event.imageSizefun!],
                                  image: NetworkImage(
                                   event.EventImagefun!,
                                  ),
                                ),
                              ),),
                              SizedBox(height: 10,),

                        Text(
                          event.discriptionfun!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                          maxLines: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  linkCreator(event.googleFormfun!);
                                },
                                icon: Image.asset('Assets/images/googleform.png',
                                    height: 22, width: 30)),
                            IconButton(
                              onPressed: () {
                                linkCreator(event.instagramLinkFun!);
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                              ),
                            ),
                           
                           
                            
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        event.Claps++;
                                       
                                      });
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.handHoldingHeart,
                                      color: Colors.redAccent,
                                    )),
                                Text(event.Claps.toString() + ' Hearts'),
                              ],
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: FaIcon(FontAwesomeIcons.shareAlt)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void linkCreator(String str) async {
    var url = str;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AlertDialog(
        title: const Text('Technical Error: '),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Link not provided or not workin'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  }
}
