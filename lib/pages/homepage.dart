import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/data_services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
  // 0 => search city name, 1=> got data, 2=> wrong city name, 3=> server error
  int uiChanger = 4;
  bool firstTime = false;
  var yourCity = "";
  SnackBar snackBar = SnackBar(
    content: Text('Remove extra spaces!'),
  );

  @override
  void initState() {
    super.initState();

    _determinePosition().then((value) {
      _getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                    child: uiChanger == 4
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : firstTime
                            ? Center(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : uiChanger == 0
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
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: indexes.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  String? iconsId = _response!
                                                      .list![indexes[index]]
                                                      .weather![0]
                                                      .icon;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            bottom: 8,
                                                            left: 3,
                                                            right: 3),
                                                    child: Container(
                                                      height:
                                                          (size.width) * 0.4,
                                                      width: (size.width) * 0.5,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
                                                        border: Border.all(
                                                            width: 0.7,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              '${dates[index]}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                              '${_response!.list![indexes[index]].main!.temp} °C',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18)),
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                        : Container(
                                            height: (size.height) * 0.4,
                                            width: (size.width) * 0.9,
                                            child: Text(
                                                "Internal Server Error, Try Again!")),
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
                      if (searchText.text[0] != " ") {
                        if (searchText.text.isNotEmpty) {
                          _search(searchText.text.trim());
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('Search'),
                  ),
                  Container(
                    width: (size.width) * 0.6,
                    child: ElevatedButton(
                      onPressed: () {
                        _determinePosition();
                        _getLocation();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location),
                          Text(
                            "  Use Current Location",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _search(String searchText) async {
    _response = null;
    firstTime = true;

    final response = await _dataService.getWeather(searchText);
    firstTime = false;

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

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> pm =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      yourCity = pm[0].locality.toString();
    });
    _search(yourCity);
    searchText.clear();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        uiChanger = 0;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          uiChanger = 0;
        });

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
