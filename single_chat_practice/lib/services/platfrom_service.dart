import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

class PlatformService extends GetxService {
  final _isWeb = false.obs;
  get isWeb => _isWeb.value;
  setIsWeb(value) => _isWeb.value = value;

  void init() {
    try {
      _isWeb.value = Platform.isAndroid || Platform.isIOS ? false : true;
    } catch (e) {
      _isWeb.value = true;
    }
    Logger().d('==== PlatformService Init ====');
  }
}
