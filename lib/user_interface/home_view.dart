import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/net/api_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;
  double bitcoinPrice = 0.0;
  double ethereumPrice = 0.0;
  double tetherPrice = 0.0;

  @override
  void initState() {
    getValues();
    getPriceValues();
  }

  getValues() async {
    bitcoin = await getPrice("bitcoin");
    ethereum = await getPrice("ethereum");
    tether = await getPrice("tether");
    setState(() {});
  }

  getPriceValues() async {
    bitcoinPrice = await getPriceChange("bitcoin");
    ethereumPrice = await getPriceChange("ethereum");
    tetherPrice = await getPriceChange("tether");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //this is terrible..... for scalability
    var currentPrice = 1.0;
    getValue(String id, double amount) {
      if (id == "bitcoin") {
        return bitcoin * amount;
      } else if (id == "ethereum") {
        return ethereum * amount;
      } else {
        return tether * amount;
      }
    }

    getPriceValue(String id) {
      if (id == "bitcoin") {
        return bitcoinPrice;
      } else if (id == "ethereum") {
        return ethereumPrice;
      } else {
        return tetherPrice;
      }
    }

    getCurrentPrice(String id) {
      if (id == "bitcoin") {
        return bitcoin * 1;
      } else if (id == "ethereum") {
        return ethereum * 1;
      } else {
        return tether * 1;
      }
    }

    getIcon(String icon) {
      if (icon == "bitcoin") {
        return "btc";
      } else if (icon == "ethereum") {
        return "eth";
      } else {
        return "usdt";
      }
    }

    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          color: Colors.grey.shade800,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth
                    .instance.currentUser!.uid) //! = added null check
                .collection('Coins')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 6.0),
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: Offset(2.5, 3.5), // changes position of shadow
                          ),
                        ],
                        gradient: new LinearGradient(
                            colors: [
                              Colors.orange.shade900,
                              Colors.pink.shade900,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            tileMode: TileMode.clamp)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                    "https://cryptoicons.org/api/color/${getIcon(document.id)}/600"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Coin: ${document.id}",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              // "current price \€${getValue(document.id, document['Amount'].toDouble()).toStringAsFixed(2)}",
                              "Price \€${getCurrentPrice(document.id)}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Balance \€${getValue(document.id, document['Amount'].toDouble()).toStringAsFixed(2)}",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "24h: ${getPriceValue(document.id).toDouble().toStringAsFixed(2)} %",
                              style: getPriceValue(document.id) < 0
                                  ? TextStyle(color: Colors.red)
                                  : TextStyle(color: Colors.green),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
