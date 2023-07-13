import 'package:cloud_firestore/cloud_firestore.dart';

class EventClass {
  String? WriterName;
  String? contact;
  String? VenueAndTime;
  String? Club;
  String? titleEvent;
  String? discriptionEvent;
  String? dateofEvent;
 
  Timestamp? dateTime;
  late int Claps;
  String? _image;
  String? googleform;
  String? instagramlink;
  String? EventImage;
  int? imageSize;

  late String docId = '';
////////////////////////////////// 1
  String? get WriterNamefun {
    return this.WriterName;
  }

  set WriterNamefun(String? str) {
    this.WriterName = str;
  }

  ////////////////////////////2
  String? get contactfun {
    return this.contact;
  }

  set contactfun(String? num) {
    this.contact = num;
  }

///////////////////////////////////3

  String? get VenueAndTimefun {
    return this.VenueAndTime;
  }

  set VenueAndTimefun(String? str) {
    this.VenueAndTime = str;
  }

////////////////////////////////////////////////4
  String? get titleEventfun {
    return this.titleEvent;
  }

  set titleEventfun(String? str) {
    this.titleEvent = str;
  }

////////////////////////////////////////////////////5
  String? get discriptionfun {
    return this.discriptionEvent;
  }

  set discriptionfun(String? str) {
    this.discriptionEvent = str;
  }

/////////////////////////////////////////////////////6
  String? get dateofEventfun {
    return this.dateofEvent;
  }

  set dateofEventfun(String? str) {
    this.dateofEvent = str;
  }

/////////////////////////////////////////////////////7
  String get idOfEventfun {
    return this.docId;
  }

  set idOfEventfun(String str) {
    this.docId = str;
  }

//////////////////////////////////////////////////////`8
  String? get Clubfun {
    return this.Club;
  }

  set Clubfun(String? str) {
    this.Club = str;
  }

///////////////////////////////////////////////////////


  Timestamp? get dateTimefun {
    return this.dateTime;
  }

  set dateTimefun(Timestamp? str) {
    this.dateTime = str;
  }

  int get Clapsfun {
    return this.Claps;
  }

  set Clapsfun(int c) {
    this.Claps = c;
  }

  String? get imagefun {
    return this._image;
  }

  set imagefun(String? image) {
    this._image = image;
  }

  String? get googleFormfun {
    return this.googleform;
  }

  set googleFormfun(String? str) {
    this.googleform = str;
  }

  String? get instagramLinkFun {
    return this.instagramlink;
  }

  set instagramLinkFun(String? str) {
    this.instagramlink = str;
  }

  String? get EventImagefun {
    return this.EventImage;
  }

  set EventImagefun(String? str) {
    this.EventImage = str;
  }

  
  int? get imageSizefun{
    return this.Claps;
  }

  set imageSizefun(int? c) {
    this.imageSize = c;
  }
}
