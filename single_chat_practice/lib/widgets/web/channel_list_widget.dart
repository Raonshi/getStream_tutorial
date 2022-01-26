import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/channel_ctrl.dart';
import 'package:single_chat_practice/controllers/web_test_ctrl.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class ChannelListWidget extends StatelessWidget {
  ChannelListWidget({Key? key}) : super(key: key);
  final streamService = Get.find<StreamChatService>();

  @override
  Widget build(BuildContext context) {
    return ChannelsBloc(
      child: ChannelListCore(
        filter: Filter.and([
          Filter.in_(
              'members', [streamService.client.value.state.currentUser!.id]),
        ]),
        errorBuilder: (BuildContext context, Object error) {
          return const Center(child: Text('Error'));
        },
        emptyBuilder: (BuildContext context) {
          return const Center(child: Text('You don\'t have channel'));
        },
        loadingBuilder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
        listBuilder: (BuildContext context, List<Channel> channelList) {
          return ListView.builder(
            itemCount: channelList.length,
            itemBuilder: (BuildContext context, int index) {
              //final Channel item = channelList[index];
              final itemName = channelList[index].name ?? 'Channel_$index';
              return Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.chat_bubble,
                  ),
                  title: Text(
                    itemName,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  subtitle: const Text(
                    'Members',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  onTap: () {
                    Get.find<WebTestController>().currentChannelCid.value =
                        channelList[index].cid!;
                    Get.put(
                      ChannelController(channelList[index]),
                      tag: channelList[index].cid,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
