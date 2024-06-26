import 'dart:convert';
// import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'AdditionalInfoWidget.dart';
import 'HourlyForecastItem.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatefulWidget {
  const MyWeatherApp({super.key});

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  late Future<Map<String, dynamic>> weather;
  final text = 'PlaywriteNGModernRegular';
  final TextEditingController textEditingController = TextEditingController();
  String cityName = 'Delhi';
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      if (textEditingController.text.isNotEmpty) {
        cityName = textEditingController.text;
      } else {
        cityName = 'Delhi';
      }

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode != 200) {
        //throw data['message'];// it will show the error message what type of error occured
        throw 'Unexpected  Error Occured'; //
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: appBar(),
      // function is created below
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: weather,
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator
                          .adaptive()); //adaptive is used to show the indicator as pr the operating system IOS or Android
                }
                if (snapshot.hasError) {
                  //it will display the error on the screen whenever snapshot has an error, other then this nothing will show
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.white, fontFamily: text),
                    ),
                  );
                }

                final data = snapshot.data!;
                final currentWeatherData =
                    data['list'][0]; // these data are coming from the API
                final currentTemp = currentWeatherData['main']['temp'] -
                    273.15; //  values are accessing from the ApI
                final currentSky = currentWeatherData['weather'][0]['main'];
                final currentPressure = currentWeatherData['main']['pressure'];
                final currentHumidity = currentWeatherData['main']['humidity'];
                final currentWindSpeed = currentWeatherData['wind']['speed'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      //for the textfield to  get city name

                      textFieldOkButtonCityName(),

                      const SizedBox(height: 20),
                      mainForecastWidget(currentTemp, currentSky),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Hourly Forecast',
                            style: TextStyle(
                                fontFamily: text,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      /* //weather forecast cards
                      SingleChildScrollView(  //below we are using listview.builder instead of this singlechildscrollview
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 1; i <= 8; i++)
                              HourlyForecastItem(
                                time: data['list'][i]['dt_txt'].toString(),
                                icon: data['list'][i]['weather'][0]['main'] ==
                                            'Clouds' ||
                                        data['list'][i]['weather'][0]['main'] ==
                                            'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                temp:
                                    '${data['list'][i]['main']['temp'].toString()} K',
                              ),
                          ],
                        ),
                      ),*/

                      hourlyForecastWidget(data),

                      //forecast cards),

                      const SizedBox(
                        height: 20,
                      ),
                      //additional information
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Additional Information',
                            style: TextStyle(
                                fontFamily: text,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      additionalInformation(
                          currentHumidity, currentWindSpeed, currentPressure)
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Row additionalInformation(
      currentHumidity, currentWindSpeed, currentPressure) {
    /// Returns a `Row` widget containing three `AdditionalInfo` widgets, each representing
    /// humidity, wind speed, and pressure information respectively. The `AdditionalInfo`
    /// widgets are aligned evenly across the row and have icons, labels, and values that
    /// are derived from the provided `currentHumidity`, `currentWindSpeed`, and `currentPressure`
    /// parameters.
    ///
    /// Parameters:
    /// - `currentHumidity`: The current humidity value.
    /// - `currentWindSpeed`: The current wind speed value.
    /// - `currentPressure`: The current pressure value.
    ///
    /// Returns:
    /// A `Row` widget containing three `AdditionalInfo` widgets.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AdditionalInfo(
            icon: Icons.water_drop,
            label: 'Humidity',
            value: '${currentHumidity.toString()} %'),
        AdditionalInfo(
          icon: Icons.air,
          label: 'WindSpeed',
          value: '${currentWindSpeed.toString()} m/h',
        ),
        AdditionalInfo(
          icon: Icons.speed,
          label: 'Pressure',
          value: '${currentPressure.toString()} hPa',
        ),
      ],
    );
  }

  SizedBox hourlyForecastWidget(Map<String, dynamic> data) {
    /// Builds a [SizedBox] widget that displays a horizontal scrollable list of
    /// hourly forecasts.
    ///
    /// The [data] parameter is a [Map] containing the hourly forecast data.
    /// /// Returns a [SizedBox] widget with a height of 140 and a child [ListView.builder]
    /// that displays a horizontal scrollable list of [HourlyForecastItem] widgets.
    /// The number of items in the list is determined by the length of the 'list'
    /// field in the [data] parameter, which is 39. Each item in the list is built
    /// using the [itemBuilder] callback. The [itemBuilder] callback retrieves the
    /// hourly forecast data for the current index and builds a [HourlyForecastItem]
    /// widget with the time, icon, and temperature information. The time is formatted
    /// using [DateFormat.j] and the temperature is calculated by subtracting 273.15
    /// from the 'temp' field of the hourly forecast data. The icon is determined based
    ///   /// on the value of the 'main' field of the first weather element in the hourly
    /// forecast data. If the value is either 'Clouds' or 'Rain', the icon is set to
    /// [Icons.cloud], otherwise it is set to [Icons.sunny].
    return SizedBox(
      height: 140,
      child: ListView.builder(
          //listview builder also start from index 0
          itemCount: 39,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final hourlyForecast = data['list'][index + 1];
            final hourlySky = data['list'][index + 1]['weather'][0]['main'];
            final time = DateTime.parse(hourlyForecast['dt_txt']);
            return HourlyForecastItem(
              time: DateFormat.j().format(time),
              icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                  ? Icons.cloud
                  : Icons.sunny,
              temp:
                  '${(hourlyForecast['main']['temp'] - 273.15).toStringAsFixed(1)} C',
            );
          }),
    );
  }

  SizedBox mainForecastWidget(currentTemp, currentSky) {
    /// Returns a [SizedBox] widget that displays the current temperature and weather
    /// condition in a card with a blurred background.
    ///
    /// The [currentTemp] parameter is the current temperature in Celsius.
    /// The [currentSky] parameter is the current weather condition, which can be either
    /// 'Clouds' or 'Rain'.
    ///
    /// The returned [SizedBox] widget has a width of `double.infinity` and contains a
    /// [Card] widget with an elevation of 15 and a rounded border radius of 20. The card
    /// has a blurred background using a [BackdropFilter] widget with a [ImageFilter.blur]
    /// filter. The card's child is a [Padding] widget with padding of 20 on all sides.
    /// The child is a [Column] widget with a main axis alignment of
    /// [MainAxisAlignment.spaceEvenly]. The column contains three children: a [Text]
    /// widget displaying the current temperature, an [Icon] widget displaying the
    /// appropriate weather icon based on the current weather condition, and another
    /// [Text] widget displaying the current weather condition.
    ///
    /// The [Text] widgets use the [fontFamily] 'text' and have a font size of 32 for
    /// the temperature and 20 for the weather condition. The [Text] widgets have a
    /// [fontWeight] of [FontWeight.bold]. The [Icon] widget has a size of 55 and
    /// displays the appropriate weather icon based on the current weather condition.
    ///
    /// Returns a [SizedBox] widget.
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          //color: const Color.fromARGB(255, 60, 60, 60),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${currentTemp.toStringAsFixed(1)} C',
                      style: TextStyle(
                        fontFamily: text,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      currentSky == 'Clouds' || currentSky == 'Rain'
                          ? Icons.cloud
                          : Icons.sunny,
                      size: 55,
                      //color: Colors.white
                    ),
                    Text(currentSky,
                        style: TextStyle(
                            fontFamily: text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Row textFieldOkButtonCityName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
              controller: textEditingController,
              //onSubmitted: (value) => result = double.parse(value),
              scrollPadding: const EdgeInsets.all(20.0),
              keyboardType: TextInputType.name,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: text,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                // contentPadding:
                //     const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                hintText: 'City name',
                hintStyle: TextStyle(color: Colors.black, fontFamily: text),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 5,
                  ),
                ),
              )),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            setState(() {
              weather = getCurrentWeather();
            });
          },
          //instead of ButtonStyle, we can use TextButton.styleFrom
          style: ButtonStyle(
            // minimumSize: MaterialStatePropertyAll(),
            backgroundColor: MaterialStateProperty.all(Colors.black87),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            // minimumSize: const MaterialStatePropertyAll(
            //   Size(100, 50),
            // ),
            shape: MaterialStateProperty.all(
              const StadiumBorder(
                side: BorderSide(
                    style: BorderStyle.solid, width: 5, color: Colors.blue),
              ),
            ),
          ),

          child: const Text(
            'OK',
            //style: TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          // width: 100,
          child: Text(
            cityName,
            style:  TextStyle(fontWeight: FontWeight.bold,fontFamily: text),
          ),
        ),
      ],
    );
  }

  AppBar appBar() {
    /// Returns an [AppBar] widget with a customized toolbar height, title, and actions.
    ///
    /// The toolbar height is set to 40. The title is a [Text] widget with a font size of 20,
    /// cyan accent color, and a custom font family. The title is centered.
    ///
    /// The actions include an [IconButton] with an onPressed callback that updates the
    /// weather data by calling the [getCurrentWeather] method. The icon for the button
    /// is an [Icon] widget with the refresh icon.
    ///
    /// The background color of the app bar is not set.
    ///
    /// The shape of the app bar is a [RoundedRectangleBorder] with a vertical border radius
    /// of 15 at the bottom.
    ///
    /// Returns an [AppBar] widget.
    return AppBar(
      toolbarHeight: 40,

      title: Text(
        'Weather App',
        style:
            TextStyle(fontSize: 20, color: Colors.cyanAccent, fontFamily: text),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              weather = getCurrentWeather();
            });
          },
          icon: const Icon(Icons.refresh),
        )

        //instead of InkWell we can also use gestureDector(), but InkeWell have property of splsh when we click on icon
        /*InkWell(
          child: const Icon(Icons.refresh),
          onTap: () {
            print("refresh");
          },
        ),
          */
      ],
      // backgroundColor: const Color.fromARGB(255, 5, 5, 5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
    );
  }
}
