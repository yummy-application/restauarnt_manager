import 'package:flutter/material.dart';
import 'package:restaurant_manager/classes/restaurant.dart';

import '../tableManagement/tables/tables.dart';

class HomeScreen extends StatefulWidget {
  final Restaurant restaurant;
  const HomeScreen({super.key, required this.restaurant});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TableManager(
                          restaurant: widget.restaurant,
                        ))),
            child: Center(
              child: Text(
                "Table Management",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 30),
              ),
            ),
          ),
        )
      ])),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(widget.restaurant.name)],
        ),
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  widget.restaurant.image,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: getTextWithChangingColors(widget.restaurant.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Row getTextWithChangingColors(String text,
    {Color? firstColor, Color? secondColor}) {
  firstColor ??= Colors.red;
  secondColor ??= Colors.green;

  List<Text> texts = [];
  for (int i = 0; i < text.length; i++) {
    texts.add(Text(
      text[i],
      style: TextStyle(
          color: i % 2 == 0 ? firstColor : secondColor,
          fontFamily: 'arial',
          fontSize: 40),
    ));
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: texts,
  );
}
