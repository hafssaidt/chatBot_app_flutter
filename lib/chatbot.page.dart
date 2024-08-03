import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List messages = [
    {"message": "Hello", "type": "user"},
    {"message": "How can I assist you today?", "type": "assistant"}
  ];
  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPT Chat',
          style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]['type'] == 'user';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.support_agent,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      if (isUser)
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Colors.blueAccent,
                          ),
                        ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(14),
                        constraints: BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.purple[100] : Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          messages[index]['message'],
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () {
                    String query = queryController.text;
                    setState(() {
                      messages.add({"message": query, "type": "user"});
                    });
                    var llmOpenAiUri =
                        Uri.https("api.openai.com", "/v1/chat/completions");
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                      "Authorization": "Bearer "
                    };
                    var prompt = {
                      "model": "gpt-3.5-turbo",
                      "messages": [
                        {"role": "user", "content": query}
                      ],
                      "temperature": 0.7
                    };
                    http
                        .post(llmOpenAiUri,
                            headers: headers, body: json.encode(prompt))
                        .then((res) {
                      var llmResponse = json.decode(res.body);
                      String responseContent =
                          llmResponse['choices'][0]['message']['content'];
                      setState(() {
                        messages.add(
                            {"message": responseContent, "type": "assistant"});
                        scrollController.jumpTo(
                            scrollController.position.maxScrollExtent + 100);
                      });
                    }, onError: (err) {
                      print("error " + err);
                    });
                    queryController.text = '';
                  },
                  child: Icon(Icons.send, color: Colors.white),
                  backgroundColor: Colors.deepPurpleAccent,
                  elevation: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
