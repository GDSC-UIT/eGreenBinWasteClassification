import 'package:egreenbin_waste_classification/data/data.dart';
import 'package:flutter/cupertino.dart';

class ResultContent extends StatelessWidget {
  final String label;
  ResultContent({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xff99BF6F),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        RichText(
          text: TextSpan(
              text: "Derived from: ",
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: data[label]!["derived"],
                  style: const TextStyle(
                    color: Color.fromARGB(255, 40, 40, 40),
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                )
              ]),
        ),
        const SizedBox(
          height: 4,
        ),
        RichText(
          text: const TextSpan(
              text: "How to recycle: ",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF000000),
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "Use it as",
                  style: TextStyle(
                    color: Color.fromARGB(255, 40, 40, 40),
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                )
              ]),
        ),
        const SizedBox(
          height: 4,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data[label]!["recycle"].map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text("- $item"),
            );
          }).toList(),
        )
      ],
    );
  }
}
