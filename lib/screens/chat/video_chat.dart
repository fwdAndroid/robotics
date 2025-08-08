import 'package:flutter/material.dart';

class VideoChat extends StatefulWidget {
  String staffName, staffId, userId, userName;
  VideoChat({
    super.key,
    required this.staffName,
    required this.staffId,
    required this.userId,
    required this.userName,
  });

  @override
  State<VideoChat> createState() => _VideoChatState();
}

class _VideoChatState extends State<VideoChat> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
