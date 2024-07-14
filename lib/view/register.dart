import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/usermenu/kullanici.dart';
import 'package:flutter_application_1/viewmodel/services/authservice.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<Register> {
  bool showTextPassword = false;
  bool showTextPasswordConfirmation = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController isimController = TextEditingController();
  TextEditingController soyisimController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  TextEditingController sifreOnayController = TextEditingController();

  void _kayitOl(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String isim = isimController.text;
      String soyisim = soyisimController.text;
      String email = emailController.text;
      String sifre = sifreController.text;
      String sifreOnay = sifreOnayController.text;

      if (sifre.length < 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifre en az 7 karakter olmalıdır'),
          ),
        );
        return;
      }

      if (!email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Geçerli bir e-posta adresi giriniz'),
          ),
        );
        return;
      }

      if (sifre == sifreOnay) {
        AuthService().registerUser(
          name: isim,
          email: email,
          password: sifre,
          surname: soyisim,
        ).then((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Uyarı"),
                content: const Text("Kaydınız Başarıyla Oluşturulmuştur"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => User()),
                      );
                    },
                    child: const Text("Tamam"),
                  ),
                ],
              );
            },
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifreler uyuşmuyor'),
          ),
        );
      }
    }
  }

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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Kayıt Ol",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: isimController,
                            decoration: const InputDecoration(
                              labelText: "İsminiz",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Lütfen isminizi girin';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: soyisimController,
                            decoration: const InputDecoration(
                              labelText: "Soyisminiz",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Lütfen soyisminizi girin';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "E-posta ",
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen e-posta adresinizi girin';
                    }
                    if (!value.contains('@')) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: sifreController,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showTextPassword = !showTextPassword;
                        });
                      },
                      icon: Icon(showTextPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: !showTextPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir şifre girin';
                    }
                    if (value.length < 7) {
                      return 'Şifre en az 7 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: sifreOnayController,
                  decoration: InputDecoration(
                    labelText: "Şifre Onay",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showTextPasswordConfirmation =
                              !showTextPasswordConfirmation;
                        });
                      },
                      icon: Icon(showTextPasswordConfirmation
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: !showTextPasswordConfirmation,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen şifrenizi onaylayın';
                    }
                    if (value != sifreController.text) {
                      return 'Şifreler uyuşmuyor';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
             Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    children: [
      Expanded(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),shape:MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))) ,
            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity,60))
          ),
          onPressed: () => _kayitOl(context),
          child: const Text(
            'Kayıt Ol',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  ),
),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => User()),
                    );
                  },
                  child: const Text(
                    "Hesabınız mı var? Giriş Yap",
                    style: TextStyle(
                        fontSize: 20,fontWeight: FontWeight.w500, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}