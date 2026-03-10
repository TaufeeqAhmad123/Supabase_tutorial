import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  late RealtimeChannel channel;
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notes = [];

  void listenToBroadcast() {
    channel = supabase.channel('chat', opts: RealtimeChannelConfig(self: true));
    channel?.onBroadcast(
      event: 'event1',
      callback: (payload) {
        print(payload);
        setState(() {
          notes.add(payload);
        });
      },
    );
    channel?.subscribe();
  }

  void sendMessage() async {
    String text = controller.text.trim();
    controller.clear();
    ChannelResponse response = await channel.sendBroadcastMessage(
      event: 'event1',
      payload: {
        'message': text,
        'id': supabase.auth.currentUser!.id,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
    print(response.name);
  }

  @override
  void initState() {
    super.initState();
    listenToBroadcast();
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(channel);
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(notes);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (var message in notes)
                    Align(
                      alignment: message['id']==supabase.auth.currentUser?.id ? AlignmentGeometry.centerRight : AlignmentGeometry.centerLeft ,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 300
                        ),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.indigoAccent,
                        ),
                        child: Text(message['message'],style: TextStyle(color: Colors.black),),
                      ),
                    ),
                ],
              ),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.brown[500],
                border: OutlineInputBorder(),
                hintText: 'Enter message',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(Iconsax.send, color: Colors.white),
                  onPressed: () async {
                    sendMessage();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
