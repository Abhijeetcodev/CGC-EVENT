import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleClass{
  late String WriterName;
  late String Club;
  late String titleEvent;
  late String discriptionEvent;
  late Timestamp dateTime;
  late int Claps;
  late String _image;
  late String EventImage;
  late int imageSize;
 

  late String docId = '';
  String get WriterNamefun {
    return this.WriterName;
  }

  set WriterNamefun(String str) {
    this.WriterName = str;
  }

 
////////////////////////////////////////////////4
  String get titleEventfun {
    return this.titleEvent;
  }

  set titleEventfun(String str) {
    this.titleEvent = str;
  }

////////////////////////////////////////////////////5
  String get discriptionfun {
    return this.discriptionEvent;
  }

  set discriptionfun(String str) {
    this.discriptionEvent = str;
  }


/////////////////////////////////////////////////////7
  String get idOfEventfun {
    return this.docId;
  }

  set idOfEventfun(String str) {
    this.docId = str;
  }

//////////////////////////////////////////////////////`8
  String get Clubfun {
    return this.Club;
  }

  set Clubfun(String str) {
    this.Club = str;
  }

  Timestamp get dateTimefun {
    return this.dateTime;
  }

  set dateTimefun(Timestamp str) {
    this.dateTime = str;
  }

  int get Clapsfun {
    return this.Claps;
  }

  set Clapsfun(int c) {
    this.Claps = c;
  }

  String get imagefun {
    return this._image;
  }

  set imagefun(String image) {
    this._image = image;
  }
  
  String get EventImagefun {
    return this.EventImage;
  }

  set EventImagefun(String str) {
    this.EventImage = str;
  }

  
  int get imageSizefun{
    return this.Claps;
  }

  set imageSizefun(int c) {
    this.imageSize = c;
  }
}

