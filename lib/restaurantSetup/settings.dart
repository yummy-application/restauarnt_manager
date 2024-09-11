import 'package:flutter/material.dart';
import 'package:restauarnt_manager/http/setup/validation.dart';
import '../http/setup/createRestaurant.dart' as createRestaurant;
import '../localDB/setup/setup.dart';
import '../main.dart'; // Assuming this file contains validateBackendAddress function

class RestaurantSetupSettings extends StatefulWidget {
  const RestaurantSetupSettings({super.key});

  @override
  State<RestaurantSetupSettings> createState() =>
      _RestaurantSetupSettingsState();
}

class _RestaurantSetupSettingsState extends State<RestaurantSetupSettings> {
  final _formKey = GlobalKey<FormState>();
  bool _backendAddressIsValid = false;
  late TextEditingController _addressController;
  late TextEditingController _restaurantNameController;
  late TextEditingController _restaurantImageController;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _restaurantNameController = TextEditingController();
    _restaurantImageController = TextEditingController();
    _passwordController = TextEditingController();
    _restaurantImageController.text =
        "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  }

  @override
  void dispose() {
    _addressController.dispose();
    _restaurantNameController.dispose();
    _restaurantImageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _testBackendAddress() async {
    bool isValid = await validateBackendAddress(_addressController.text);
    setState(() {
      _backendAddressIsValid = isValid;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Setup a Restaurant',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Please enter the details below: ",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _addressController, // Use the controller here
                      decoration: const InputDecoration(
                        hintText: 'Backend Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valid address';
                        }
                        if (!_backendAddressIsValid) {
                          return 'This address is invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _testBackendAddress,
                  icon: const Icon(Icons.sync),
                  tooltip: "Test",
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Restaurant Name',
              ),
              controller: _restaurantNameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Restaurant Image URL',
              ),
              controller: _restaurantImageController,
              onSaved: (value) {
                setState(() {});
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Your secure password',
              ),
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            Image.network(
              _restaurantImageController.text.isEmpty
                  ? "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                  : _restaurantImageController.text,
              height: 400,
              width: 400,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _addressController.text.isNotEmpty &&
                      _restaurantNameController.text.isNotEmpty &&
                      _restaurantImageController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty &&
                      _passwordController.text.length >= 6) {
                    _formKey.currentState!.save();
                    int response = await createRestaurant.restaurantCreation(
                        _addressController.text,
                        _restaurantNameController.text,
                        _restaurantImageController.text,
                        _passwordController.text);
                    if (response == 200) {
                      addRestaurantConnection(
                          _addressController.text, _passwordController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                    } else if (response == 409) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                  "There is already a restaurant at this ip"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Error ${response.toString()}"),
                              content: const Text("Something went wrong"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                    }
                  }
                },
                child: const Text("Create Restaurant"))
          ],
        ),
      ),
    );
  }
}
