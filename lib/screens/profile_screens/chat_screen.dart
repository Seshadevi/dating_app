import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dating/constants/dating_app_user.dart';
import 'package:dating/model/chat_message.dart';
import 'package:dating/provider/chat_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final int matchId;
  final int userId;
  final String userName;
  final String avatar;

  const ChatScreen({
    Key? key,
    required this.matchId,
    required this.userId,
    required this.userName,
    required this.avatar,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingDebounce;
  bool _showEmojiPicker = false;
  bool _isTyping = false;
  bool _isSendingImage = false; // Add loading state for image sending

  @override
  void initState() {
    super.initState();
    ref.read(chatProvider.notifier).fetchMessages(widget.userId);
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _controller.text.trim().isNotEmpty;
    });
    
    _typingDebounce?.cancel();
    ref.read(chatProvider.notifier).sendTyping(widget.userId);
    _typingDebounce = Timer(const Duration(milliseconds: 1200), () {});
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  // Convert image file to base64 data URL
  Future<String> _convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      
      // Determine mime type from file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      String mimeType;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'gif':
          mimeType = 'image/gif';
          break;
        default:
          mimeType = 'image/jpeg'; // Default fallback
      }
      
      return 'data:$mimeType;base64,$base64String';
    } catch (e) {
      throw Exception('Failed to convert image: $e');
    }
  }

  // Send image message via socket
  Future<void> _sendImageMessage(String base64DataUrl, {String? caption}) async {
    try {
      setState(() {
        _isSendingImage = true;
      });

      // Send via socket using your backend's expected format
      ref.read(chatProvider.notifier).sendImageMessage(
        receiverId: widget.userId,
        media: [base64DataUrl], // Send as array as your backend expects
        message: caption, // Optional caption
      );

      // Clear caption if it was entered
      if (caption != null && caption.isNotEmpty) {
        _controller.clear();
        setState(() {
          _isTyping = false;
        });
      }

      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSendingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final isTyping = ref.watch(typingProvider);
    final presence = ref.watch(presenceProvider);

    final items = _withDateHeaders(messages);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DatingColors.everqpidColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.only(left: 8),
            constraints: const BoxConstraints(minWidth: 30),
          ),
          titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.avatar)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName, style: const TextStyle(fontSize: 20)),
                  Text(
                    presence == null
                        ? ''
                        : presence.online
                            ? 'Online'
                            : (presence.lastSeen != null
                                ? 'last seen ${DateFormat('dd MMM, hh:mm a').format(presence.lastSeen!)}'
                                : 'Offline'),
                    style: TextStyle(
                      fontSize: 12,
                      color: presence?.online == true ? Colors.green : Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              print('Video call tapped');
            },
            icon: const Icon(Icons.videocam, color: Colors.white,size: 30,),
          ),
          IconButton(
            onPressed: () {
              print('Voice call tapped');
            },
            icon: const Icon(Icons.call, color: Colors.white,size:30),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Background Image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/chat_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.6),
                ),
                // Chat Messages
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final it = items[i];
                    if (it.isHeader) {
                      return _DateHeader(label: it.header!);
                    }
                    final msg = it.message!;
                    final isMe = msg.senderId != widget.userId;
                    
                    return Padding(
                      padding: EdgeInsets.only(
                        left: isMe ? 80.0 : 10.0,
                        right: isMe ? 10.0 : 80.0,
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                            minWidth: 60,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? DatingColors.primaryGreen.withOpacity(0.85)
                                : DatingColors.backgroundWhite.withOpacity(0.95),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Display image if message has media
                             // Fixed image display section for your ChatScreen build method
// Replace the existing media display section with this:

// Display image if message has media
if (msg.hasImages)
  ...msg.mediaItems.map((mediaItem) {
    if (mediaItem.isBase64) {
      // Handle base64 data URLs
      try {
        final base64Str = mediaItem.url.split(',').last;
        final bytes = base64Decode(base64Str);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => 
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 50),
                      Text('Failed to load image'),
                    ],
                  ),
                ),
            ),
          ),
        );
      } catch (e) {
        return Container(
          height: 200,
          color: Colors.grey[300],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 50),
              Text('Invalid image format'),
            ],
          ),
        );
      }
    } else if (mediaItem.isNetworkUrl) {
      // Handle network URLs from your backend
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            mediaItem.url,
            fit: BoxFit.cover,
            height: 200,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => 
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 50),
                    Text('Failed to load image'),
                  ],
                ),
              ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // Fallback for unknown format
      return Container(
        height: 100,
        color: Colors.grey[300],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.attachment, size: 30),
              Text('Unsupported media'),
            ],
          ),
        ),
      );
    }
  }).toList(),
                              
                              // Display text message if exists
                              if (msg.message != null && msg.message!.isNotEmpty)
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: msg.message,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: isMe ? const Color.fromARGB(255, 62, 57, 57).withOpacity(0.8) : Colors.black87,
                                          height: 1.3,
                                        ),
                                      ),
                                      TextSpan(text: '  '),
                                      TextSpan(
                                        text: DateFormat('hh:mm a').format(msg.timestamp.toLocal()),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isMe 
                                              ? const Color.fromARGB(255, 90, 89, 89).withOpacity(0.6)
                                              : Colors.black45,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                              // Show only timestamp if no text message (image only)
                              if ((msg.message == null || msg.message!.isEmpty) && 
                                  msg.media != null && msg.media!.isNotEmpty)
                                Text(
                                  DateFormat('hh:mm a').format(msg.timestamp.toLocal()),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMe 
                                        ? const Color.fromARGB(255, 90, 89, 89).withOpacity(0.6)
                                        : Colors.black45,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Image sending loading overlay
                if (_isSendingImage)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text('Sending image...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Typing indicator
          if (isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 16, right: 80),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'typing…',
                        style: TextStyle(
                          color: Colors.black54, 
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Input Area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SafeArea(
              child: Row(
                children: [
                  // Emoji button
                  IconButton(
                    onPressed: _toggleEmojiPicker,
                    icon: Icon(
                      _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  // Text input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: "Message",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 12,
                                ),
                              ),
                              maxLines: 5,
                              minLines: 1,
                              onTap: () {
                                if (_showEmojiPicker) {
                                  setState(() {
                                    _showEmojiPicker = false;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          // Attachment button (only show when not typing)
                          if (!_isTyping)
                            IconButton(
                              onPressed: _showAttachmentOptions,
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          
                          // Camera button (only show when not typing)
                          if (!_isTyping)
                            IconButton(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send/Mic button
                  Container(
                    decoration: BoxDecoration(
                      color: DatingColors.everqpidColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _isTyping ? _sendMessage : _recordVoice,
                      icon: Icon(
                        _isTyping ? Icons.send : Icons.mic,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Emoji Picker
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _controller.text += emoji.emoji;
                  setState(() {
                    _isTyping = _controller.text.trim().isNotEmpty;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
    
    if (_showEmojiPicker) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _sendMessage() {
    final msg = _controller.text.trim();
    if (msg.isEmpty) return;
    
    ref.read(chatProvider.notifier).sendMessage(widget.userId, msg);
    _controller.clear();
    setState(() {
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _recordVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hold to record voice message'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            
            // Options grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _AttachmentOption(
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _AttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                _AttachmentOption(
                  icon: Icons.headset,
                  label: 'Audio',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    _pickAudio();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _shareLocation();
                  },
                ),
                _AttachmentOption(
                  icon: Icons.person,
                  label: 'Contact',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _shareContact();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85, // Compress image to reduce size
      );
      
      if (image != null) {
        // Show dialog to optionally add caption
        // String? caption = _controller.text.trim();
        // if (caption.isEmpty) {
        //   caption = await _showCaptionDialog();
        // }
        
        // Convert image to base64 and send
        final base64DataUrl = await _convertImageToBase64(File(image.path));
        await _sendImageMessage(base64DataUrl, 
        // caption: caption
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showCaptionDialog() async {
    final captionController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Caption'),
        content: TextField(
          controller: captionController,
          decoration: const InputDecoration(
            hintText: 'Enter caption (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Skip'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(captionController.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _pickDocument() {
    print('Document picker opened');
    // Implement document picker
  }

  void _pickAudio() {
    print('Audio picker opened');
    // Implement audio picker
  }

  void _shareLocation() {
    print('Location sharing opened');
    // Implement location sharing
  }

  void _shareContact() {
    print('Contact sharing opened');
    // Implement contact sharing
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<_Item> _withDateHeaders(List<ChatMessage> msgs) {
    final out = <_Item>[];
    DateTime? lastDay;
    for (final m in msgs..sort((a,b)=>a.timestamp.compareTo(b.timestamp))) {
      final d = DateTime(m.timestamp.year, m.timestamp.month, m.timestamp.day);
      if (lastDay == null || d.difference(lastDay).inDays != 0) {
        out.add(_Item.header(_labelFor(d)));
        lastDay = d;
      }
      out.add(_Item.message(m));
    }
    return out;
  }

  String _labelFor(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yday = today.subtract(const Duration(days: 1));
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) return 'Today';
    if (day == yday) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(d);
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label, 
            style: const TextStyle(
              color: Colors.black54, 
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final bool isHeader;
  final String? header;
  final ChatMessage? message;
  _Item.header(this.header) : isHeader = true, message = null;
  _Item.message(this.message) : isHeader = false, header = null;
}