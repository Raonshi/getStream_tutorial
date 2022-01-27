import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class PlatformService extends GetxService {
  final _isWeb = false.obs;
  get isWeb => _isWeb.value;
  setIsWeb(value) => _isWeb.value = value;

  // @override
  // void onInit() {
  //   super.onInit();
  //   try {
  //     if (Platform.isAndroid || Platform.isIOS) {
  //       _isWeb.value = false;
  //     } else {
  //       _isWeb.value = true;
  //     }
  //   } catch (e) {
  //     _isWeb.value = true;
  //   }
  //   Logger().d('PlatformService Init Done');
  // }

  void init() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _isWeb.value = false;
      } else {
        _isWeb.value = true;
      }
    } catch (e) {
      _isWeb.value = true;
    }
    Logger().d('==== PlatformService Init ====');
  }
}
