import 'package:flutter/material.dart';
import 'package:ridemate/components/location_list_tile.dart';
import 'package:ridemate/components/network_utils.dart';
import 'package:ridemate/models/autocomplate_prediction.dart';
import 'package:ridemate/models/place_auto_complate_response.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/conducteur/acceuil.dart';

class PagePosition extends StatefulWidget {
  const PagePosition({super.key});

  @override
  State<PagePosition> createState() => _PagePositionState();
}

class _PagePositionState extends State<PagePosition> {
  List<AutocompletePrediction> placePredictions = [];

  void placeAutocomplete(String query)async{
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {
          "input":query,
          "key":"AIzaSyCkJGeX54xAOLG5ZNfxKv4JEHfvmCZaQlg"
        }
    );
    String? response = await NetworkUtility.fetchUrl(uri);
    if(response != null){
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if(result.predictions != null){
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }
  final TextEditingController _choix = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisissez votre position'),
      ),
      body: Column(
        children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: TextFormField(
          controller: _choix,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Ex: Cotonou,Akpakpa',
            border: const OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
            onChanged: (value) {
              //+++
              placeAutocomplete(value);
              //---
            },
      ),
        ),
          Expanded(
            child: ListView.builder(
                itemCount: placePredictions.length,
                itemBuilder: (context,index) => LocationListTile(
                  press: ()async{
                    //await showErrorDialog(context, placePredictions[index].description!);
                    Navigator.push(
                        context,
                        NoAnimationMaterialPageRoute(
                            builder: (context) => AcceuilConducteurPageWidget(position: placePredictions[index].description!,),
                            settings: null));
                  },
                  location: placePredictions[index].description!,
                )),
          ),
        ],
      ),
    );
  }
}
