import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AdresEkle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdresEkleState();
}

class _AdresEkleState extends State<AdresEkle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  TextEditingController adresBasligi = TextEditingController();
  TextEditingController adres = TextEditingController();  
  TextEditingController telefonNum = TextEditingController();  
  String? _selectedCity;
  String? _selectedDistrict;

  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _kullanicilarRef = FirebaseFirestore.instance.collection('Kullanicilar');

  List<String> _sehirler = [];
  List<String> _ilceler = [];

  @override
  void initState() {
    super.initState();
    _getSehirler();
  }

  Future<void> _getSehirler() async {
    QuerySnapshot sehirlerSnapshot = await _firestore.collection('Sehirler').get();
    setState(() {
      _sehirler = sehirlerSnapshot.docs.map((doc) => doc.id as String).toList();
    });
  }

  Future<void> _getIlceler(String sehir) async {
    DocumentSnapshot sehirDoc = await _firestore.collection('Sehirler').doc(sehir).get();
    if (sehirDoc.exists) {
      QuerySnapshot ilcelerSnapshot = await sehirDoc.reference.collection('ilceler').get();
      setState(() {
        _ilceler = ilcelerSnapshot.docs.map((doc) => doc['adi'] as String).toList();
      }); 
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adres Ekle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: adresBasligi,
                      decoration: const InputDecoration(labelText: "Adres Başlığı*", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir adres başlığı giriniz.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCity,
                      items: _sehirler.map((sehir) {
                        return DropdownMenuItem<String>(
                          value: sehir,
                          child: Text(sehir),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                          _getIlceler(value!); 
                          _selectedDistrict = null;
                        });
                      },
                      decoration:const InputDecoration(labelText: 'Şehir*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir şehir seçiniz.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDistrict,
                      items: _ilceler.map((ilce) {
                        return DropdownMenuItem<String>(
                          value: ilce,
                          child: Text(ilce),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'İlçe*'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir ilçe seçiniz.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        // Telefon numarası girildiğinde tetiklenecek fonksiyon
                      },
                      onInputValidated: (bool value) {
                        // Telefon numarasının doğrulandığı zaman tetiklenecek fonksiyon
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: PhoneNumber(isoCode: 'TR'),
                      textFieldController: telefonNum,
                      formatInput: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 13,
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        // Telefon numarası kaydedildiğinde tetiklenecek fonksiyon
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: adres,
                      decoration:const InputDecoration(hintText: "Adres*", border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir adres giriniz.';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                   onTap: () async {
                    if (_formKey.currentState!.validate()) {
                       String? userId = _auth.currentUser?.uid;
                       if(userId != null && userId.isNotEmpty)
                       {
                            _addAddress(context);
                       }
                       else {
                         showDialog(
                           context: context,
                           builder: (BuildContext context) {
                             return AlertDialog(
                               title: const Text("Hata"),
                               content: const Text("Kullanıcı kimliği alınamadı."),
                               actions: <Widget>[
                                 TextButton(
                                   onPressed: () {
                                     Navigator.pop(context);
                                   },
                                   child: const Text("Tamam"),
                                 ),
                               ],
                             );
                           },
                         );
                       }
                      }
                     },
                  child: Container(
                    height: 66,
                    width:400,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Adresi Ekle",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _addAddress(BuildContext context) async {
  try {
    String? userId = _auth.currentUser?.uid;
    if (userId != null && userId.isNotEmpty) {
      await _firestore.collection('Adresler').add({   
        'baslik': adresBasligi.text,
        'sehir': _selectedCity,
        'ilce': _selectedDistrict,
        'adres': adres.text,
        'telNo': telefonNum.text, 
        'kulId': userId
      });
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Başarılı"),
            content: const Text("Adres Başarıyla Eklendi"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Adres ekleme sayfasını kapat
                },
                child: const Text("Tamam"),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Hata"),
            content: const Text("Kullanıcı kimliği alınamadı."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Tamam"),
              )
            ],
          );
        },
      );
    }
  } catch (e) {
    print('Adres eklenirken hata oluştu: $e');
  }
}
}

    
  
