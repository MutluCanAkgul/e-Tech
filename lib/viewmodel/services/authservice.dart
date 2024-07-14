import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  // Kullanıcı kaydı
  Future registerUser({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Firestore'da kullanıcı belgesini oluşturma
      await _firestore.collection('Kullanicilar').doc(userId).set({
        'name': name, 
        'surname': surname,
        'email': email,
        'password': password,
      });

      
      return userId;
    } catch (e) {
      return e.toString();
    }
  }

  // Kullanıcı girişi
  Future<Map<String, dynamic>?> loginUser({
  required String email,
  required String password,
}) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    String userId = userCredential.user!.uid;
    
    // Firestore'da kullanıcı belgesini kontrol etme
    DocumentSnapshot userSnapshot = await _firestore.collection('Kullanicilar').doc(userId).get();

    // Eğer kullanıcı belgesi varsa, giriş başarılı kabul edilir
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      userData['userId'] = userId;
      return userData;
    } else {
      // Kullanıcı belgesi bulunamazsa, null döndür
      return null;
    }
  } catch (e) {
    // Giriş işlemi sırasında bir hata oluşursa, null döndür
    print("Giriş sırasında hata: $e");
    return null;
  }
}
}