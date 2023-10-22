import 'dart:io';

class AppM{
  AppM({
    required this.authorizationHeader,
    required this.token,
    required this.deviceName,

    required this.appName,
    required this.buildNumber,
    required this.packageName,
    required this.version,

    required this.tempPath,
    required this.appDocPath,
    required this.filePath,
    required this.picturePath,
    required this.videoPath,
    required this.musicPath,
    required this.dbPath,

    required this.tempDir,
    required this.appDocDir ,
    required this.fileDir ,
    required this.pictureDir ,
    required this.videoDir,
    required this.musicDir,
    required this.dbDir,
});
  String authorizationHeader;
  String token;
  String deviceName;

  String appName;
  String packageName;
  String version;
  String buildNumber;

  String tempPath ;
  String? appDocPath ;

  String filePath ;
  String picturePath ;
  String videoPath ;
  String musicPath ;
  String dbPath ;

  Directory tempDir ;
  Directory? appDocDir ;

  Directory fileDir ;
  Directory pictureDir ;
  Directory videoDir ;
  Directory musicDir ;
  Directory dbDir ;
}