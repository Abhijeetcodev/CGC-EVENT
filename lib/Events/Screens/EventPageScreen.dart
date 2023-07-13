import 'package:flutter/material.dart';
import 'package:cgc_event/Events/EventClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cgc_event/Events/Screens/EventArticlePage.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cgc_event/Home/Operations/PostOperation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cgc_event/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

EventClass event = EventClass();

class EventPageScreen extends StatefulWidget {
  const EventPageScreen({Key? key}) : super(key: key);

  @override
  _EventPageScreenState createState() => _EventPageScreenState();
}

class _EventPageScreenState extends State<EventPageScreen> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Event')
      .orderBy('TimeStamp', descending: true)
      .snapshots();
  late List<DocumentSnapshot> snapshot;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    ConnectionCheck();
  }

  Future loadData() async {
    _usersStream.listen((event) {
      setState(() {
        snapshot = event.docs;
        isLoading = false;
      });
    });
  }

  Future ConnectionCheck() async {
    bool connection = await InternetConnectionChecker().hasConnection;
    if (connection == false) {
      return Navigator.push(
          context, MaterialPageRoute(builder: (context) => No_Internet()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("[]][][[]][][][][[][]][][]][[]]]]]]]]]]]]]]][[[" +
              snapshot.error.toString());
          return AlertDialog(
            title: const Text('Technical Error: '),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Something went Wrong'),
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
          ;
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return  Center(
        //       child: LoadingBouncingGrid.square(
        //         borderColor: Colors.cyan,
        //         borderSize: 3.0,
        //         size: 50.0,
        //         backgroundColor: Colors.cyanAccent,
        //         duration: Duration(seconds: 1),
        //       ),
        //     );
        // }
        final user = FirebaseAuth.instance.currentUser!;
        var myList = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: myList.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                     
                      if (isLoading) {
                        return buildShimmer(context);
                      } else {
                        Timestamp myDateTime =
                            (myList.docs[index]['TimeStamp']) ?? 1;
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: InkWell(
                            onTap: () {
                              event.imagefun = myList.docs[index]['AdminImage'];
                              event.titleEventfun =
                                  myList.docs[index]['EventName'];

                              event.discriptionfun =
                                  myList.docs[index]['EventDescription'];

                              event.dateofEventfun =
                                  myList.docs[index]['EventDate'];

                              event.idOfEventfun = myList.docs[index].id;

                              event.Clubfun = myList.docs[index]['Club'];

                              event.WriterNamefun = myList.docs[index]['Name'];

                              event.contactfun = myList.docs[index]['Contact'];
                              event.Clapsfun = myList.docs[index]['Claps'];
                              event.dateTime = myList.docs[index]['TimeStamp'];
                              event.instagramLinkFun =
                                  myList.docs[index]['Instagram'];
                              event.googleFormfun =
                                  myList.docs[index]['GoogleForm'];
                              event.EventImagefun = myList.docs[index]['Image'];
                              event.imageSizefun =
                                  myList.docs[index]['ImageSize'];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Eventdetails()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible: Admin,
                                        child: IconButton(
                                            splashRadius: 20,
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height: 60,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          ElevatedButton(
                                                              child: const Text(
                                                                  'Delete Post'),
                                                              onPressed:
                                                                  () async {
                                                                if (snapshot.data!.docs[index]
                                                                            [
                                                                            'UserId'] ==
                                                                        user
                                                                            .uid ||
                                                                    user.email ==
                                                                        'dailytechanalysiss@gmail.com') {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'Event')
                                                                      .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id)
                                                                      .delete();
                                                                  FirebaseStorage
                                                                      .instance
                                                                      .refFromURL(snapshot
                                                                          .data!
                                                                          .docs[index]['Image'])
                                                                      .delete();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                } else {
                                                                  final snackBar =
                                                                      SnackBar(
                                                                          content:
                                                                              Text("Sorry, you can't delete it"));
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          snackBar);
                                                                }
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.settings,
                                              size: 15,
                                            )),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundImage: NetworkImage(myList
                                                .docs[index]['AdminImage']),
                                          ),
                                          SizedBox(
                                            height: 35,
                                          ),
                                          Text(
                                            DateFormat('d EE yyyy')
                                                .format(myDateTime.toDate()),
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 60,
                                            child: Center(
                                              child: Text(
                                                myList.docs[index]
                                                        ['EventDescription'] ??
                                                    'Description',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            myList.docs[index]['Club'] ??
                                                'Club Name',
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      ClipRRect(
                                        child: Image.network(
                                          myList.docs[index]['Image'],
                                          height: 70.0,
                                          width: 110.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ShimmerWidget.Circular(width: 30, height: 30),
                  SizedBox(
                    height: 35,
                  ),
                  ShimmerWidget.rectanglar(width: 30, height: 10)
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 60,
                    child: Center(
                      child: Column(
                        children: [
                          ShimmerWidget.rectanglar(width: 150, height: 10),
                          SizedBox(
                            height: 1.5,
                          ),
                          ShimmerWidget.rectanglar(width: 150, height: 10),
                        ],
                      ),
                    ),
                  ),
                  ShimmerWidget.rectanglar(width: 50, height: 12),
                ],
              ),
              SizedBox(
                width: 4,
              ),
              ShimmerWidget.rectanglar(width: 110, height: 70),
              SizedBox(
                width: 1,
              ),
            ],
          )),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  //const ShimmerWidget({Key? key}) : super(key: key);

  final double width;
  final double height;

  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectanglar({
    required this.width,
    required this.height,
  }) : this.shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.Circular({
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.grey,
      baseColor: Colors.grey[300]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: Colors.grey,
        ),
      ),
    );
  }
}
