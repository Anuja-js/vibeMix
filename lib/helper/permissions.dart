import 'package:permission_handler/permission_handler.dart';
class PermissionHandle{
  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted &&
        await Permission.mediaLibrary.request().isGranted) {

    } else {

    }
  }


}