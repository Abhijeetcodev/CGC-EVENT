import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Home/Screens/homepage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

bool Admin = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'CGC EVENT',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
        ),
      );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      bool connection = await InternetConnectionChecker().hasConnection;
      if (connection) {
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
          var AdminAccount = [
            'sjha09909@gmail.com',
            'dailytechanalysiss@gmail.com',
            'abhijeetsinghdeve@gmail.com',
            //'2002803.it.cec@cgc.edu.in',
            'dswtechamigos@cgc.edu.in',
            'jabhinandan1320@gmail.com',
            'Dswflamingdesireclub@cgc.edu.in',
'Dswrangmanchclub@cgc.edu.in',
'Dswchampionclub@cgc.edu.in',
'Dswvirasatclub@cgc.edu.in' ,
'Dswtechamigos@cgc.edu.in ',
'Dswprayasclub@cgc.edu.in',
'Dswpixelclub@cgc.edu.in',
'Dswartistiaclub@cgc.edu.in',
          ];
          if (user != null) {
            for (int i = 0; i < AdminAccount.length; i++) {
              if (user.email == AdminAccount[i]) {
                Admin = true;
              }
            }
           
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          }
        });
      } else {
        final snackBar = SnackBar(content: Text("No Internet"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => No_Network()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Assets/images/eventlogo.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

bool userSignIn = false;

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),

    //IconFaIcon(FontAwesomeIcons.google),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/images/Loginimage.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(children: [
          Positioned(
            top: 220,
            left: 25,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "WELCOME",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 2.0),
                  child: Row(
                    children: [
                      const Text(
                        "CGCIANS",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset('Assets/images/wave_hand.png',
                          width: 40, height: 40, fit: BoxFit.fill),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 220,
            left: 110,
            child: ElevatedButton.icon(
              onPressed: () {
                signup(context);
              },
              style: OutlinedButton.styleFrom(
                  shadowColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.black),
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.redAccent),
              label: Text(
                "Sign In With Google",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
Future<void> signup(BuildContext context) async {
  var AdminAccount = [
    'sjha09909@gmail.com',
    'dailytechanalysiss@gmail.com',
    'abhijeetsinghdeve@gmail.com',
    //'2002803.it.cec@cgc.edu.in',
    'dswtechamigos@cgc.edu.in',
    'jabhinandan1320@gmail.com',
    'Dswflamingdesireclub@cgc.edu.in',
'Dswrangmanchclub@cgc.edu.in',
'Dswchampionclub@cgc.edu.in',
'Dswvirasatclub@cgc.edu.in' ,
'Dswtechamigos@cgc.edu.in ',
'Dswprayasclub@cgc.edu.in',
'Dswpixelclub@cgc.edu.in',
'Dswartistiaclub@cgc.edu.in',

  ];
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    userSignIn = true;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Getting users credential
    UserCredential result = await auth.signInWithCredential(authCredential);
    //User user? = result.user ;

    if (result != null) {
      for (int i = 0; i < AdminAccount.length; i++) {
        if (googleSignIn.currentUser?.email == AdminAccount[i]) {
          Admin = true;
        }
      }
      if (Admin) {
        final snackBar = SnackBar(
            content: Center(
          child: Text(
            "ADMIN LOGIN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        final snackBar = SnackBar(content: Text("Succesfully Logged In"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } // if result not null we simply call the MaterialpageRoute,
    // for go to the HomePage screen
  } else {
    if (googleSignInAccount != null) {
      googleSignIn.signOut();
      final snackBar = SnackBar(
          content: Text("Sorry, Only College Registered Ids Are Allowed"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

//Function to logout

Future<void> signOutMethod() async {
  await auth.signOut();
  await googleSignIn.signOut();
}

class GoogleSignInButtonWidget extends StatelessWidget {
  const GoogleSignInButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: OutlinedButton.icon(
        label: Text(
          'Sign In With Google',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
        icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
        onPressed: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogin();
        },
      ),
    );
  }
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user {
    return _user!;
  }

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    _user = googleUser;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    void initState() {
      userSignIn = true;
    }

    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }
}
//<div>Icons made by <a href="https://www.flaticon.com/authors/tru3-art" title="Tru3 Art">Tru3 Art</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

class No_Network extends StatelessWidget {
  const No_Network({Key? key}) : super(key: key);

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
