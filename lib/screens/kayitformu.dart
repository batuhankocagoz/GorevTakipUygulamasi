import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KayitFormu extends StatefulWidget {
  const KayitFormu({Key? key}) : super(key: key);

  @override
  State<KayitFormu> createState() => _KayitFormuState();
}

String? kullaniciAdi, email, parola;
bool kayitDurumu = false;

class _KayitFormuState extends State<KayitFormu> {

  var _dogrulamaAnahtari = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dogrulamaAnahtari,
      child: Container(
        height: MediaQuery.of(context).size.height ,
        width: MediaQuery.of(context).size.width,

        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40.0,),
              height: 220,
              child: Image.asset("images/resim.png"),
            ),
            if (!kayitDurumu)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (alinanAd){
                    kullaniciAdi = alinanAd;
                  },
                  validator: (alinanAd){
                    return alinanAd!.isEmpty
                        ? "Kullanıcı adı boş bırakılamaz!"
                        : null;
                  },
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı : ",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (alinanEmail){
                  email = alinanEmail;
                },
                validator: (alinanEmail){
                  return alinanEmail!.contains("@")
                      ? null
                      : "Geçersiz Email!";
                },
                decoration: InputDecoration(
                  labelText: "Email : ",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                onChanged: (alinanParola){
                  parola = alinanParola;
                },
                validator: (alinanParola){
                  return alinanParola!.length >=6
                      ? null
                      : "Şifreniz en az 6 karakter olmalıdır!";
                },
                decoration: InputDecoration(
                  labelText: "Şifre : ",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Container(
                height: 50,
                child: ElevatedButton(
                  child: kayitDurumu
                      ? Text("Giriş Yap",
                      style: TextStyle(fontSize: 24)
                  )
                      : Text("Kayıt Ol",
                      style: TextStyle(fontSize: 24)
                  ),
                  onPressed: (){
                    kayitEkle();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
                  ) ,
                ),
              ),
            ),

            Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      kayitDurumu = !kayitDurumu;
                    });
                  },
                  child: kayitDurumu
                      ? Text("Hesabım Yok")
                      : Text("Zaten Hesabım Var"),
                ),
            )
          ],
        ),
      ),
    );
  }

  void kayitEkle() {
    if(_dogrulamaAnahtari.currentState!.validate()){
      formuTestEt(email!, parola!);
    }
  }
  void formuTestEt(String email, String parola) async{
    final yetki = FirebaseAuth.instance;
    AuthCredential? yetkiSonucu;

    if (kayitDurumu){
      yetkiSonucu = (await yetki.signInWithEmailAndPassword(email: email, password: parola)) as AuthCredential;
    }
    else{
      yetkiSonucu = (await yetki.createUserWithEmailAndPassword(email: email, password: parola)) as AuthCredential;
    }
      //String uidTutucu = yetkiSonucu.user.uid;
      String uidTutucu = yetkiSonucu.toString();
      await FirebaseFirestore.instance.collection("Kullanicilar").doc(uidTutucu).set({"kullaniciAdi": kullaniciAdi, "email": email});
  }
}