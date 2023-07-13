import 'package:cgc_event/Article/Screens/ArticleCardScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class Articledetails extends StatefulWidget {
  const Articledetails({Key? key}) : super(key: key);

  @override
  State<Articledetails> createState() => _ArticledetailsState();
}


var boxFit = [
  BoxFit.contain,
  BoxFit.cover,
  BoxFit.fill,
  BoxFit.fitHeight,
  BoxFit.fitWidth,
];

class _ArticledetailsState extends State<Articledetails> {

  
  @override
  Widget build(BuildContext context) {
    Timestamp myDateTime = article.dateTimefun;
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
                .collection("Article")
                .doc(article.idOfEventfun)
                .update({
              'Claps': article.Clapsfun,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            
                            Expanded(
                              
                              child: Container(
                                width: double.infinity,
                                child: Text(
   
                                  article.titleEventfun,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 6,
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
                                  backgroundImage: NetworkImage(article.imagefun),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(article.WriterNamefun),
                                    Text(
                                      DateFormat('d EE yyyy').format(
                                        myDateTime.toDate(),
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
                                  article.Clubfun,
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
                                  fit: boxFit[article.imageSizefun],
                                  image: NetworkImage(
                                   article.EventImagefun,
                                  ),
                                ),
                              ),),
                              SizedBox(height: 10,),

                        Text(
                          article.discriptionfun,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                          maxLines: 100,
                        ),
                        SizedBox(
                          height: 5,
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
                                        article.Claps++;
                                       
                                      });
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.handHoldingHeart,
                                      color: Colors.redAccent,
                                    )),
                                Text(article.Claps.toString() + ' Hearts'),
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
              Text('Link not provided or not working'),
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
