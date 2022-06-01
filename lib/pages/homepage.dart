import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchText = TextEditingController();
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
              onPressed: () {},
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
