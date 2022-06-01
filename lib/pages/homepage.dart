import 'package:flutter/material.dart';
import 'package:weather_app/services/data_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchText = TextEditingController();
  final _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              onPressed: _search,
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    final response = await _dataService.getWeather(searchText.text);
    print(response.city!.name);
  }
}
