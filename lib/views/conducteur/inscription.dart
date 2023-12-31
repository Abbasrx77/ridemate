import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/utilities/error_dialog.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/shared_views/connexion.dart';

class InscriptionConducteurPageWidget extends StatefulWidget {
  const InscriptionConducteurPageWidget({Key? key}) : super(key: key);

  @override
  _InscriptionConducteurPageWidgetState createState() =>
      _InscriptionConducteurPageWidgetState();
}

class _InscriptionConducteurPageWidgetState
    extends State<InscriptionConducteurPageWidget> {
  final apiService = ApiService();
  final storage = const FlutterSecureStorage();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropdownValue = 'Véhicule';
  String dropdownValue2 = '1';

  //TEXT EDITING CONTROLLER
  final TextEditingController _matricule = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _zone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password_retype = TextEditingController();

  //REGEX DE VALIDATION EMAIL
  bool isEmailValid(String email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z/d.a-zA-Z\d_%-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    _matricule.dispose();
    _email.dispose();
    _zone.dispose();
    _password.dispose();
    _password_retype.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          height: deviceWidth *
              0.1, // you can increase or decrease the height as you need
          child: Image.asset('assets/main_logo.png'),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(deviceWidth * 0.05),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Inscription',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: deviceHeight * 0.05),
              TextFormField(
                controller: _matricule,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le matricule";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Matricule',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              TextFormField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer l'email";
                  } else if (!isEmailValid(value)) {
                    return "Email invalide";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              TextFormField(
                controller: _zone,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer la zone";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Zone Ex: Cotonou,Akpakpa',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField(
                      hint: Text(dropdownValue),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Faites un choix !";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Voiture', 'Moto']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                      width: 10), // to add space between the dropdowns
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField(
                      hint: const Text("Places"),
                      value: dropdownValue == 'Voiture' ? '1' : null,
                      validator: (value) {
                        if (dropdownValue == 'Voiture') {
                          if (value == null || value.isEmpty) {
                            return "Faites un choix !";
                          }
                          return null;
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: dropdownValue == 'Voiture'
                          ? (String? newValue) {
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                            }
                          : null,
                      items: dropdownValue == 'Voiture'
                          ? <String>['1', '2', '3', '4']
                              .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                          : null,
                    ),
                  )
                ],
              ),
              SizedBox(height: deviceHeight * 0.02),
              TextFormField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez un mot de passe";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              TextFormField(
                controller: _password_retype,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value != _password.text) {
                    return "Mots de passe différents";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => const ConnexionPageWidget(),
                          settings: null));
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Vous avez déjà un compte?\n',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Connectez-vous',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              ElevatedButton(
                onPressed: () async {
                  //INSCRIPTION

                  final matricule = _matricule.text.toString();
                  final email = _email.text.toLowerCase();
                  final zone = _zone.text.toLowerCase();
                  final vehicule = dropdownValue.toLowerCase();
                  final places = dropdownValue2;
                  final password = _password.text.toString();
                  final fcmToken =
                      await storage.read(key: 'fcmToken') ?? 'test';

                  final user = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  _fireStore.collection('users').doc(user.user!.uid).set({
                    'uid': user.user!.uid,
                    'email': email,
                  });

                  Map<String, String> body = {
                    'matricule': matricule,
                    'email': email,
                    'zone': zone,
                    'vehicule': vehicule,
                    'place': places,
                    'fonction': 'conducteur',
                    'password': password,
                    'fcmToken': fcmToken,
                    'uid': user.user!.uid
                  };

                  try {
                    if (!_formKey.currentState!.validate()) {
                      await showErrorDialog(
                          context, "Veuillez suivre les indications.");
                    } else {
                      final response = await apiService
                          .inscription('inscription', body: body);
                      if (response.statusCode == 201) {
                        //REDIRECTION
                        // L'utilisateur doit etre redirigé vers la page d'acceuil conducteur ou connexion
                        await storage.write(key: 'vehicule', value: vehicule);
                        Navigator.pushReplacement(
                            context,
                            NoAnimationMaterialPageRoute(
                                builder: (context) =>
                                    const ConnexionPageWidget(),
                                settings: null));
                      } else if (response.statusCode == 404) {
                        await showErrorDialog(context, "Identifiant invalide");
                      } else {
                        await showErrorDialog(context,
                            "Oups, une erreur s'est produite à notre niveau, veuillez réessayer plus tard ${response.body}");
                      }
                    }
                  } catch (e) {
                    await showErrorDialog(context,
                        "Oops, une erreur s'est produite à notre niveau, veuillez réessayer plus tard ${e}");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      vertical: deviceWidth * 0.04,
                      horizontal: deviceWidth * 0.13)),
                ),
                child: const Text(
                  'S\'inscrire',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
