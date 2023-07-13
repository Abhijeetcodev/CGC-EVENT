import 'package:cgc_event/Article/Operations/Article_add.dart';
import 'package:cgc_event/Events/EventOperatins/EventAdd.dart';
import 'package:flutter/material.dart';
import 'package:cgc_event/Clubs/Screens/ClubEventPage.dart';
import 'package:cgc_event/Article/Screens/ArticleCardScreen.dart';
import 'package:cgc_event/Events/Screens/EventPageScreen.dart';
import 'package:cgc_event/Home/Operations/PostOperation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cgc_event/Profile/Screens/ProfilePageScreen.dart';
i
import 'package:cgc_event/main.dart';
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final screens = [
    HomePageScreen(),
    const EventPageScreen(),
    const ArticleCardView(),
    ClubPageScreen(),
    ProfilePageScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String? _userImage =
        'https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805_1280.png';
    if (user != null) {
      _userImage = user.photoURL;
    }

    return Scaffold(
      body: screens[index],
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Assets/images/eventlogo.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        title: Text(
          "CGC EVENT",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 10,
        actions: [
          Visibility(
            visible: Admin,
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                 
                                 Center(
                                   child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ImageOperations()));
                                        },
                                        label:  Text('Post  '),
                                        icon: Icon(Icons.post_add_rounded)),
                                 )
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                
                                  ElevatedButton.icon(
                                    label:  Text('Story ') ,
                                      onPressed: () {},
                                      icon: Icon(Icons.smart_toy_rounded)),
                                         SizedBox(width: 5,),
                                        Text('Coming Soon '),
                                 
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArticleAdd()));
                                      },
                                      label:   Text('Article'),
                                      icon: Icon(Icons.article_rounded))
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
                                 
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddEvent()));
                                       // Navigator.of(context).pop();
                                      },
                                      label:  Text('Event '),
                                      icon: Icon(
                                        Icons.event,
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.black,
                )),
          ),
          // MyStatefulWidget(),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 12, fontWeight: FontWeight.w400))),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 60,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          selectedIndex: index,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              selectedIcon: Icon(Icons.home_filled),
            ),
            NavigationDestination(
              icon: Icon(Icons.event_note_outlined),
              label: 'Event',
              selectedIcon: Icon(Icons.event_note_rounded),
            ),
            NavigationDestination(
              icon: Icon(Icons.article_outlined),
              label: 'Article',
              selectedIcon: Icon(Icons.article_rounded),
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              label: 'Clubs',
              selectedIcon: Icon(Icons.info_rounded),
            ),
            NavigationDestination(
                icon: CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(_userImage!),
                ),
                label: 'Profile')
          ],
        ),
      ),
    );
  }
}

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PostCardView(),
    );
  }
}
