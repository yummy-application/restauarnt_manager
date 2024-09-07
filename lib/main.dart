import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restauarnt_manager/http/info/restaurantInfo.dart';
import 'package:restauarnt_manager/restaurantSetup/settings.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'localDB/getAllRestaurants.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

final appColorScheme = ColorScheme(
  primary: Colors.green,
  brightness: Brightness.dark,
  onPrimary: Colors.grey[800]!,
  secondary: Colors.amber.shade600,
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  surface: Colors.grey[800]!,
  onSurface: Colors.grey[100]!,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Manager',
      theme: ThemeData(
        colorScheme: appColorScheme,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Restaurant Manager',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Yummy Restaurant Manager",
                    style: Theme.of(context).textTheme.headlineLarge,
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children: [restaurantButtons(context)],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget restaurantButtons(BuildContext context) {
  return FutureBuilder<List<Map<String, Object?>>>(
    future: getAllConnectedRestaurants(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
          child: Text('No restaurants connected'),
        );
      } else {
        List<Map<String, Object?>> restaurants = snapshot.data!;
        return Column(
          children: [
            ...restaurants.map((restaurant) {
              return FutureBuilder<Map<String, Object?>>(
                future:
                    getFullRestaurantInfo(restaurant['backend_url'].toString()),
                builder: (context, innerSnapshot) {
                  if (innerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (innerSnapshot.hasData) {
                    String restaurantName =
                        innerSnapshot.data!['name'].toString();
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print(restaurantName);
                            },
                            child: Text(restaurantName ?? 'Unknown'),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            }).toList(),
            // Add the "Add a restaurant" button
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestaurantSetupSettings(),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.black26),
                elevation: WidgetStateProperty.all<double>(3),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70)),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Add a restaurant",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    },
  );
}
