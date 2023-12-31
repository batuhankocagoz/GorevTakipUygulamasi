import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorevtakipapp/screens/gorevekle.dart';
import 'package:gorevtakipapp/screens/kayitformu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String? mevcutkullaniciUidTutucu;

  @override
  void initState() {
    // TODO: implement initState
    mevcutkullaniciUidsiAl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Görev Listesi"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(top: 20.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Gorevler")
                .doc(mevcutkullaniciUidTutucu)
                .collection("Gorevlerim")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> veriTabanindanGelenVeriler) {
              if (veriTabanindanGelenVeriler.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final alinanVeri = veriTabanindanGelenVeriler.data!.docs;
                return ListView.builder(
                    itemCount:  veriTabanindanGelenVeriler.data!.docs.length,
                    itemBuilder: (context, index) {
                      var eklemeZamani =
                      (alinanVeri[index]["tamZaman"] as Timestamp).toDate();
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 3),
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        alinanVeri[index]["ad"],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      DateFormat.yMd()
                                          .add_jm()
                                          .format(eklemeZamani)
                                          .toString(),
                                      style: TextStyle(fontSize: 24),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    alinanVeri[index]["sonTarih"],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("Gorevler")
                                        .doc(mevcutkullaniciUidTutucu)
                                        .collection("Gorevlerim")
                                        .doc(
                                      alinanVeri[index]["zaman"],
                                    )
                                        .delete();
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color : Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => GorevEkle()),);
        },
      ),
    );
  }

  void mevcutkullaniciUidsiAl() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = await yetki.currentUser;

    setState(() {
      mevcutkullaniciUidTutucu = mevcutKullanici!.uid;
    });
  }
}


