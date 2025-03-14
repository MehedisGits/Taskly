import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  final int length;
  final TextEditingController controller;

  const OtpField({
    required this.length,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        length,
        (index) => SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
