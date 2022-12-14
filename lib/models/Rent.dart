import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Rent {

  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;
  //final String quanityName;
  final String phoneNumber;
  final Position position;

  const Rent({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.imageUrl,
    @required this.quantity,
  //  @required this.quanityName,
    @required this.phoneNumber,
    @required this.position,
  });

  factory Rent.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    if (data == null) {
      return null;
    }
    Rent rent = Rent(
      id: snapshot.documentID,
      title: data['title'] ?? null,
      price: data['price'] ?? null,
      imageUrl: data['imageUrl'] ?? null,
      quantity: data['quantity'] ?? null,
     // quanityName: data['quantityName'] ?? null,
      phoneNumber: data['phoneNumber'] ?? null,
      position: Position(latitude: data['position'].latitude, longitude: data['position'].longitude) ?? null,
    );
    return rent;
  }
}