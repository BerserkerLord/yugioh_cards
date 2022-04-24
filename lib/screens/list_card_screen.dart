import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:yugioh_cards/models/card_model.dart';
import 'package:yugioh_cards/settings/settings_color.dart';
import 'package:yugioh_cards/network/api_yugioh.dart';
import '../views/card_view.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  ApiYugioh? apiYugioh;
  int page = 0;
  String s = "";
  String? url = "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=&num=30&offset=0";
  var search = TextEditingController();
  @override
  void initState(){
    super.initState();
    apiYugioh = ApiYugioh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsColor.backColor,
      appBar: AppBar(
        title: Text("Card Data - YGOPRODECK", style: TextStyle(color: SettingsColor.textColor)),
        backgroundColor: SettingsColor.cardColor,
      ),
      body: FutureBuilder(
        future: apiYugioh!.getCards(url!),
        builder: (BuildContext context, AsyncSnapshot<List<CardModel>?> snapshot){
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocurrio un error en la solicitud'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return _listCards(snapshot.data);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        }
      )
    );
  }

  Widget _listCards(List<CardModel>? cards){
    ItemScrollController _scrollController = ItemScrollController();
    int pagePosition = (page/30).toInt();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: SettingsColor.textColor),
              keyboardType: TextInputType.text,
              controller: search,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: SettingsColor.textColor),
                prefixIcon: IconButton(
                  onPressed: (){
                    s = search.text.isEmpty ? "" : search.text;
                    page = 0;
                    String baseUrl = "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=${s}&num=30&offset=0";
                    setState((){
                      url = baseUrl;
                    });
                  },
                  icon: Icon(Icons.search, color: SettingsColor.textColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: SettingsColor.textColor, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: SettingsColor.textColor, width: 1.0),
                )
              )
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index){
                  CardModel card = cards![index];
                  return CardView(cardModel: card);
                },
                itemCount: cards!.length
              )
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 40),
              child: Row(
                children: [
                  arrowIndex("<<"),
                  Flexible(
                    child: ScrollablePositionedList.builder(
                      scrollDirection: Axis.horizontal,
                      itemScrollController: _scrollController,
                      initialScrollIndex: pagePosition,
                      itemBuilder: (context, index){
                        return TextButton(
                          style: ButtonStyle(
                            backgroundColor: page == index*30 ? MaterialStateProperty.all<Color>(SettingsColor.backColor) : MaterialStateProperty.all<Color>(SettingsColor.cardColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: BorderSide(color: SettingsColor.textColor)
                              )
                            )
                          ),
                          onPressed: (){
                            page = 30*index;
                            String baseUrl = "https://db.ygoprodeck.com/api/v7/cardinfo.php?fname=${s}&num=30&offset=${page.toString()}&desc=${s}";
                            setState(() {
                              url = baseUrl;
                            });
                          },
                            child: Text(index.toString(), style: TextStyle(color: SettingsColor.textColor))
                        );
                      },
                      itemCount: 398,
                    )
                  ),
                  arrowIndex(">>")
                ]
              )
            )
          ]
        )
      )
    );
  }

  Widget arrowIndex(String? typeArrow){
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(SettingsColor.cardColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    side: BorderSide(color: SettingsColor.textColor)
                )
            )
        ),
        onPressed: (){
          if(typeArrow == ">>"){
            page = 30*397;
          } else {
            page = 30*0;
          }
          String baseUrl = "https://db.ygoprodeck.com/api/v7/cardinfo.php?&num=30&offset=${page.toString()}";
          setState(() {
            url = baseUrl;
          });
        },
        child: Text(typeArrow!, style: TextStyle(color: SettingsColor.textColor))
    );
  }
}
