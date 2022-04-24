import 'package:flutter/material.dart';

import '../screens/detail_card_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    "/details_card": (BuildContext context) => DetailCardScreen()
  };
}