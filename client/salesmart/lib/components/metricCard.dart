import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final String value;
  final double width;
  final double height;
  final Color color;

  MetricCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.width = 200,
    this.height = 140,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            Text(
              value,
              style: GoogleFonts.anton(
                fontSize: 19,
                color: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 87, 85, 85),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
