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
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestaurantSetupSettings(),
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black26),
                elevation: MaterialStateProperty.all<double>(3),
                shape: MaterialStateProperty.all<OutlinedBorder>(
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
            const Text('Error loading restaurants'),
          ],
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestaurantSetupSettings(),
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black26),
                elevation: MaterialStateProperty.all<double>(3),
                shape: MaterialStateProperty.all<OutlinedBorder>(
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
            const Text('No restaurants connected'),
          ],
        );
      } else {
        List<Map<String, Object?>> restaurants = snapshot.data!;
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RestaurantSetupSettings(),
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black26),
                elevation: MaterialStateProperty.all<double>(3),
                shape: MaterialStateProperty.all<OutlinedBorder>(
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
            ...restaurants.map((restaurant) {
              return FutureBuilder<Map<String, Object?>>(
                future:
                    getFullRestaurantInfo(restaurant['backend_url'].toString()),
                builder: (context, innerSnapshot) {
                  if (innerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (innerSnapshot.hasError) {
                    return const Text('Error loading restaurant info');
                  } else if (innerSnapshot.hasData) {
                    String restaurantName =
                        innerSnapshot.data!['name'].toString();
                    return ElevatedButton(
                      onPressed: () {
                        print(restaurantName);
                      },
                      child: Text(restaurantName),
                    );
                  } else {
                    return const Text('Unknown restaurant');
                  }
                },
              );
            }).toList(),
          ],
        );
      }
    },
  );
}
