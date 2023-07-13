import 'package:cgc_event/Article/ArticleClass.dart';
import 'package:cgc_event/Article/Screens/ArticleScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cgc_event/Home/Operations/PostOperation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cgc_event/main.dart';

ArticleClass article = ArticleClass();

class ArticleCardView extends StatefulWidget {
  const ArticleCardView({Key? key}) : super(key: key);

  @override
  _ArticleCardViewState createState() => _ArticleCardViewState();
}

class _ArticleCardViewState extends State<ArticleCardView> {
  bool isDescending = false;
  static String field = 'ACM';

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Article')
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
          context, MaterialPageRoute(builder: (context) =>  No_Internet()));
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
                                      padding: const EdgeInsets.fromLTRB(8, 8, 8,1.0),
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
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
                                                DateFormat('d EE yyyy').format(
                                                    myDateTime.toDate()),
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
