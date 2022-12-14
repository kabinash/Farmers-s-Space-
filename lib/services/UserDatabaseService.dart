import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/User.dart';
import '../models/Product.dart';
import '../models/Calender.dart';
import '../models/CropField.dart';
import 'package:AgroAcres/models/Rent.dart';

class UserDatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<User> streamUser(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snapshot) => User.fromFirestore(snapshot));
  }

  Future<User> getUser(String id) async {
    DocumentSnapshot snapshot =
        await _db.collection('users').document(id).get();
    return User.fromFirestore(snapshot);
  }

  Stream<Product> streamProduct(String id) {
    return _db
        .collection('products')
        .document(id)
        .snapshots()
        .map((snapshot) => Product.fromFirestore(snapshot));
  }

  ///////////////////////////////////////

  Stream<Rent> streamRent(String id) {
    return _db
        .collection('rent')
        .document(id)
        .snapshots()
        .map((snapshot) => Rent.fromFirestore(snapshot));
  }

  ////////////////////////////////////////////////////////

  Future<Product> getProduct(String id) async {
    DocumentSnapshot snapshot =
        await _db.collection('products').document(id).get();
    return Product.fromFirestore(snapshot);
  }

  //////////////////////////////////////////////////////
  Future<Rent> getRent(String id) async {
    DocumentSnapshot snapshot =
    await _db.collection('rent').document(id).get();
    return Rent.fromFirestore(snapshot);
  }

  ///////////////////////////////////////////////////




  Stream<CropField> streamCropField(String id) {
    return _db
        .collection('cropfields')
        .document(id)
        .snapshots()
        .map((snapshot) => CropField.fromFirestore(snapshot));
  }

  Future<CropField> getCropField(String id) async {
    DocumentSnapshot snapshot =
        await _db.collection('cropfields').document(id).get();
    return CropField.fromFirestore(snapshot);
  }

  Stream<Calender> streamCalender(String id) {
    return _db
        .collection('cropData')
        .document(id)
        .snapshots()
        .map((snapshot) => Calender.fromFirestore(snapshot));
  }
}
