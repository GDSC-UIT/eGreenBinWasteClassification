import 'package:flutter/material.dart';

class ProcessContent extends StatelessWidget {
  const ProcessContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          "eGreenBin",
          style: TextStyle(
            color: Color(0xFF559360),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          "The process may take some minutes. Please wait a moment to receive the results.",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        SizedBox(
          height: 12,
        ),
        CircularProgressIndicator(
          color: Color(0xff99BF6F),
        ),
      ],
    );
  }
}
