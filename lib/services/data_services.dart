import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class DataService {
  Future<WeatherResponse> getWeather(String cityName) async {
    //api.openweathermap.org/data/2.5/forecast?q=jaipur&appid=c2b900301d9a22da5a91350c675afc8f&units=metric

    final String apiKey = "c2b900301d9a22da5a91350c675afc8f";
    final String units = "metric";

    final query = {'q': cityName, 'appid': apiKey, 'units': units};

    final uri =
        Uri.https('api.openweathermap.org', '/data/2.5/forecast', query);

    final response = await http.get(uri);

    // log(response.body);

    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
