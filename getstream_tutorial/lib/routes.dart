import 'package:get/get.dart';
import 'package:getstream_tutorial/main_old.dart';

List<GetPage<dynamic>> pages = [
  GetPage(
    name: '/channel_list',
    page: () => const ChannelListPage(),
  ),
  GetPage(
    name: '/channel',
    page: () => const ChannelPage(),
  ),
  GetPage(
    name: '/thread',
    page: () => const ThreadPage(),
  ),
];
