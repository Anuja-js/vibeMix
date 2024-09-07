import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/icon_images.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/models/audio_player_model.dart';
import 'package:vibemix/models/box.dart';
import 'package:vibemix/screens/library/mymusic.dart';

import '../customs/container_custom.dart';
import '../customs/list_of_allsongs.dart';
import '../customs/listtile_custom.dart';
import '../global.dart';
import '../models/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "Guest";
  bool _hasPermission = false;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  Box<SongHiveModel>? songsBox;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    getname();
    checkAndRequestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
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
                    child: IconImage(
                      height: 125,
                      width: 90,
                    )),
                UserImageAndName(name: name),
                sh25,
                const ContainerForSearch(),
                sh25,
                ListTileCustom(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return const MyMusic();
                    }));
                  },
                  trailing: "See all",
                  tittle: "My Music",
                ),
                if (_hasPermission)
                  if (songsBox == null || songsBox!.length == 0)
                    TextCustom(
                      text: "Songs Not found", color: foreground,
                    ),
                if (_hasPermission && songsBox != null)
                  ListOfMusic(
                      songsBox: songsBox,
                      count: songsBox!.length > 5 ? 5 : songsBox!.length)
              ],
            ),
          ),
        ),
      ),
      appBar: false,
      action: false,
    );
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if (_hasPermission) {
     await getHiveMusic();
      AudioPlayerSingleton().setCurrentPlaylist("songs");
      setState(() {});
    } else {}
  }

  getHiveMusic() async {
    songsBox = await HiveService.getSongsBox();
    List<SongModel> information = await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for (int i = 0; i < information.length; i++) {
      songsBox!.put(
          information[i].id,
          SongHiveModel(
              id: information[i].id,
              displayNameWOExt: information[i].displayNameWOExt,
              artist: information[i].artist,
              uri: information[i].uri));
    }
    setState(() {});
  }

  void getname() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPrefs.getString("name") ?? "Guest";
    });
  }
}

class UserImageAndName extends StatefulWidget {
  const UserImageAndName({
    super.key,
    required this.name,
    this.imageFile,
  });

  final String name;
  final File? imageFile;

  @override
  State<UserImageAndName> createState() => _UserImageAndNameState();
}

class _UserImageAndNameState extends State<UserImageAndName> {
  File? imageFile;

  @override
  void initState() {
    super.initState();
    loadImage();
    imageFile = widget.imageFile;
  }

  @override
  void didUpdateWidget(covariant UserImageAndName oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageFile != oldWidget.imageFile) {
      setState(() {
        imageFile = widget.imageFile;
      });
    }
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('user_image_path');
    if (imagePath != null) {
      setState(() {
        imageFile = File(imagePath);
      });
    }
  }

  Future<void> saveImagePathToPreferences(File image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image_path', image.path);
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      await saveImagePathToPreferences(imageFile!);
    }
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: TextCustom(text: 'Camera', color: background),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: TextCustom(text: 'Gallery', color: background),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: imageFile != null
                  ? FileImage(imageFile!)
                  : const AssetImage("assets/images/profile.png")
                      as ImageProvider,
            ),
            const SizedBox(width: 15),
            Text.rich(
              TextSpan(
                text: "Hi There,\n",
                style:  TextStyle(
                  color: textPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                children: [
                  TextSpan(
                    text: widget.name,
                    style:  TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 18,
          left: 30,
          child: IconButton(
            onPressed: showImageSourceDialog,
            icon: const Icon(Icons.camera_alt_outlined),
            color: foreground,
          ),
        ),
      ],
    );
  }
}
