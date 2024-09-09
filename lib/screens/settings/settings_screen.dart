import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/main.dart';
import 'package:vibemix/screens/onboarding/onboarding_secsion.dart';
import 'package:vibemix/screens/terms_screen.dart';
import 'package:vibemix/utils/color_notifier.dart';

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
                child: CircleAvatar(radius: 10, backgroundColor: textPink),
              ),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Accent Colour",
              ),
              onTap: (){
                showAccentColor(context);
              },
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
            await   Hive.deleteBoxFromDisk('fav');
                await    Hive.deleteBoxFromDisk('songs');
                await   Hive.deleteBoxFromDisk('playlists');
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
  showAccentColor(ctx){
    showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2,maxWidth: MediaQuery.of(context).size.width),
        context: ctx, builder: (BuildContext ctx){

      return Container(color: foreground,
        height:  MediaQuery.of(context).size.height/2,width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 18),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextCustom(color: background, text: "Choose Accent Color",fontWeight: FontWeight.bold,size: 20,),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close_rounded,color: background,))
              ],

            ),sh10,
            InkWell(onTap: (){
              AccentNotifier().notifier.value=!AccentNotifier().notifier.value;
              textPink=Colors.blue;
              setState(() {

              });
              updateColor(Colors.blue);
              Navigator.pop(context);
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 6, backgroundColor: Colors.blue),sw10,
                    TextCustom(color: Colors.blue, text: "Blue",size: 18,),
                    Spacer(),
                    textPink==Colors.blue?
                    Icon(Icons.check_rounded,color: background,):sh10

                  ],
                ),
            ),   Divider(height: 15,),  InkWell(onTap: (){
              AccentNotifier().notifier.value=!AccentNotifier().notifier.value;
              textPink=Colors.red;
              setState(() {

              });
              updateColor(Colors.red);
              Navigator.pop(context);
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 6, backgroundColor: Colors.red),sw10,
                    TextCustom(color: Colors.red, text: "Red",size: 18,),
                    Spacer(),
                    textPink==Colors.red?
                    Icon(Icons.check_rounded,color: background,):sh10

                  ],
                ),
            ),Divider(height: 15,),
            InkWell(onTap: (){
              AccentNotifier().notifier.value=!AccentNotifier().notifier.value;
              textPink=Colors.green;
              setState(() {

              });
              updateColor(Colors.green);
              Navigator.pop(context);
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 6, backgroundColor: Colors.green),sw10,
                  TextCustom(color: Colors.green, text: "Green",size: 18,),
                  Spacer(),
                  textPink==Colors.green?
                  Icon(Icons.check_rounded,color: background,):sh10

                ],
              ),
            ),
            Divider(height: 15,),
            InkWell(onTap: (){
              AccentNotifier().notifier.value=!AccentNotifier().notifier.value;
              textPink=Color(0xffE07373);
              setState(() {

              });
              updateColor(Color(0xffE07373));
              Navigator.pop(context);
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 6, backgroundColor: Color(0xffE07373)),sw10,
                  TextCustom(color: Color(0xffE07373), text: "Default Color",size: 18,),
                  Spacer(),
                  textPink==Color(0xffE07373)?
                  Icon(Icons.check_rounded,color: background,):sh10

                ],
              ),
            ),
            Divider(height: 15,),
            InkWell(onTap: (){
              AccentNotifier().notifier.value=!AccentNotifier().notifier.value;
              textPink=Colors.purple;
              setState(() {

              });
              updateColor(Colors.purple);
              Navigator.pop(context);
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 6, backgroundColor: Colors.purple),sw10,
                  TextCustom(color: Colors.purple, text: "Purple",size: 18,),
                  Spacer(),
                  textPink==Colors.purple?
                  Icon(Icons.check_rounded,color: background,):sh10

                ],
              ),
            ),
            Divider(height: 15,),
          ],
        ),
      );
    });
  }
  Future<void> updateColor(Color color)async{
    final shared =await SharedPreferences.getInstance();
    if(color==Colors.blue){
      shared.setString("accent", "blue");
    }
    if(color==Colors.red){
      shared.setString("accent", "red");
    }if(color==Colors.green){
      shared.setString("accent", "green");
    }if(color==const Color(0xffE07373)){
      shared.setString("accent", "0xffE07373");
    }if(color== Colors.purple){
      shared.setString("accent", "purple");
    }
  }
}
