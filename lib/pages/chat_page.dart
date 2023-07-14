import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/cubits/chat_cubit/chat_cubit.dart';
import 'package:scholar_chat/models/message.dart';
import 'package:scholar_chat/widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  final _controller = ScrollController();

  List<Message> messagesList = [];
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            Text('chat'),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatSuccess) {
                messagesList = state.messages;
              }
            },
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBuble(
                              message: messagesList[index],
                            )
                          : ChatBubleForFriend(message: messagesList[index]);
                    }),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              onSubmitted: (data) async {
                await BlocProvider.of<ChatCubit>(context)
                    .sendMessage(controller.text, email);
                chatReset(); //scrolls down to the last message
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: Icon(
                  Icons.send,
                  color: kPrimaryColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void chatReset() {
    controller.clear(); // clears the message textfield
    _controller.animateTo(0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn); //scrolls down to the last message
  }
}
