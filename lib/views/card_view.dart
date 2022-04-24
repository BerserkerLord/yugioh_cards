import 'package:flutter/material.dart';
import 'package:yugioh_cards/models/card_model.dart';
import 'package:yugioh_cards/settings/settings_color.dart';

class CardView extends StatelessWidget {
  CardView({Key? key, this.cardModel}) : super(key: key);

  CardModel? cardModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(){
        Navigator.pushNamed(context, "/details_card",
          arguments: {
            'imageUrl': cardModel!.cardImages![0].imageUrl,
            'name': cardModel!.name,
            'type': cardModel!.type,
            'race': cardModel!.race,
            'id': cardModel!.id,
            'desc': cardModel!.desc,
            'archetype': cardModel!.archetype,
            'atk': cardModel!.atk,
            'def': cardModel!.def,
            'level': cardModel!.level,
            'attribute': cardModel!.attribute,
            'linkval': cardModel!.linkval,
            'linkmarkers': cardModel!.linkmarkers,
            'scale': cardModel!.scale
          }
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Card(
            elevation: 15,
            shadowColor: Colors.black,
            color: SettingsColor.cardColor,
            child: SizedBox(
              child:  Padding(
                padding: EdgeInsets.only(bottom: 20, left: 40, right: 40, top: 10),
                child: Column(
                  children: [
                    FadeInImage(
                      placeholder: const AssetImage('assets/placeholder.jpg'),
                      image: NetworkImage('${cardModel!.cardImages![0].imageUrl}'),
                      fadeInDuration: const Duration(milliseconds: 500),
                    ),
                    SizedBox(height: 15),
                    Text('${cardModel!.name}', style: TextStyle(fontSize: 20, color: SettingsColor.textColor)),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Type(),
                        SizedBox(height: 10),
                        Race()
                      ]
                    )
                  ]
                )
              )
            )
          )
        )
      )
    );
  }

  Widget Type(){
    String? image;
    switch(cardModel!.type){
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
    
    return Row(
      children: [
        Image.asset('assets/$image', height: 20),
        SizedBox(width: 5),
        Text('${cardModel!.type}', style: TextStyle(fontSize: 12, color: SettingsColor.textColor))
      ]
    );
  }

  Widget Race(){
    String? image;
    switch(cardModel!.race){
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
        Text('${cardModel!.race}', style: TextStyle(fontSize: 12, color: SettingsColor.textColor))
      ]
    );
  }
}
