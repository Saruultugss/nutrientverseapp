import 'package:flutter/material.dart';

class NutrientBar extends StatelessWidget {
  final String nutrientName;
  final int percentage;
  final Color barColor;

  const NutrientBar(
      {Key? key,
      required this.percentage,
      required this.nutrientName,
      this.barColor: const Color(0xFFEF5350)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(alignment: Alignment.center, children: [
          Container(
            width: 30,
            height: 40,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 30,
              height: 40 -
                  (40 * percentage / 100 > 40 ? 40 : 40 * percentage / 100),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "$percentage%",
              style: TextStyle(fontSize: 9, color: Colors.white),
            ),
          ),
        ]),
        Text(
          nutrientName,
          style: TextStyle(fontSize: 9, color: Colors.white),
        )
      ],
    );
  }
}
