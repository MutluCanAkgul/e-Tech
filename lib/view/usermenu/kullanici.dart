import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/register.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/viewmodel/services/authservice.dart';

class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _User();
}

class _User extends State<User> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser(BuildContext context) async {
  // Giriş yap
  Map<String, dynamic>? userData = await AuthService().loginUser(
    email: emailController.text,
    password: passwordController.text,
  );

  if (userData != null) {
    String userId = userData['userId'];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Anasayfa(
          userName: userData['name'],
        ),
      ),
    );
  } else {
    // Kullanıcı girişi başarısız ise, hata göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hata"),
          content: const Text("E-posta veya şifre hatalı"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tamam"),
            )
          ],
        );
      },
    );
  }
}

  bool showText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Hesap",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Giriş Yap", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "E-Postanızı Girin",
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !showText,
                    decoration: InputDecoration(
                      labelText: "Şifrenizi Girin",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showText = !showText;
                          });
                        },
                        icon: Icon(showText ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                
                child: Container(
                  width: 390,
                  height: 63,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      child: const Text(
                        "Giriş Yap",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: () => loginUser(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Hesabınız yok mu?",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(width: 80),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                          },
                          child: const Text(
                            "Kayıt Ol",
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}