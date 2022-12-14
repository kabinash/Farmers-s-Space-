import 'dart:io';
import 'package:AgroAcres/screens/SettingsScreen/local_widgets/UnitsDropdownField.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/Product.dart';
import 'package:AgroAcres/models/Rent.dart';
import '../widgets/ImageInput.dart';
import '../services/ShopProvider.dart';
import '../widgets/CustomDarkButton.dart';
import '../widgets/CustomTextField.dart';
import '../widgets/Locationinput.dart';
import '../services/LocalizationProvider.dart';


class AddRent extends StatefulWidget {
  final String rentId;

  const AddRent({this.rentId});

  @override
  _AddRent createState() => _AddRent();
}

class _AddRent extends State<AddRent> {
  final _db = Firestore.instance;

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _quantityNameController = TextEditingController();

  Position _position;
  File imageFile;
  String imageUrl = "";

  @override
  void initState() {
    if (widget.rentId != null) {
      fetchExistingValues();
    }
    super.initState();
  }

  void setUnitName(String crop) {
    _quantityNameController.text = crop;
  }

  void selectPlace(double lat, double long) {
    _position = Position(latitude: lat, longitude: long);
  }

  void selectImage(File image) async {
    setState(() {
      imageFile = image;
    });
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('rent/${Path.basename(image.path)}}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    await uploadTask.onComplete;
    firebaseStorageRef.getDownloadURL().then((fileUrl) {
      imageUrl = fileUrl;
    });
  }

  void fetchExistingValues() async {
    DocumentSnapshot doc =
    await _db.collection('rent').document(widget.rentId).get();
    Rent rent = Rent.fromFirestore(doc);
    setState(() {
      _titleController.text = rent.title;
      _priceController.text = rent.price.toString();
      _quantityController.text = rent.quantity.toString();
   //   _quantityNameController.text = rent.quanityName;
      imageUrl = rent.imageUrl;
      _position = rent.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<LocalizationProvider>(context).getCurrentLanguage() == 'en';

    return Scaffold(
      appBar: appBar(
        context,
        widget.rentId == null
            ? (isEnglish ? 'Add Product' : '?????????????????? ??????????????????')
            : (isEnglish ? 'Edit Product' : '?????????????????? ????????????????????? ????????????'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            CustomTextField(
              controller: _titleController,
              icon: FontAwesomeIcons.boxTissue,
              labelText: isEnglish ? 'Name of Product' : '?????????????????? ?????? ?????????',
            ),
            ImageInput(
              selectImage,
              imageUrl: imageUrl,
              isEnglish: isEnglish,
            ),
            LocationInput(
              selectPlace,
              position: _position,
              isEnglish: isEnglish,
            ),
            CustomTextField(
              controller: _priceController,
              icon: FontAwesomeIcons.rupeeSign,
              labelText: isEnglish ? 'Price per day' : '??????????????? ??????????????? ????????????',
              numeric: true,
            ),
            CustomTextField(
              controller: _quantityController,
              icon: FontAwesomeIcons.sortNumericUp,
              labelText: isEnglish ? 'Quantity' : '??????????????????',
              numeric: true,
            ),
            UnitsDropdownField(
                setUnitName, isEnglish ? 'Unit of Quantity' : '?????????????????? ?????? ????????????'),
            SizedBox(height: 20),
            customDarkButton(
              text: isEnglish ? 'CONFIRM' : '?????????????????? ????????????',
              icon: FontAwesomeIcons.checkCircle,
              onPress: widget.rentId == null
                  ? () => ShopProvider.addProduct(
                context,
                title: _titleController.text,
                price: _priceController.text,
                quantity: _quantityController.text,
                quantityName: _quantityNameController.text,
                imageUrl: imageUrl,
                position: _position,
              )
                  : () => ShopProvider.editProduct(
                context,
                widget.rentId,
                title: _titleController.text,
                price: _priceController.text,
                quantity: _quantityController.text,
                quantityName: _quantityNameController.text,
                imageUrl: imageUrl,
                position: _position,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context, String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 22,
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black.withOpacity(0.8),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
