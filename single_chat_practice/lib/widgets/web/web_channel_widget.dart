import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:single_chat_practice/controllers/channel_ctrl.dart';
import 'package:single_chat_practice/controllers/web_test_ctrl.dart';
import 'package:single_chat_practice/services/stream_chat_service.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class WebChannelWidget extends StatelessWidget {
  WebChannelWidget({Key? key}) : super(key: key);
  final controller = Get.find<WebChannelController>(
    tag: Get.find<WebTestController>().currentChannelCid.value,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MessageListCore(
                loadingBuilder: (BuildContext context) {
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (BuildContext context, Object error) {
                  return const Center(child: Text('Error'));
                },
                emptyBuilder: (BuildContext context) {
                  return const Center(child: Text('You don\'t have channel'));
                },
                messageListBuilder:
                    (BuildContext context, List<Message> messages) {
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return messages[index].user!.id ==
                              Get.find<StreamChatService>()
                                  .client
                                  .value
                                  .state
                                  .currentUser!
                                  .id
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Card(
                                  color: Colors.amber[100],
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      messages[index].text!,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      messages[index].text!,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            );
                    },
                  );
                },
              ),
            ),
            const IntrinsicHeight(
              child: Divider(),
            ),
            Row(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => controller.messageText.value = value,
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Message message = Message(
                          text: controller.messageText.value,
                          createdAt: DateTime.now(),
                          user: Get.find<StreamChatService>()
                              .client
                              .value
                              .state
                              .currentUser);
                      controller.channel.sendMessage(message);
                      controller.messageText.value = '';
                    },
                    child: const Icon(Icons.send),
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
