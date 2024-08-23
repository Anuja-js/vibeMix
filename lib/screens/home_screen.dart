import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/screens/mymusic.dart';
import 'package:vibemix/screens/search_music.dart';


class HomeScreen extends StatefulWidget {
   const HomeScreen({Key? key,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name="Guest";
  bool _hasPermission=false;
  //use to fetch the audio from audio folder
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    getname();
    checkAndRequestPermissions();
   super.initState();
  }
  //pass default parameter
  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if (_hasPermission) {
      setState(() {});
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
        tittle: "",
        backButton: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 125,
                      width: 90,
                    ),
                  ),
                  Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Image.asset(
                            "assets/images/profile.png",
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        sw15,
                          Text.rich(
                          TextSpan(
                            text: "Hi There,\n",
                            style: const TextStyle(
                                color: textPink,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            children: <TextSpan>[
                              TextSpan(
                                text:name,
                                style: const TextStyle(
                                    color: foreground,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        top: 18,
                        left: 30,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt_outlined),
                          color: foreground,
                        ))
                  ]),
                  sh25,
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: textPink,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40e07373),
                            spreadRadius: 4,
                            blurRadius: 3,
                            offset: Offset(1, 3),
                          ),
                          BoxShadow(
                            color: Color(0x40e07373),
                            spreadRadius: 4,
                            blurRadius: 3,
                            offset: Offset(-1, -3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: TextCustom(
                            color: background,
                            size: 14,
                            fontWeight: FontWeight.bold,
                            text: "Search for anything ..."),
                        trailing: const Icon(
                          Icons.search,
                          color: background,
                          size: 20,
                        ),
                        onTap:() {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) {
                                return const SearchMusic();
                              }));

                        }
                      )

                      ),
                  sh25,

                  ListTile(onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return const MyMusic();
                        }));
                  },
                    title:  TextCustom(
                          color: foreground,
                          size: 18,
                          fontWeight: FontWeight.bold,
                          text: "My Music"),
                    trailing:  Row(mainAxisSize: MainAxisSize.min,
                      children: [
                        TextCustom(
                            color: foreground,
                            size: 12,
                            fontWeight: FontWeight.normal,
                            text: "See all"),
                        sw10,
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: foreground,
                          size: 15,
                        )
                      ],
                    ),

                  ),
                  if (_hasPermission)
              FutureBuilder(
                future: _audioQuery.querySongs(
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  //assume A=a
                  ignoreCase: true,
                ),
                builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: TextCustom(
                        color: foreground,
                        size: 20,
                        fontWeight: FontWeight.bold,
                        text: "Error: ${snapshot.error}",
                      ),
                    );
                  }
                  //waiting for the data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: TextCustom(
                        color: foreground,
                        size: 20,
                        fontWeight: FontWeight.bold,
                        text: "No Songs found",
                      ),
                    );
                  }

                  // Data present
                  if (snapshot.hasData && snapshot.data!.isNotEmpty ){
                     return  SizedBox(
                      width: double.infinity,
                     height: 500,
                      child: ListView.builder(padding: const EdgeInsets.only(bottom: 55),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: snapshot.data!.length>=10?10:snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return MusicWidget(
                            data: snapshot.data![index],
                          );
                        },
                      ),
                    );
                  }
                 return const SizedBox();
                },
              )
              ],
              ),
            ),
          ),
        ),
        appBar: false);
  }
  void getname() async {
    final sharedprfs = await SharedPreferences.getInstance();
    name=sharedprfs.getString("name")?? "Guest";
  }
}



// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Expanded(
//         child: TextCustom(
//             color: foreground,
//             size: 18,
//             fontWeight: FontWeight.bold,
//             text: "Favorites Songs")),
//     TextCustom(
//         color: foreground,
//         size: 12,
//         fontWeight: FontWeight.normal,
//         text: "See all"),
//     sw10,
//     const Icon(
//       Icons.arrow_forward_ios,
//       color: foreground,
//       size: 15,
//     )
//   ],
// ),
// SizedBox(
//   height: 160,
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemCount: 10,
//     itemBuilder: (context, index) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(
//             horizontal: 8.0, vertical: 15),
//         child: Column(
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: const DecorationImage(
//                   image:
//                       AssetImage('assets/images/music.png'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             sh10,
//             TextCustom(
//               color: foreground,
//               size: 15,
//               fontWeight: FontWeight.bold,
//               text: 'Flower',
//               align: TextAlign.center,
//             ),
//             TextCustom(
//               color: foreground,
//               size: 13,
//               fontWeight: FontWeight.w200,
//               text: 'Post Melon',
//               align: TextAlign.center,
//             )
//           ],
//         ),
//       );
//     },
//   ),
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Expanded(
//         child: TextCustom(
//             color: foreground,
//             size: 18,
//             fontWeight: FontWeight.bold,
//             text: "Recently Played")),
//     TextCustom(
//         color: foreground,
//         size: 12,
//         fontWeight: FontWeight.normal,
//         text: "See all"),
//     sw10,
//     const Icon(
//       Icons.arrow_forward_ios,
//       color: foreground,
//       size: 15,
//     )
//   ],
// ),
