import 'package:flutter/material.dart';

import '../../style/style.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Email Address',
              style: Heading1(colorDarkBlue),
            ),
            const SizedBox(height: 8),
            const Text(
                'A 6 digit verification pin will send to your email address'),
            const SizedBox(height: 20),
            TextFormField(
              decoration: AppInputDecoration('Email Address'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: AppButtonStyle(),
              child: SuccessButtonChild('Next'),
            ),
            const SizedBox(height: 24),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have account?'),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'SIgn in',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
