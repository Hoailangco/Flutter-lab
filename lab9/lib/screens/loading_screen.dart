import 'package:flutter/material.dart';
import 'package:lab9/screens/location_screen.dart';
import 'package:lab9/services/networking.dart';
import '../services/location.dart'; // Make sure your path is correct

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    const apiKey = 'cbffb9d1405b97b86ec1ebc1757ecc1c';

    // 1. Get GPS Location
    Location location = Location();
    await location.getCurrentLocation();

    // 2. Build the URL with coordinates and API Key
    // We use string interpolation like you might in your game dev work
    String url =
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=${location.latitude}'
        '&lon=${location.longitude}'
        '&appid=$apiKey'
        '&units=metric';

    // 3. Fetch the weather data
    NetworkHelper networkHelper = NetworkHelper(url);
    var weatherData = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return LocationScreen(locationWeather: weatherData);
    }));

    // We will eventually navigate to the main weather screen here
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // This shows the loading spinner
      ),
    );
  }
}
