import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/data_services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchText = TextEditingController();
  final _dataService = DataService();

  String currentDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  WeatherResponse? _response;

  List<int> indexes = [];
  List<String> dates = [];
  String? formattedDate;
  int uiChanger =
      0; // 0 => search city name, 1=> got data, 2=> wrong city name, 3=> server error

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  height: (size.height) * 0.4,
                  width: (size.width) * 0.9,
                  child: uiChanger == 0
                      ? Container(
                          height: (size.height) * 0.4,
                          width: (size.width) * 0.9,
                          child: Center(
                            child: Text(
                              "SEARCH CITY",
                              style: TextStyle(
                                  fontSize: 26,
                                  letterSpacing: 1.7,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : uiChanger == 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${_response!.city!.name}',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '${_response!.list![0].main!.temp} °C',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset(
                                          "assets/images/weather_icons/${_response!.list![0].weather![0].icon}.png")),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      height: 35,
                                      child: Text(
                                        '5-Days Forecast',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: indexes.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String? iconsId = _response!
                                            .list![indexes[index]]
                                            .weather![0]
                                            .icon;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 3,
                                              right: 3),
                                          child: Container(
                                            height: (size.width) * 0.4,
                                            width: (size.width) * 0.5,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              border: Border.all(
                                                  width: 0.7,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('${dates[index]}',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                    '${_response!.list![indexes[index]].main!.temp} °C',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                //icon
                                                Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Image.asset(
                                                        "assets/images/weather_icons/${iconsId}.png")),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          : uiChanger == 2
                              ? Container(
                                  height: (size.height) * 0.4,
                                  width: (size.width) * 0.9,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "SEARCH CITY",
                                          style: TextStyle(
                                              fontSize: 26,
                                              letterSpacing: 1.7,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 18,
                                        ),
                                        Text(
                                            "Enter Correct City Name or Check For Spelling Mistake!"),
                                      ],
                                    ),
                                  ),
                                )
                              : Text("Internal Server Error"),
                )),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Container(
                    width: (size.width) * 0.6,
                    height: 50,
                    child: TextFormField(
                      controller: searchText,
                      decoration: InputDecoration(
                        labelText: 'City',
                        hintText: 'Enter City Name',
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (searchText.text != "" &&
                        !searchText.text.contains(" ")) {
                      _search();
                    }
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    _response = null;
    final response = await _dataService.getWeather(searchText.text);

    indexes = [];
    dates = [];
    DateTime date;
    _response = response;
    setState(() {
      if (_response!.cod == "200") {
        uiChanger = 1;
      } else if (_response!.cod == "404") {
        uiChanger = 2;
      } else {
        print("unknown error occured");
        uiChanger = 3;
      }
    });
    setState(() {
      _response = response;

      for (int i = 0; i < _response!.list!.length; i++) {
        if (_response!.list![i].dtTxt!.contains('12:00:00')) {
          indexes.add(i);
          date = DateTime.parse('${_response!.list![i].dtTxt}');
          formattedDate = DateFormat('dd/MM, EEE').format(date);
          dates.add(formattedDate!);
        }
      }
    });
  }
}
