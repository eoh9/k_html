import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  ChatUser user = ChatUser(
    id: '1',
    firstName: 'User',
    lastName: '',
  );

  ChatUser bot = ChatUser(
    id: '2',
    firstName: '아띠챗',
    lastName: '',
    profileImage: 'assets/icons/heart.png',  // assets 폴더에 있는 이미지를 참조합니다.
  );

  List<ChatMessage> messages = <ChatMessage>[
    ChatMessage(
      text: "안녕하세요! 저는 여러분의 필요에 딱 맞는 \n무장애 여행지를 추천해 드리는 챗봇입니다. \n어떤 편의시설을 원하시는지 말씀해 주세요.",
      user: ChatUser(id: '2', firstName: '아띠챗'),
      createdAt: DateTime.now().subtract(Duration(minutes: 3)),
    ),
  ];

  void onSend(ChatMessage message) {
    setState(() {
      messages.insert(0, message);
      // Add chatbot response logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(bot.profileImage ?? ''),  // AssetImage로 변경
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(bot.firstName ?? ''),
          ],
        ),
        backgroundColor: Color(0xFF40E0D0), // Mint green color
        elevation: 0,
      ),
      body: DashChat(
        currentUser: user,
        onSend: onSend,
        messages: messages,
        inputOptions: InputOptions(
          inputTextStyle: TextStyle(fontSize: 14),
          inputDecoration: InputDecoration(
            hintText: "Write a message...",
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        messageOptions: MessageOptions(
          showCurrentUserAvatar: false,
          currentUserContainerColor: Color(0xFF40E0D0), // User message bubble color
          containerColor: Color(0xFFE0E0E0), // Bot message bubble color
          messagePadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
