import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cgc_event/Home/Operations/AddImage.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cgc_event/main.dart';

class PostCardView extends StatefulWidget {
  PostCardView({Key? key}) : super(key: key);

  @override
  _PostCardViewState createState() => _PostCardViewState();
}

class _PostCardViewState extends State<PostCardView> {
  final ScrollController _scrollController = ScrollController();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Post')
      .orderBy('TimeStamp', descending: true)
      .snapshots();
 
  bool isLoading = true;

  @override
  void initState() {
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
    bool expansionClicked = false;
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
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

          var myList = snapshot.data as QuerySnapshot;
          final user = FirebaseAuth.instance.currentUser!;

          return Scaffold(
            backgroundColor: Colors.white,
            body: ListView.builder(
                addSemanticIndexes: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: myList.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  Timestamp myDateTime = (myList.docs[index]['TimeStamp']);
                  int Clap = myList.docs[index]['Claps'];

                  if (isLoading) {
                    return buildShimmer(context);
                  } else {
                    return Card(
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                              myList.docs[index]['AdminImage']),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(myList.docs[index]['Name']),
                                      ],
                                    ),
                                    Visibility(
                                      visible: Admin,
                                      child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
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
                                                          onPressed: () async {
                                                            if (myList.docs[index]
                                                                        [
                                                                        'UserId'] ==
                                                                    user.uid ||
                                                                user.email ==
                                                                    'dailytechanalysiss@gmail.com') {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Post')
                                                                  .doc(myList
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .delete();

                                                              for (int i = 0;
                                                                  i <
                                                                      myList
                                                                          .docs[
                                                                              index]
                                                                              [
                                                                              'Images']
                                                                          .length;
                                                                  i++) {
                                                                FirebaseStorage
                                                                    .instance
                                                                    .refFromURL(
                                                                        myList.docs[index]
                                                                            [
                                                                            'Images'][i])
                                                                    .delete();
                                                              }

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } else {
                                                              final snackBar = SnackBar(
                                                                  content: Text(
                                                                      "Sorry, you can't delete it"));
                                                              ScaffoldMessenger
                                                                      .of(
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
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 300,
                              width: (MediaQuery.of(context).size.width),
                              child: Scrollbar(
                                isAlwaysShown: true,
                                controller: ScrollController(),
                                child: ListView.builder(
                                    addSemanticIndexes: true,
                                    scrollDirection: Axis.horizontal,
                                    controller: ScrollController(),
                                    shrinkWrap: true,
                                    itemCount:
                                        myList.docs[index]['Images'].length,
                                    itemBuilder:
                                        (BuildContext context, int indexs) {
                                      return Container(
                                        width: 350,
                                        child: Image.network(
                                          myList.docs[index]['Images'][indexs],
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              Clap++;
                                            });
                                            FirebaseFirestore.instance
                                                .collection("Post")
                                                .doc(myList.docs[index].id)
                                                .update({
                                              'Claps': Clap,
                                            });
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: Colors.redAccent,
                                          )),
                                      Text(Clap.toString() + ' Hearts'),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        DateFormat('d EE yyyy')
                                            .format(myDateTime.toDate()),
                                        style: TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await Share.share(
                                            'Download CGC Event App https://play.google.com/store/apps/details?id=com.developerAbhijeet.cgcevent');
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.share,
                                        size: 16,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            (myList.docs[index]['Msg'].toString().length != 0)
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ExpandableText(
                                      myList.docs[index]['Msg'],
                                      expandText: 'show more',
                                      collapseText: 'show less',
                                      maxLines: 2,
                                      linkColor: Colors.blue,
                                      animation: true,
                                      collapseOnTextTap: true,
                                    ),
                                  )
                                : const SizedBox(
                                    height: 2,
                                  ),
                            //buildCard(myList.docs[index]['Message'],context),
                          ],
                        ));
                  }
                }),
          );
        });
  }

  @override
  Widget buildShimmer(BuildContext context) {
    return Card(
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShimmerWidget.Circular(width: 35, height: 35),
                        SizedBox(
                          width: 10,
                        ),
                        ShimmerWidget.rectanglar(
                          height: 20,
                          width: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                height: 300,
                width: double.infinity,
                child: ShimmerWidget.rectanglar(
                  height: 300,
                  width: 300,
                )),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerWidget.rectanglar(
                        height: 10,
                        width: 30,
                      ),
                      ShimmerWidget.rectanglar(
                        height: 10,
                        width: 30,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      ShimmerWidget.rectanglar(
                        height: 20,
                        width: 30,
                      )
                    ],
                  ),
                  ShimmerWidget.rectanglar(
                    height: 10,
                    width: 20,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ShimmerWidget.rectanglar(
              height: 20,
              width: 300,
            ),
            SizedBox(height: 20),
          ],
        ));
  }
}

class PostDropDown extends StatefulWidget {
  PostDropDown({Key? key}) : super(key: key);

  @override
  _PostDropDownState createState() => _PostDropDownState();
}

class _PostDropDownState extends State<PostDropDown> {
  String? dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.menu_open),
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
            case 'Delete':
              dropdownValue = '';
              break;
          }
        });
      },
      items: <String>[
        '',
        'Delete',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

var Number = 0;

var boxFit = [
  BoxFit.contain,
  BoxFit.cover,
  BoxFit.fill,
  BoxFit.fitHeight,
  BoxFit.fitWidth,
];

class ImageOperations extends StatefulWidget {
  const ImageOperations({Key? key}) : super(key: key);

  @override
  _ImageOperationsState createState() => _ImageOperationsState();
}

late TextEditingController PostWriterInputController;
late TextEditingController PostDiscriptionInputController;

class _ImageOperationsState extends State<ImageOperations> {
  final user = FirebaseAuth.instance.currentUser!;

  void initState() {
    super.initState();
    PostWriterInputController = TextEditingController();
    PostDiscriptionInputController = TextEditingController();
  }

  File? image;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: PostWriterInputController,
                  autofocus: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                    labelText: "Your Name*",
                    border: OutlineInputBorder(),
                    hintText: 'Enter The Your Name',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  height: 500,
                  width: 500,
                  child: TextField(
                    maxLines: 25,
                    maxLength: 1000,
                    controller: PostDiscriptionInputController,
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
                ElevatedButton.icon(
                    onPressed: () async {
                      if (PostWriterInputController.text.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddImage()));
                      } else {
                        final snackBar = SnackBar(content: Text("Name Needed"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: Icon(FontAwesomeIcons.arrowRight),
                    label: Text("Add Image"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class No_Internet extends StatelessWidget {
  const No_Internet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child: Text(
                'No internet Connection',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),
              ),
            ),
          ),
          TextButton.icon(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text("Exit"))
        ],
      ),
    );
  }
}
