import 'package:flutter/material.dart';
import 'package:ridemate/routes/routes_constants.dart';
import 'package:ridemate/views/conducteur/acceuil.dart';
import 'package:ridemate/views/conducteur/choix_position_depart.dart';
import 'package:ridemate/views/conducteur/choix_profil.dart';
import 'package:ridemate/views/conducteur/inscription.dart';
import 'package:ridemate/views/passager/inscription.dart';
import 'package:ridemate/views/shared_views/connexion.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('fr'),
    ],
    locale: const Locale('fr'),
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      inscription_conducteur_route: (context){
        return const InscriptionConducteurPageWidget();
      },
      inscription_passager_route: (context){
        return const InscriptionPassagerPageWidget();
      },
      connexion_route: (context){
        return const ConnexionPageWidget();
      },
      choix_position_depart_route: (context){
        return const ChoixPositionDepart();
      },
    },
    home: const ChoixPositionDepart(),
  ));
}

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}