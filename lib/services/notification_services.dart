import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationServices {

  final FirebaseMessaging messenger = FirebaseMessaging.instance;

  Future initialize() async{
    messenger.getInitialMessage().then((RemoteMessage? message){
      if(message?.notification != null){
        //Todo: Add body
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        //Todo: Add body
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(message.notification != null){
        //Todo: Add body
      }
    });
  }

  Future<String?> getToken() async{
    return await messenger.getToken();
  }

  Future<void> subScribeToTopic(String topic) async{
    messenger.subscribeToTopic(topic);
  }

  Future<void> sendMessage() async {
    messenger.sendMessage(
      to: 'viewers',
      data: {"greeting": "greeting"},
      ttl: 3600000,
    );
  }
}
