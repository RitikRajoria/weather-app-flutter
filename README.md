# Weather App Flutter

A Flutter application to view current weather status and 5 day weather forecast.

<img src="https://github.com/RitikRajoria/weather-app-flutter/blob/main/App%20Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20-%202022-06-29%20at%2021.51.30.png?raw=true" width=35% height=50%/>
<img src="https://github.com/RitikRajoria/weather-app-flutter/blob/main/App%20Screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20-%202022-06-29%20at%2021.57.09.png?raw=true" width=35% height=50%/>.

### Prerequisites

**Flutter**

- [Flutter documentation](https://flutter.dev/docs)
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)


## About App

The app utilises [OpenWeatherMap API](https://openweathermap.org/api) and shows users current
weather forecasts on the user's locations or for the searched
locations. This App also shows you the five-day weather
forecast.


## Supported Features

- :white_check_mark: Current weather (condition and temperature)
- :white_check_mark: 5-day weather forecast
- :white_check_mark: Search by city

## Packages in use

- [geolocator](https://pub.dev/packages/geolocator) for getting location.
- [geocoding](https://pub.dev/packages/geocoding) for permission to access device's location.
- [http](https://pub.dev/packages/http) for talking to the REST API.
- [intl](https://pub.dev/packages/intl) for date and time formating.

## About the OpenStreetMap weather API

The app shows data from the following endpoints:

- [Current Weather Data](https://openweathermap.org/current)
- [Weather Fields in API Response](https://openweathermap.org/current#parameter)
- [5 day weather forecast](https://openweathermap.org/forecast5)
- [Weather Conditions](https://openweathermap.org/weather-conditions)

**Note**: to use the API you'll need to register an account and obtain your own API key.

