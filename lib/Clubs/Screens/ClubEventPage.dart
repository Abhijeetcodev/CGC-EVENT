import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cgc_event/Events/EventClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cgc_event/Events/Screens/EventArticlePage.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cgc_event/Home/Operations/PostOperation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cgc_event/Article/ArticleClass.dart';
import 'package:cgc_event/Article/Screens/ArticleScreen.dart';
import 'package:cgc_event/main.dart';

EventClass event = EventClass();

var VariousClubAsset = [
  'Assets/images/TechAmigos.jpeg',
  'Assets/images/Prayas.jpeg',
  'Assets/images/Artistia.jpeg',
  'Assets/images/Champians.jpeg',
  'Assets/images/FlamingDesire.jpeg',
  'Assets/images/Pixel.jpeg',
  'Assets/images/Virast.jpeg',
  'Assets/images/RangManch.jpeg',
];
var VariousClubLogo = [
  'Assets/images/TechAmigoslogo.jpeg',
  'Assets/images/prayaslogo .png',
  'Assets/images/Artistialogo.jpeg',
  'Assets/images/Champianslogo.jpeg',
  'Assets/images/FlamingDesirelogo.jpeg',
  'Assets/images/Pixellogo.jpeg',
  'Assets/images/Virastlogo.jpeg',
  'Assets/images/RangManchlogo.jpeg',
];
var ClubNames = [
  'TECH AMIGOS',
  'PRAYAS',
  'Artistia',
  'Champions',
  'Flaming Desire',
  'Pixel',
  'Virasat',
  'RangManch',
];
int CurrentIndexofClub = 0;

class ClubPageScreen extends StatefulWidget {
  ClubPageScreen({Key? key}) : super(key: key);

  @override
  _ClubPageScreenState createState() => _ClubPageScreenState();
}

class _ClubPageScreenState extends State<ClubPageScreen> {
  //int CurrentIndexofClub = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AlignedGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    CurrentIndexofClub = index;

                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClubInfoPage()));
                  },
                  child: GridTile(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            VariousClubLogo[index],
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                ),
              );
            }));

    //    StaggeredGridView.countBuilder(
    //       staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
    //       crossAxisCount: 2,
    //       crossAxisSpacing: 1.0,
    //       mainAxisSpacing: 1.0,
    //       itemCount: VariousClubAsset.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: InkWell(
    //             onTap: () {
    //               CurrentIndexofClub = index;

    //               setState(() {});
    //               Navigator.push(context,
    //                   MaterialPageRoute(builder: (context) => ClubInfoPage()));
    //             },
    //             child: GridTile(
    //               child:Card(
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10.0),
    //                 ),
    //                 elevation: 5,
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.circular(10.0),
    //                   child: Image.asset(
    //                     VariousClubLogo[index],
    //                     fit: BoxFit.fill,
    //                   ),
    //                 )),
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }
}

class ClubInfoPage extends StatefulWidget {
  const ClubInfoPage({Key? key}) : super(key: key);

  @override
  State<ClubInfoPage> createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            ClubNames[CurrentIndexofClub],
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            iconSize: 30,
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            indicatorColor: Colors.grey,
            indicatorWeight: 5,
            labelColor: Colors.grey.shade500,
            tabs: [
              Tab(
                text: 'Home',
              ),
              Tab(
                text: 'Event',
              ),
              Tab(
                text: 'Article',
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          ClubHome(),
          ClubEvent(),
          ClubArticle(),
        ]),
      ),
    );
  }
}

class ClubHome extends StatefulWidget {
  ClubHome({Key? key}) : super(key: key);

  @override
  _ClubHomeState createState() => _ClubHomeState();
}

class _ClubHomeState extends State<ClubHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400,
          width: 350,
          child: Image.asset(VariousClubAsset[CurrentIndexofClub]),
        ),
      ),
    );
  }
}

class ClubEvent extends StatefulWidget {
  const ClubEvent({Key? key}) : super(key: key);

  @override
  _ClubEventState createState() => _ClubEventState();
}

