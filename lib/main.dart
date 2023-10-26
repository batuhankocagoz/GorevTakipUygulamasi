import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/anasayfa.dart';
import 'screens/kayitekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(options: FirebaseOptions(
    apiKey: 'AIzaSyCcZk2hBBQanUIZvbG2YPB-XyEvgNLygqU',
    appId: '1:915125767241:android:fe70b9cb159a16c7894398',
    messagingSenderId: '915125767241',
    projectId: 'gorevtakipapp',
  ));
  runApp((Yapilacaklar()));
}

class Yapilacaklar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, kullaniciVerisi){
          if (kullaniciVerisi.hasData)
            return AnaSayfa();
          else
            return KayitEkrani();
        },
      ),
    );
  }
}