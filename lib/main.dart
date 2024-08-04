import 'package:flutter/material.dart';

import 'chatbot.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Chat',
      theme: ThemeData(
        primaryColor: Color(0xFF003366),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ChatBotPage(),
      },
    );
  }
}
