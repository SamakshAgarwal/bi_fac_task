import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Services with ChangeNotifier {
  final String accessId = '8qQkUjhHf45jLLHsoNp0CUCKOkrlsiJtWVctVC4qfUs';
  final String plantUrl =
      'https://api.unsplash.com/collections/1580860/photos/?';
  final String petsUrl = 'https://api.unsplash.com/collections/139386/photos/?';
  static int plantsPage = 1,
      petsPage = 1,
      currentPlantsPage = 0,
      currentPetsPage = 0;
  static List plantMap = [];
  static List petsMap = [];

  increasePlantPage() => plantsPage++;
  getPlants() async {
    if (currentPlantsPage != plantsPage) {
      currentPlantsPage = plantsPage;
      var response =
          await http.get('${plantUrl}page=$plantsPage&client_id=$accessId');
      var body = response.body;
      List json = convert.jsonDecode(body);
      json.forEach((element) {
        plantMap.add(
            {'title': element['description'], 'url': element['urls']['small']});
      });
      notifyListeners();
    }
    return plantMap;
  }

  increasePetPage() => petsPage++;

  getPets() async {
    if (currentPetsPage != petsPage) {
      currentPetsPage = petsPage;
      var response =
          await http.get('${petsUrl}page=$petsPage&client_id=$accessId');
      var body = response.body;
      List json = convert.jsonDecode(body);
      json.forEach((element) {
        petsMap.add(
            {'title': element['description'], 'url': element['urls']['small']});
      });
      notifyListeners();
    }
    return petsMap;
  }
}
