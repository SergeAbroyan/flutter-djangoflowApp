import 'package:npua_project/middlewares/enum/info_type_enum.dart';
import 'package:flutter/material.dart';

class InfoTypeNotifier extends ChangeNotifier {
  InfoTypeEnum infoType = InfoTypeEnum.info;

  void changeInfoType(InfoTypeEnum newInfoType) {
    infoType = newInfoType;
    notifyListeners();
  }
}
