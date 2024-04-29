import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weatherapp/components/home_card.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading = true;
  Map<String, dynamic> res = {};
  String imageUrl = 'images/1.png';

  @override
  void initState() {
    getData();
    super.initState();
  }

  String getWeatherIcon(weatherType) {
    switch (weatherType) {
      case 'Clear':
        setState(() {
          imageUrl = 'images/1.png';
        });
        break;
      case 'Sunny':
        setState(() {
          imageUrl = 'images/2.png';
        });
        break;
      case 'Haze':
        setState(() {
          imageUrl = 'images/3.png';
        });
        break;
      case 'Partly Cloudy':
        setState(() {
          imageUrl = 'images/4.png';
        });
        break;
      default:
        setState(() {
          imageUrl = 'images/5.png';
        });
    }
    return imageUrl;
  }

  void getData() async {
    isloading = true;
    final String url = 'https://yahoo-weather5.p.rapidapi.com/weather';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': 'f45d8848eamshad6366977ca5fe3p1c8858jsnb2a47996e921',
      'X-RapidAPI-Host': 'yahoo-weather5.p.rapidapi.com'
    };
    final Map<String, String> params = {'location': 'karachi', 'u': 'c'};

    Uri uri = Uri.parse(url);
    uri = uri.replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: headers);
      res = await json.decode(response.body);

      if (res.isNotEmpty) {
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isloading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: isloading
            ? Column(
                children: [
                  Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ))
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(105, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      onChanged: (query) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Store",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${res['location']['city']}, ${res['location']['country']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    res['location']['timezone_id'],
                    style: TextStyle(
                      color: const Color.fromARGB(255, 208, 208, 208),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    height: 85,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${res['current_observation']['condition']['temperature']}'",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 75,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          res['current_observation']['condition']['text'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      getWeatherIcon(
                          res['current_observation']['condition']['text']),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          res['current_observation']['atmosphere'].length,
                      itemBuilder: (context, index) {
                        return HomeCard(
                          name: res['current_observation']['atmosphere']
                              .keys
                              .toList()[index],
                          value: res['current_observation']['atmosphere'][
                              res['current_observation']['atmosphere']
                                  .keys
                                  .toList()[index]],
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(
                          width: 1, color: Color.fromARGB(52, 255, 255, 255)),
                    )),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: res['forecasts'].map<Widget>((item) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(115, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  getWeatherIcon(item['text']),
                                  height: 50,
                                ),
                                Text(
                                  item['day'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
      ),
    ));
  }
}
