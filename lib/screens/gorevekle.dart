import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GorevEkle extends StatefulWidget {
  const GorevEkle({Key? key}) : super(key: key);

  @override
  State<GorevEkle> createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {

  TextEditingController adAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,
        title: Text("Görev Ekleme Ekranı"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0,top: 20.0,right: 10.0),
            child: TextFormField(
              controller: adAlici,
              decoration: InputDecoration(
                labelText: "Görev Adı : ",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0,top: 20.0,right: 10.0),
            child: TextFormField(
              controller: tarihAlici,
              decoration: InputDecoration(
                labelText: "Son Tarih : ",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.only(left: 10.0,top: 20.0,right: 10.0),
            height: 70,
            width: double.infinity,
            child: ElevatedButton(
              child: Text("Görevi Ekle", style: TextStyle(fontSize: 24),),
              onPressed: () {
                verileriEKle();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
              ),
            ),
          )
        ],
      ),
    );
  }

  void verileriEKle() async{
    FirebaseAuth yetki = FirebaseAuth.instance;
    //final FirebaseUser mevcutKullanici = await yetki.currentUser();
    var mevcutKullanici = await yetki.currentUser;

    String uidTutucu = mevcutKullanici!.uid;
    var zamanTutucu = DateTime.now();

    await FirebaseFirestore.instance.
    collection("Gorevler").
    doc(uidTutucu).
    collection("Gorevlerim").
    doc(zamanTutucu.toString()).
    set({
      "ad": adAlici.text,
      "sonTarih" : tarihAlici.text,
      "zaman" : zamanTutucu.toString(),
      "tamZaman" : zamanTutucu
    });

    Fluttertoast.showToast(msg: "Görev Başarıyla Eklenmistir.");
  }
}