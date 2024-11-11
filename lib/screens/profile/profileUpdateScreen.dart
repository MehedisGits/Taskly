import 'package:flutter/material.dart';
import 'package:taskly/screens/widgets/tm_appBar.dart';
import 'package:taskly/style/style.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
/*  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _profileImage = File(pickedFile!.path);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(),
      body: Stack(children: [
        ScreenBackground(context),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Profile',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Email"),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("First Name"),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Last Name"),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Mobile"),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Password"),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyle(),
                  child: SuccessButtonChild('Continue'),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
