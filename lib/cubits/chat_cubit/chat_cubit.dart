import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:ntp/ntp.dart';
import 'package:scholar_chat/models/message.dart';

import '../../constants.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  Future<void> sendMessage(String message, Object? email) async {
    try {
      messages.add(
        {kMessage: message, kCreatedAt: await NTP.now(), 'id': email},
      );
    } on Exception catch (e) {
      print('failed to send the message');
    }
  }

  void getMessages() async {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      List<Message> messagesList = [];
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      print('success');
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
