import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData? icon;
  final String temp;
  final text = 'PlaywriteNGModernRegular';
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      //color: const Color.fromARGB(255, 60, 60, 60),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                  //color: Colors.white, 
                  fontFamily: text,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 5,
            ),
            Icon(
              icon,
              size: 50,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(temp,
                style: TextStyle(
                   
                    fontFamily: text,)),
          ],
        ),
      ),
    );
  }
}
