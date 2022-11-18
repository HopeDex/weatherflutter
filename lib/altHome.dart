import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import './dataset.dart';
import './detailPage.dart';
import './extraWeather.dart';

Weather currentTemp;
Weather tomorrowTemp;
List<Weather> todayWeather;
List<Weather> sevenDay;
String lat = "53.9006";
String lon = "27.5590";
String city = "Minisk";
var colorb = Color.fromARGB(255, 151, 191, 224);
var colora = Color.fromARGB(255, 85, 83, 198);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    fetchData(lat, lon, city).then((value) {
      currentTemp = value[0];
      todayWeather = value[1];
      tomorrowTemp = value[2];
      sevenDay = value[3];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030317),
      body: currentTemp == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  CurrentWeather(getData),
                  // TodayWeather(),
                ],
              ),
            ),
    );
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  CurrentWeather(this.updateData);
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');

  @override
  Widget build(BuildContext context) {
    if (currentTemp.name.toLowerCase() == "snow") {
      colorb = Color.fromARGB(255, 141, 231, 238);
      colora = Color.fromARGB(255, 6, 243, 239);
    } else if (currentTemp.current > 25) {
      colorb = Color.fromARGB(255, 244, 168, 27);
      colora = Color.fromARGB(255, 198, 56, 21);
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorb,
            colora,
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: searchBar
                        ? TextField(
                            focusNode: focusNode,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fillColor: Color(0xff030317),
                                filled: true,
                                hintText: "Enter a city Name"),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) async {
                              CityModel temp = await fetchCity(value);
                              if (temp == null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xff030317),
                                        title: Text("City not found"),
                                        content:
                                            Text("Please check the city name"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Ok"))
                                        ],
                                      );
                                    });
                                searchBar = false;
                                return;
                              }
                              city = temp.name;
                              lat = temp.lat;
                              lon = temp.lon;
                              updating = true;
                              setState(() {});
                              widget.updateData();
                              searchBar = false;
                              updating = false;
                              setState(() {});
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_pin, color: Colors.white),
                                  GestureDetector(
                                    onTap: () {
                                      searchBar = true;
                                      setState(() {});
                                      focusNode.requestFocus();
                                    },
                                    child: Text(
                                      " " + city,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.expand_circle_down,
                                  color: Colors.white)
                            ],
                          ),
                  ),
                ],
              ),
            ),
            Container(
              child: Stack(children: [
                Image(
                  image: AssetImage(currentTemp.image),
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          currentTemp.name,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Text(
                          currentTemp.current.toString() + '\u00B0',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 100,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.wind_power_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    currentTemp.wind.toString() + " Km/h",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.water_drop_outlined,
                                    size: 30,
                                  ),
                                  Text(
                                    currentTemp.wind.toString() + " %",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.thunderstorm,
                                    size: 30,
                                  ),
                                  Text(
                                    currentTemp.chanceRain.toString() + " %",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today " + currentTemp.day,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return DetailPage(tomorrowTemp, sevenDay);
                          }));
                        },
                        child: Row(
                          children: [
                            Text(
                              "7 days ",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey,
                              size: 15,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeatherWidget(todayWeather[0]),
                          WeatherWidget(todayWeather[1]),
                          WeatherWidget(todayWeather[2]),
                        ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  WeatherWidget(this.weather);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Color.fromARGB(107, 255, 255, 255),
          border: Border.all(width: 0.2, color: Colors.white),
          borderRadius: BorderRadius.circular(35)),
      child: Column(
        children: [
          Text(
            weather.time,
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(
            height: 5,
          ),
          Image(
            image: AssetImage(weather.image),
            width: 50,
            height: 50,
          ),
          Text(
            weather.current.toString() + "\u00B0",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
