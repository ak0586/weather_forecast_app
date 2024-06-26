import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final text = 'PlaywriteNGModernRegular';
  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style:  TextStyle(
                fontFamily: text,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$value ',
            style:  TextStyle(
                  fontFamily: text,
                ),
          ),
        ],
      ),
    );
  }
}
