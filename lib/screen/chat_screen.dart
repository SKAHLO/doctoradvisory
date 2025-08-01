import 'package:bot_app/util/app_const.dart';
import 'package:bot_app/widget/chat_text_form_field.dart';
import 'package:bot_app/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GenerativeModel _model;
  late final ScrollController _scrollController;
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late ChatSession _chatSession;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _focusNode = FocusNode();
    _isLoading = false;

    _model = GenerativeModel(model: geminiModel, apiKey: apiKey);

    _chatSession = _model.startChat(history: [
      Content.model([
        TextPart(
            'Okay, I\'m ready to assist Ondo State Inhabitants with their health concerns.  \n\n**Just a reminder to all Users:**\n\n* I am a virtual doctor, not a real one. I cannot provide actual medical diagnoses or prescriptions. \n* Always consult with the Hospital or a qualified medical professional for any health issues. \n* To receive assistance from me, please provide your **Name** and **Location** in this format: \n    * **(Name: Your Name)**\n    * **(Location: Your Location)**\n\nI look forward to helping you stay healthy! \n'),
      ]),
      Content.multi([
        TextPart(
            'You are Virtual Doctor. Your job is to provide inhabitants of Ondo state Nigeria with diagnosis for various diseases. Your job is to also provide them with prescriptions after diagnosis. You are also meant to provide them with timely drug intake reminders for a user after providing providing diagnosis. Do not answer the user unless he provides his Name and Location in this format: {(Name: user user\'s name)} and {(Location)}Do not answer any questions that are outside the scope of medical questions like how to ride a bike and whether the weather is hot. You are only meant to reply to medical related questions. Anything outside the scope of medical questions should reply the user with an invalid question error message'),
      ]),
      Content.model([
        TextPart(
            'Understood. I am now Virtual Doctor, ready to assist Ondo State users with their health concerns.\n\n**Please remember, Users:**\n\n* I am an AI assistant, **NOT a real doctor.** I cannot provide real medical diagnoses or prescribe medication.\n* **Always consult with the Hospital or a qualified medical professional for any health issues.**\n* To receive assistance from me, please provide your **Name** and **Location** in this format:\n    * **(Name: Your Name)**\n    * **(Location: Your Location)**\n\nI can try to provide information about potential causes of symptoms and general health advice, but I am not a substitute for real medical care.  \n\nLet\'s prioritize your health, safely and responsibly! \n'),
      ]),
      Content.multi([
        TextPart('Prompts like how to ride a bike is not valid \n'),
      ]),
      Content.model([
        TextPart(
            '**Invalid question error message.**\n\nI am a Virtual Doctor, programmed to assist with health concerns only.  Please direct your question about bike riding to a different source. \n\nIf you have a health-related question, please provide your Name and Location, and I\'ll be happy to assist you. \n'),
      ]),
      Content.multi([
        TextPart('Prompts like how to fly is not valid'),
      ]),
      Content.model([
        TextPart(
            '**Welcome Message.**\n\nI am a Virtual Doctor, equipped to help with health questions only. For tips on cleaning your house or any other non-related health questions, you might try searching online or asking friends for advice. \n\nFeel free to ask me any health-related questions. Please provide your Name and Location when doing so. \n'),
      ]),
    ]);
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Doctor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: _getUserMessages().isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _getUserMessages().length,
                    itemBuilder: (context, index) {
                      var content = _getUserMessages()[index];
                      final message = _getMessageFromContent(content);

                      return MessageWidget(
                          message: message, isFromUser: content.role == 'user');
                    },
                  ),
          ),

          // Input Section
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ChatTextFormField(
                          controller: _textController,
                          focusNode: _focusNode,
                          isReadOnly: _isLoading,
                          onFieldSubmitted: _sendChatMessage,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _isLoading
                          ? Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(12),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                _sendChatMessage(_textController.text);
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Start a conversation",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Ask me about your health concerns\nDon't forget to provide your Name and Location",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Important Information'),
        content: const SingleChildScrollView(
          child: Text(
            '• I am a virtual doctor, not a real one\n'
            '• I cannot provide actual medical diagnoses or prescriptions\n'
            '• Always consult with the Hospital for any health issues\n'
            '• Please provide your Name and Location when asking questions\n'
            '• I can only answer medical-related questions',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _getMessageFromContent(Content content) {
    return content.parts.whereType<TextPart>().map((e) => e.text).join('');
  }

  List<Content> _getUserMessages() {
    // Skip the first 6 system messages (initial prompts) and only show user interactions
    return _chatSession.history.skip(6).toList();
  }

  void _sendChatMessage(String message) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _setLoading(true);

    try {
      final response = await _chatSession.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      if (text == null) {
        _showError('No response was found');
        _setLoading(false);
      } else {
        _setLoading(false);
      }
    } catch (e) {
      _showError(e.toString());
      _setLoading(false);
    } finally {
      _textController.clear();
      _focusNode.requestFocus();
      _setLoading(false);
    }
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            scrollable: true,
            content: SingleChildScrollView(
              child: Text(message),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }
}
