import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/main.dart';
import 'package:vibemix/screens/onboarding/onboarding_secsion.dart';
import 'package:vibemix/screens/terms_screen.dart';

import '../../customs/text_custom.dart';
import '../../global.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String userName = "Guest";

  @override
  void initState() {
    loadUserName();
    super.initState();
  }

  Future<void> loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? "Guest"; // Default name
    });
  }
  Future<void> saveUserName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }
  Future<void> setDarkMode()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("dark", true);
  }
  Future<void> setWhiteMode()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark", false);
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Settings",
      backButton: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
        child: Column(
          children: [
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.edit, size: 20, color: foreground),
                onPressed: () => editName(context), // Edit name button
              ),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: userName,
              ),
            ),
            ListTile(
              trailing: Switch(
                value: !dark,
                activeColor: foreground,
                inactiveTrackColor: textPink,
                inactiveThumbColor: foreground,
                activeTrackColor: textPink,
                onChanged: (bool value) {
                  setState(() {
                   dark=!dark;
                  if(dark==true){
                    setDarkMode();
                    background=Colors.black;
                    foreground=Colors.white;
                  } else{
                    setWhiteMode();
                    foreground=Colors.black;
                    background=Colors.white;
                  }

                  });
                },
              ),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "White Theme",
              ),
            ),
            ListTile(
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 30,
                  maxWidth: 60,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 6, backgroundColor: textPink),
                    sw10,
                    TextCustom(
                      color: textPink,
                      size: 18,
                      fontWeight: FontWeight.normal,
                      text: "Red",
                    ),
                  ],
                ),
              ),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Accent Colour",
              ),
            ),
            ListTile(
              trailing: Icon(Icons.arrow_forward_ios_outlined,
                  size: 20, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Terms and Conditions",
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return TermsAndCondition();
                }));
              },
            ),
            ListTile(
              trailing:  Icon(Icons.arrow_forward_ios_outlined,
                  size: 20, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Logout",
              ),
              onTap: () {
                logout(context);
              },
            ),
          ],
        ),
      ),
      appBar: true,
      actionIcon:  Icon(Icons.arrow_back_ios_outlined,
          size: 25, color: foreground),
      action: false,
    );
  }

  void editName(BuildContext context) {
    TextEditingController _controller = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Edit Name"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userName = _controller.text; // Update the name
                });
                saveUserName(userName); // Save to SharedPreferences
                Navigator.of(ctx).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Logout function
  logout(BuildContext ctx) async {
    final sharedprfs = await SharedPreferences.getInstance();
    showDialog(
      context: ctx,
      builder: (ctx1) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to logout......?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx1).pop();
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () async {
                await sharedprfs.clear();
                Navigator.of(ctx).pushReplacement(
                  MaterialPageRoute(builder: (ctx1) => OnboardingScreen()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
