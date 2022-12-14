import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Product.dart';
import '../widgets/ProductCard.dart';
import '../widgets/LoadingSpinner.dart';
import '../services/LocalizationProvider.dart';

class ProductsListScreen extends StatelessWidget {
  final bool updating;

  ProductsListScreen(this.updating);

  final _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    bool isEnglish =
        Provider.of<LocalizationProvider>(context).getCurrentLanguage() == 'en';

    return user == null
        ? loadingSpinner()
        : StreamBuilder<QuerySnapshot>(
            stream: updating
                ? _db
                    .collection('products')
                    .where('userId', isEqualTo: user.uid)
                    .snapshots()
                : _db.collection('products').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingSpinner();
              }
              if (!snapshot.hasData) {
                return Container();
              }
              final docs = snapshot.data.documents;
              final List<Product> products = [];
              docs.forEach((doc) => products.add(Product.fromFirestore(doc)));
              if (products.isEmpty) {
                return Center(
                  child: Text(
                    updating
                        ? (isEnglish
                            ? 'Add a Product Now!'
                            : 'अब एक उत्पाद जोड़ें')
                        : (isEnglish
                            ? 'No Products Available'
                            : 'कोई उत्पाद उपलब्ध नहीं है'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 24,
                      fontFamily: 'Lato',
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(0),
                itemBuilder: (ctx, index) =>
                    ProductCard(products[index], isEnglish, updating: updating),
                itemCount: products.length,
              );
            });
  }
}
