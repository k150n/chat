import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Функция отправки сообщения
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Отправляем сообщение в Firestore
        await _firestore.collection('chats').add({
          'text': _controller.text,
          'sender': user.email,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _controller.clear(); // Очистить текстовое поле после отправки
      } catch (e) {
        print('Ошибка отправки сообщения: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат с продавцом'),
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .orderBy('timestamp', descending: false) // Сортировка по времени
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final chatDocs = chatSnapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    final chatMessage = chatDocs[index];
                    final messageText = chatMessage['text'];
                    final messageSender = chatMessage['sender'];

                    // Чередование сторон
                    final isEven = index % 2 == 0; // Четное или нечетное сообщение
                    final alignment = isEven ? Alignment.centerLeft : Alignment.centerRight;

                    // Цвет сообщений
                    final messageColor = isEven ? Colors.green : Colors.blue;

                    return Container(
                      alignment: alignment,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Card(
                        color: messageColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: isEven
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Text(
                                messageText,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Поле для ввода текста сообщения
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
