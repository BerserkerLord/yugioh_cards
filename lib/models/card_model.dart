import 'card_image_model.dart';
class CardModel{
  int? id;
  int? atk;
  int? def;
  int? level;
  int? linkval;
  int? scale;
  String? attribute;
  String? name;
  String? type;
  String? desc;
  String? race;
  String? archetype;
  List<String>? linkmarkers;
  List<CardImage>? cardImages;

  CardModel({
    this.id,
    this.atk,
    this.def,
    this.level,
    this.attribute,
    this.name,
    this.type,
    this.desc,
    this.race,
    this.cardImages,
    this.archetype,
    this.linkval,
    this.linkmarkers,
    this.scale
  });



  factory CardModel.fromMap(Map<String, dynamic> map){
    return CardModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      desc: map['desc'],
      race: map['race'],
      archetype: map['archetype'] ?? "No archetype",
      atk: map['atk'] ?? 20000,
      def: map['def'] ?? 20000,
      level: map['level'] ?? 20000,
      attribute: map['attribute'] ?? "No attribute",
      linkval: map['linkval'] ?? 9,
      scale: map['scale'] ?? 60
    );
  }
}