class _ClubEventState extends State<ClubEvent> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Event')
      .where('Club', isEqualTo: '${ClubNames[CurrentIndexofClub]}')
      .orderBy('TimeStamp', descending: true)
      .snapshots();

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    ConnectionCheck();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1), () {});
    setState(() {
      isLoading = false;
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
        }

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
                      if (myList.docs.length == 0) {
                        final snackBar = SnackBar(
                            content: Text(
                          "No event",
                          style: TextStyle(color: Colors.red),
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (isLoading) {
                        return buildShimmer(context);
                      } else {
                        event.dateTime = myList.docs[index]['TimeStamp'];
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

ArticleClass article = ArticleClass();

class ClubArticle extends StatefulWidget {
  const ClubArticle({Key? key}) : super(key: key);

  @override
  _ClubArticleState createState() => _ClubArticleState();
}

class _ClubArticleState extends State<ClubArticle> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Article')
      .where('Club', isEqualTo: '${ClubNames[CurrentIndexofClub]}')
      .orderBy('TimeStamp', descending: true)
      .snapshots();

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    ConnectionCheck();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1), () {});
    setState(() {
      isLoading = false;
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
        }

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return buildShimmer(context);
        // }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Timestamp myDateTime =
                          (snapshot.data!.docs[index]['TimeStamp']);
                      final user = FirebaseAuth.instance.currentUser!;
                      if (snapshot.data!.docs.length == 0) {
                        final snackBar = SnackBar(content: Text("No Article"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      if (isLoading) {
                        return buildShimmer(context);
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: InkWell(
                            onTap: () {
                              article.imagefun =
                                  snapshot.data!.docs[index]['AdminImage'];
                              article.titleEventfun =
                                  snapshot.data!.docs[index]['EventName'];

                              article.discriptionfun = snapshot
                                  .data!.docs[index]['EventDescription'];

                              article.idOfEventfun =
                                  snapshot.data!.docs[index].id;

                              article.Clubfun =
                                  snapshot.data!.docs[index]['Club'];

                              article.WriterNamefun =
                                  snapshot.data!.docs[index]['Name'];

                              article.Clapsfun =
                                  snapshot.data!.docs[index]['Claps'];
                              article.dateTime =
                                  snapshot.data!.docs[index]['TimeStamp'];

                              article.EventImagefun =
                                  snapshot.data!.docs[index]['Image'];
                              article.imageSizefun =
                                  snapshot.data!.docs[index]['ImageSize'];

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Articledetails()),
                              );
                            },
                            child: Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        snapshot.data!.docs[index]['Image'],
                                        height: 180.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 8, 8, 0.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                                ['EventName'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                height: 1.2,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                ['EventDescription'],
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 10,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index]
                                                      ['AdminImage']),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              DateFormat('d EE yyyy')
                                                  .format(myDateTime.toDate()),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['Club'],
                                        ),
                                        Visibility(
                                          visible: Admin,
                                          child: IconButton(
                                              splashRadius: 25,
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
                                                                            'Article')
                                                                        .doc(snapshot
                                                                            .data!
                                                                            .docs[index]
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
                                        )
                                      ],
                                    ),
                                  ],
                                )),
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
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: InkWell(
        onTap: () {},
        child: Card(
            elevation: 10,
            child: Column(
              children: [
                ShimmerWidget.rectanglar(width: double.infinity, height: 180),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ShimmerWidget.rectanglar(width: 300, height: 20),
                      SizedBox(
                        height: 2,
                      ),
                      ShimmerWidget.rectanglar(width: 300, height: 20),
                      SizedBox(
                        height: 2,
                      ),
                      ShimmerWidget.rectanglar(width: 300, height: 20),
                      SizedBox(
                        height: 5,
                      ),
                      ShimmerWidget.rectanglar(width: 300, height: 10),
                      SizedBox(
                        height: 1,
                      ),
                      ShimmerWidget.rectanglar(width: 300, height: 10),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShimmerWidget.Circular(width: 20, height: 20),
                          SizedBox(
                            width: 5,
                          ),
                          ShimmerWidget.rectanglar(width: 20, height: 10),
                        ],
                      ),
                      ShimmerWidget.rectanglar(width: 20, height: 10),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
