import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yugioh_cards/models/card_image_model.dart';
import 'package:yugioh_cards/models/card_model.dart';

class ApiYugioh{
  Future<List<CardModel>?> getCards(String url) async{
    var UrlCards = Uri.parse(url);
    var response = await http.get(UrlCards);
    if(response.statusCode == 200){
      return generateData(response);
    }
    else{
      var response = await http.get(Uri.parse("https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=&num=30&offset=0"));
      return (generateData(response));
    }
  }

  List<CardModel> generateData(response){
    int pos = 0;
    var cards = jsonDecode(response.body)["data"] as List;
    var cardList = cards.map((card) => CardModel.fromMap(card)).toList();
    for(final card in cardList){
      if(cards[pos]['linkmarkers'] == null){
        cards[pos]['linkmarkers'] = ["No makers"];
      }
      var images = cards[pos]['card_images'] as List;
      card.cardImages = images.map((image) => CardImage.fromMap(image)).toList();
      card.linkmarkers = List.from(cards[pos]['linkmarkers']);
      pos++;
    }
    return cardList;
  }
}