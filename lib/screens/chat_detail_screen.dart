import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.chatId, this.partnerId});

  final String chatId;
  final String? partnerId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();
  late List<ChatMessage> _messages;
  late String _title;
  late double _hue;
  late bool _isCommunity;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    if (widget.chatId == 'new' && widget.partnerId != null) {
      final p = MockData.people[widget.partnerId]!;
      _title = p.name;
      _hue = p.hue;
      _isCommunity = false;
      _messages = [];
    } else {
      final chat = MockData.chats.firstWhere((c) => c.id == widget.chatId);
      _title = chat.name;
      _hue = chat.hue;
      _isCommunity = chat.type == 'community';
      _messages = List.of(chat.messages);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(id: 'm${_messages.length}', from: 'me', text: text, time: 'Now'));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.read<AppState>().pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [avatarGradientStart(_hue), avatarGradientEnd(_hue)],
                      ),
                    ),
                    child: Text(_title[0], style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15.5)),
                        Text(
                          _isCommunity ? 'Community chat' : 'Active now',
                          style: AppTheme.muted(context, size: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  final mine = m.from == 'me';
                  return Align(
                    alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: mine ? AppColors.gold : AppColors.s2,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.text,
                            style: GoogleFonts.inter(
                              color: mine ? AppColors.onGold : AppColors.txt,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.time,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              color: mine ? AppColors.onGold.withValues(alpha: 0.7) : AppColors.txt3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.s1,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.line2),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Message…',
                          border: InputBorder.none,
                          filled: false,
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: _controller.text.trim().isNotEmpty ? AppColors.gold : AppColors.s2,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: _send,
                      icon: Icon(
                        Icons.send,
                        color: _controller.text.trim().isNotEmpty ? AppColors.onGold : AppColors.txt3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
