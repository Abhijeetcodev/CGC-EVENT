import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:cgc_event/Home/Operations/PostOperation.dart';


class AddImage extends StatefulWidget  {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage>  {
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  

  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() {
                    AddTodatabase();
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

 
  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          arr.add(value);
          i++;
        });
      });
    }
  }
  List<String> arr = [];
 Future AddTodatabase() async {
    final user = FirebaseAuth.instance.currentUser!;
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp

    DateTime myDateTime = myTimeStamp.toDate();

    final int Claps = 0;

    try {
      FirebaseFirestore.instance
          .collection("Post")
          .add({
            "Name": PostWriterInputController.text,
            "TimeStamp": myDateTime,
            "Claps": Claps,
            "AdminImage": user.photoURL!,
            "Images": FieldValue.arrayUnion(arr),
            "isLiked": false,
            "Msg": PostDiscriptionInputController.text,
            "UserId": user.uid,
          })
          .then((value) {})
          .catchError((onError) => print(onError));

      final snackBar = SnackBar(content: Text("Your Image  is uploaded! ✅ and Post is Live"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(e.toString());
    }
  }
 
  
}
