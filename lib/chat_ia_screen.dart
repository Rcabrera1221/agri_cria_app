import 'dart:typed_data';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatIAGanaderoScreen extends StatefulWidget {
  const ChatIAGanaderoScreen({super.key});

  @override
  State<ChatIAGanaderoScreen> createState() => _ChatIAGanaderoScreenState();
}

class _ChatIAGanaderoScreenState extends State<ChatIAGanaderoScreen> {
  io.File? imageFile;
  Uint8List? imageBytes;
  String analysisResult = '';
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> chatMessages = [];

  Future<void> pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          imageBytes = result.files.single.bytes;
          imageFile = null;
        });
      }
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          imageFile = io.File(picked.path);
          imageBytes = null;
        });
      }
    }
  }

  Future<void> analyzeImage() async {
    const apiKey = 'SECRET_KEY';
    if (imageBytes == null && imageFile == null) return;

    final bytes = kIsWeb ? imageBytes! : await imageFile!.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "user",
              "content": [
                {"type": "text", "text": "¿Qué contiene esta imagen?"},
                {
                  "type": "image_url",
                  "image_url": {
                    "url": "data:image/png;base64,$base64Image",
                  }
                }
              ]
            }
          ],
          "max_tokens": 500
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = decoded['choices'][0]['message']['content'];
        setState(() {
          analysisResult = reply;
        });
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['error']['message'] ?? 'Error desconocido';
        setState(() {
          analysisResult = 'Error ${response.statusCode}: $errorMessage';
        });
      }
    } catch (e) {
      setState(() {
        analysisResult = 'Error de red o inesperado: $e';
      });
    }
  }

  Future<void> sendMessage() async {
    const apiKey = 'SECRET_KEY';
    String userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      chatMessages.add({'role': 'user', 'content': userMessage});
      _messageController.clear();
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": chatMessages
              .map((msg) => {
                    "role": msg['role'],
                    "content": msg['content'],
                  })
              .toList(),
          "max_tokens": 500
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final reply = decoded['choices'][0]['message']['content'];
        setState(() {
          chatMessages.add({'role': 'assistant', 'content': reply});
        });
      } else {
        setState(() {
          chatMessages.add({
            'role': 'assistant',
            'content': 'Error ${response.statusCode}: ${response.reasonPhrase}'
          });
        });
      }
    } catch (e) {
      setState(() {
        chatMessages.add({'role': 'assistant', 'content': 'Error: $e'});
      });
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && imageBytes != null) {
      return Image.memory(imageBytes!, height: 200);
    } else if (!kIsWeb && imageFile != null) {
      return Image.file(imageFile!, height: 200);
    } else {
      return const Text('No se ha subido una imagen.');
    }
  }

  Widget _buildMessageBubble(String text,
      {Color color = Colors.white,
      Alignment alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Asesoramiento IA',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.android,
                      size: 50,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildImagePreview(),
                  const SizedBox(height: 16),
                  if (analysisResult.isNotEmpty)
                    _buildMessageBubble(
                      analysisResult,
                      color: Colors.green[100]!,
                      alignment: Alignment.centerRight,
                    ),
                  ...chatMessages.map((msg) {
                    return _buildMessageBubble(
                      msg['content'],
                      color: msg['role'] == 'user'
                          ? Colors.white
                          : Colors.green[100]!,
                      alignment: msg['role'] == 'user'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Escribe un mensaje...',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.black),
                          onPressed: sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Subir imagen',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: analyzeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Diagnóstico de cultivo',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.black54.withOpacity(0.99),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/datosPersonales');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
