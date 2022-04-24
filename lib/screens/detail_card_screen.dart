import 'dart:ui';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:yugioh_cards/settings/settings_color.dart';

class DetailCardScreen extends StatefulWidget {
  const DetailCardScreen({Key? key}) : super(key: key);

  @override
  _DetailCardScreenState createState() => _DetailCardScreenState();
}

class _DetailCardScreenState extends State<DetailCardScreen> {
  late Map<String, dynamic> card;
  String _message = "";
  late List<Map<String, dynamic>> rowsGeneralInfo;
  late List<Map<String, dynamic>> rowsMonsterInfo;
  late List<Map<String, dynamic>> rowsLinkInfo;

  @override
  Widget build(BuildContext context) {
    String markers = "";
    card = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    for(final maker in card['linkmarkers']){
      markers += "${maker} ";
    }
    print(markers);
    rowsGeneralInfo = [
      {"assign": "ID Card", "data": card['id'].toString()},
      {"assign": "Type Card", "data": type()},
      {"assign": "Race", "data": race()},
      {"assign": "Archetype", "data": card['archetype']},
      {"assign": "Pendulum Scale", "data": card['scale'].toString()}
    ];
    rowsMonsterInfo = [
      {"assign": "ATK", "data": card['atk'].toString()},
      {"assign": "DEF", "data": card['def'].toString()},
      {"assign": "Level", "data": level()},
      {"assign": "Attribute", "data": card['attribute']}
    ];
    rowsLinkInfo = [
      {"assign": "Link Value", "data": card['linkval'].toString()},
      {"assign": "Link Markers", "data": markers}
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Information", style: TextStyle(color: SettingsColor.textColor)),
        backgroundColor: SettingsColor.cardColor,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: SettingsColor.cardColor, width: 2.0)
            ),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(color: SettingsColor.cardColor),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text("${card['name']}", style: TextStyle(color: SettingsColor.textColor, fontSize: 20))
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(right: 50, left: 50, top: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          barrierColor: SettingsColor.backColor,
                          barrierDismissible: true,
                          pageBuilder: (BuildContext context, _, __){
                            return Scaffold(
                              appBar: AppBar(
                                actions: [
                                  IconButton(
                                    onPressed: () async {
                                      await downloadCard(card['imageUrl']);
                                      final status = SnackBar(
                                        content: Text(_message),
                                        action: SnackBarAction(
                                          textColor: SettingsColor.cardColor,
                                          label: 'Hecho',
                                          onPressed: (){}
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(status);
                                    },
                                    icon: Icon(Icons.download, color: SettingsColor.textColor)
                                  )
                                ],
                                backgroundColor: SettingsColor.backColor,
                              ),
                              body: Column(
                                children: [
                                  Container(
                                    child: hero()
                                  )
                                ]
                              ),
                              backgroundColor: SettingsColor.backColor
                            );
                          }
                        )
                      );
                    },
                    child: hero()
                  )
                ),
                header("General Information"),
                tableInfo(rowsGeneralInfo),
                card['atk'] == 20000 ? Container() : header("Monster Information"),
                card['atk'] == 20000 ? Container() : tableInfo(rowsMonsterInfo),
                card['linkval'] == 9 ? Container() : header("Link Informartion"),
                card['linkval'] == 9 ? Container() : tableInfo(rowsLinkInfo),
                header("Description"),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(card['desc'], style: TextStyle(color: SettingsColor.textColor), textAlign: TextAlign.justify)
                )
              ]
            )
          )
        )
      ),
      backgroundColor: SettingsColor.backColor,
    );
  }

  Widget tableInfo(List<Map<String, dynamic>> data){
    return DataTable(
      border: TableBorder(horizontalInside: BorderSide(color: SettingsColor.cardColor, width: 2.0)),
      headingRowHeight: 0,
      columns: [DataColumn(label: Text("")), DataColumn(label: Text(""))],
      rows: data.map((element){
        if(element['assign'] == "DEF"){
          if(element['data'].toString() == "20000"){
            element['data'] = "No defense";
          }
        }
        if(element['assign'] == "Level"){
          if(card['level'].toString() == "20000"){
            element['data'] = "No level";
          }
        }
        if(element['assign'] == "Pendulum Scale"){
          if(card['scale'].toString() == "60"){
            element['data'] = "No Pendulum";
          }
        }
        return DataRow(
            cells: [
              DataCell(Text(element['assign'], style: TextStyle(color: SettingsColor.textColor))),
              DataCell(Expanded(child: element['data'] is String ? Text("${element['data']}", style: TextStyle(color: SettingsColor.textColor)) : element['data'],))
            ]
        );
      }).toList()
    );
  }

  Widget header(String string){
    return Container(
      decoration: BoxDecoration(color: SettingsColor.cardColor),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(string, style: TextStyle(color: SettingsColor.textColor))
      )
    );
  }

  Widget hero(){
    return Hero(
      tag: "image-card${card['name']}",
      child: FadeInImage(
        placeholder: const AssetImage('assets/placeholder.jpg'),
        image: NetworkImage('${card['imageUrl']}'),
        fadeInDuration: const Duration(milliseconds: 500),
      )
    );
  }

  Widget level(){
    return Row(
      children: [
        Image.asset('assets/l_icon.png', height: 20),
        Text('x${card['level']}', style: TextStyle(fontSize: 12, color: SettingsColor.textColor, overflow: TextOverflow.ellipsis))
      ]
    );
  }

  Widget type(){
    String? image;
    switch(card['type']){
      case "Effect Monster":
      case "Flip Effect Monster":
      case "Gemini Monster":
      case "Spirit Monster":
      case "Toon Monster":
      case "Tuner Monster":
      case "Union Effect Monster": image = "effect_monster_icon.jpg";
      break;
      case "Pendulum Effect Monster":
      case "Pendulum Flip Effect Monster":
      case "Pendulum Tuner Effect Monster": image = "pendulum_effect_monster.jpg";
      break;
      case "Synchro Tuner Monster":
      case "Synchro Monster": image = "synchro_monster_icon.jpg";
      break;
      case "Normal Monster":
      case "Normal Tuner Monster": image = "normal_monster_icon.jpg";
      break;
      case "Ritual Effect Monster":
      case "Ritual Monster": image = "ritual_monster_icon.jpg";
      break;
      case "XYZ Pendulum Effect Monster": image = "xyz_pendulum_effect_monster_icon.jpg";
      break;
      case "Synchro Pendulum Effect Monster": image = "synchro_pendulum_effect_monster_icon.jpg";
      break;
      case "Pendulum Effect Fusion Monster": image = "pendulum_effect_fusion_monster_icon.jpg";
      break;
      case "Pendulum Normal Monster": image = "pendulum_normal_monster_icon.jpg";
      break;
      case "XYZ Monster": image = "xyz_monster_icon.jpg";
      break;
      case "Token": image = "token_icon.jpg";
      break;
      case "Link Monster": image = "link_monster_icon.jpg";
      break;
      case "Skill Card": image = "skill_card_icon.jpg";
      break;
      case "Spell Card": image = "spell_card_icon.jpg";
      break;
      case "Trap Card": image = "trap_card_icon.jpg";
      break;
      case "Fusion Monster": image = "fusion_monster_icon.jpg";
      break;
    }
    return Container(
      width: 150,
      child: Row(
        children: [
          Image.asset('assets/$image', height: 20),
          SizedBox(width: 5),
          Flexible(child: Text('${card['type']}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: SettingsColor.textColor)))
        ]
      ),
    );
  }

  Widget race(){
    String? image;
    switch(card['race']){
      case "Aqua": image = "aqua_icon.png";
      break;
      case "Beast": image = "beast_icon.png";
      break;
      case "Beast-Warrior": image = "beast_warrior_icon.png";
      break;
      case "Counter": image = "counter_icon.png";
      break;
      case "Continuous": image = "continuous_icon.png";
      break;
      case "Creator-God": image = "creator_god_icon.png";
      break;
      case "Machine":
      case "Cyberse": image = "cyberse_icon.png";
      break;
      case "Dinosaur": image = "dinosaur_icon.png";
      break;
      case "Fairy":
      case "Divine-Beast": image = "divine_beast_icon.png";
      break;
      case "Dragon": image = "dragon_icon.png";
      break;
      case "Equip": image = "equip_team.png";
      break;
      case "Fiend": image = "fiend_icon.png";
      break;
      case "Field": image = "field_icon.png";
      break;
      case "Fish": image = "fish_icon.png";
      break;
      case "Insect": image = "insect_icon.png";
      break;
      case "Normal": image = "normal_icon.png";
      break;
      case "Plant": image = "plant_icon.png";
      break;
      case "Psychic": image = "psychic_icon.png";
      break;
      case "Pyro": image = "pyro_icon.png";
      break;
      case "Quick-Play": image = "quick_play_icon.png";
      break;
      case "Rock": image = "rock_icon.png";
      break;
      case "Ritual": image = "ritual_icon.png";
      break;
      case "Sea Serpent": image = "sea_serpent_icon.png";
      break;
      case "Spellcaster": image = "spellcaster_icon.png";
      break;
      case "Thunder": image = "thunder_icon.png";
      break;
      case "Warrior": image = "warrior_icon.png";
      break;
      case "Winged Beast": image = "winged_beast_icon.png";
      break;
      case "Wyrm":
      case "Reptile": image = "reptile_icon.png";
      break;
      case "Zombie": image = "zombie_icon.png";
      break;
    }
    return Row(
        children: [
          Image.asset('assets/$image', height: 20),
          SizedBox(width: 5),
          Text('${card['race']}', style: TextStyle(fontSize: 12, color: SettingsColor.textColor))
        ]
    );
  }

  Future<void> downloadCard(
      String url, {
        AndroidDestinationType? destination,
        bool whenError = false,
        String? outputMimeType,
      }) async {
    String? fileName;
    try {
      String? imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url,
            outputMimeType: outputMimeType)
            .catchError((error) {
          if (error is PlatformException) {
            if (error.code == "404") {
              return "Imagen no encontrada";
            } else if (error.code == "unsupported_file") {
              return "Archivo no soportado";
            }
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
        }
      }

      if (imageId == null) {
        setState(() => _message = "Ninguna respuesta por parte del servidor");
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
    } on PlatformException catch (error){
      setState(() => _message = error.message ?? '');
      return;
    }
    setState(() => _message = 'Saved as "$fileName"');
    return;
  }
}
