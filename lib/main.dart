import 'package:weather_app_final/call_weather_api.dart';
import 'package:weather_app_final/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ___________________________________________________________________________ Geolocation
  Position? position;
  void getLocation() async {
    var permission = await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }

  // ___________________________________________________________________________ Variables
  TextEditingController controller = TextEditingController();
  WeatherModel? weatherModel;
  var temp;
  int? cel;
  String? tempMsg;
  String? lat;
  String? lon;
  var dateTime = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 226, 231, 231),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(248, 16, 155, 121),
          title: const Text("Weather App"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image.asset('assets/as-logo.png', height: 100, width: 100),
            // _____________________________________ First Row
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(248, 16, 155, 121)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(248, 16, 155, 121)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3,
                              color: Color.fromARGB(248, 16, 155, 121)),
                        ),
                        labelText: 'City Name',
                        hintText: 'Enter City Name',
                      ),
                      controller: controller,
                    ),
                  )),
                  const SizedBox(width: 10),
                  Expanded(
                    // _________________________________________________________ Location Button
                    child: SizedBox(
                      width: 150,
                      height: 50.0,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.my_location_rounded),
                        label: const Text('Location'),
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(248, 16, 155, 121),
                          // side: BorderSide(color: Colors.yellow, width: 5),
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.normal),
                        ),
                        onPressed: () async {
                          getLocation();
                          weatherModel = await CallWeatherByLocation()
                              .getWeather(position?.latitude.toString(),
                                  position?.longitude.toString());
                          temp = weatherModel?.main?.temp;
                          if (weatherModel != null) {
                            cel = temp.round();
                            tempMsg = '$cel°C';
                          } else {
                            tempMsg = 'Incorrect City';
                          }
                          lat = (position?.latitude).toString();
                          lon = (position?.longitude).toString();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // _________________________________________________________________ Latitude & Longitude
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Latitude      $lat        Longitude      $lon",
                style: TextStyle(
                    height: 1,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            // _________________________________________________________________ City & Country
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "${weatherModel?.name}",
                style: TextStyle(
                    height: 1,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            // _________________________________________________________________ VIEW WEATHER
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: SizedBox(
                width: 500,
                height: 57.0,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search_sharp, size: 30),
                  label: const Text('Search'),
                  onPressed: () async {
                    weatherModel =
                        await CallWeatherApi().getWeather(controller.text);
                    temp = weatherModel?.main?.temp;
                    if (weatherModel != null) {
                      cel = temp.round();
                      tempMsg = '$cel°C';
                    } else {
                      tempMsg = 'Incorrect City';
                    }
                    lat = (weatherModel?.coord?.lat).toString();
                    lon = (weatherModel?.coord?.lon).toString();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(248, 16, 155, 121),
                    elevation: 0,
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontStyle: FontStyle.normal),
                  ),
                ),
              ),
            ),
            // _________________________________________________________________ Date Time
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Date & Time: ${dateTime ?? 0}",
                style: TextStyle(
                    height: 1,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            // _________________________________________________________________ Temperature
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Center(
                child: Text(
                  '$tempMsg',
                  style: const TextStyle(
                      height: 1,
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
              ),
            ),
            // _________________________________________________________________ Humidity
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Humidity                          ${weatherModel?.main?.humidity}%",
                style: TextStyle(
                    height: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            // _________________________________________________________________ Sunset & Sunrise images
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    // _________________________________________________________
                    child: Image.asset('assets/sunrise.png',
                        height: 100, width: 100),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // _________________________________________________________
                    child: Image.asset('assets/sunset.png',
                        height: 100, width: 100),
                  ),
                ],
              ),
            ),
            // _________________________________________________________________ Sunset & Sunrise
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "${formatted(weatherModel?.sys?.sunrise ?? 0)}                                           ${formatted(weatherModel?.sys?.sunset ?? 0)}",
                style: TextStyle(
                    height: 1,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // __________________________________________
  String formatted(timeStamp) {
    final DateTime date1 =
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return DateFormat('hh:mm a').format(date1);
  }
}
