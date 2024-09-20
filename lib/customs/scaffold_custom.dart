import 'package:flutter/material.dart';
import 'package:vibemix/utils/notifier.dart';
import '../models/audio_player_model.dart';
import 'floating_music.dart';
import 'global.dart';

// ignore: must_be_immutable
class ScaffoldCustom extends StatefulWidget {
  String? tittle;
  bool backButton;
  Widget body;
  Widget? actionIcon;
  bool appBar;
  bool? action;
  bool? floating;
  Color? color;
  void Function()? onpress;
  void Function()? onBack;

  ScaffoldCustom(
      {super.key,
      this.tittle,
      required this.backButton,
      this.onpress,
      required this.body,
      this.actionIcon, this.floating,
      this.onBack,
      required this.appBar,
      this.action,
      this.color});

  @override
  State<ScaffoldCustom> createState() => _ScaffoldCustomState();
}

class _ScaffoldCustomState extends State<ScaffoldCustom> {
  @override
  void initState() {
    RefreshNotifier().notifier.addListener(refresh);
    super.initState();
  }
  @override
  void dispose() {
    RefreshNotifier().notifier.removeListener(refresh);
    super.dispose();
  }
  void refresh(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Theme(data: ThemeData(
        bottomSheetTheme: const BottomSheetThemeData(surfaceTintColor: Colors.transparent,backgroundColor: Colors.transparent )
    ),
      child: Scaffold(
        appBar: widget.appBar
            ? AppBar(
                backgroundColor: background,
                centerTitle: true,
                elevation: 0,
                title: widget.appBar == true
                    ? Text(
                        widget.tittle!,
                        style: TextStyle(
                            color: foreground,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    : const Text(""),
                actions: widget.action == true
                    ? [
                        IconButton(
                          onPressed: widget.onpress,
                          icon: widget.actionIcon!,
                        ),
                        sw15
                      ]
                    : null,
                automaticallyImplyLeading: widget.backButton,
                leading: widget.backButton
                    ? IconButton(
                        onPressed: widget.onBack ??
                            () {
                              Navigator.of(context).pop();
                            },
                        icon: Icon(
                          Icons.arrow_back,
                          color: foreground,
                          size: 25,
                        ))
                    : null)
            : null,
        body: widget.body,  bottomSheet: widget.floating==true &&AudioPlayerSingleton().currentSong!=null?
      FloatingMusic():sh5 ,
        backgroundColor: background,
      ),
    );
  }
}
