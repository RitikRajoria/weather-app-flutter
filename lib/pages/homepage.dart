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
                  height: (size.height) * 0.5,
                  width: (size.width) * 0.6,
                  color: Colors.red,
                  child: _response == null
                      ? Container(
                          height: (size.height) * 0.5,
                          width: (size.width) * 0.6,
                          color: Colors.yellow,
                        )
                      : Padding(
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
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: indexes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      children: [
                                        Text('${dates[index]}',
                                            style: TextStyle(fontSize: 18)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                            '${_response!.list![indexes[index]].main!.temp}',
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                )),
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
                ElevatedButton(
                  onPressed: () {
                    print(currentDate);
                  },
                  child: Text('xxxx'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _search() async {
    final response = await _dataService.getWeather(searchText.text);
    indexes = [];
    dates = [];
    DateTime date;

    setState(() {
      _response = response;

      for (int i = 0; i < _response!.list!.length; i++) {
        if (_response!.list![i].dtTxt!.contains('12:00:00')) {
          indexes.add(i);
          date = DateTime.parse('${_response!.list![i].dtTxt}');
          formattedDate = DateFormat('MM-dd').format(date);
          dates.add(formattedDate!);
        }
      }
    });
  }
}
