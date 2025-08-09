import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robotics/screens/chat/chat_page.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoChat extends StatefulWidget {
  final String staffName, staffId, userId, userName, callID;
  const VideoChat({
    super.key,
    required this.staffName,
    required this.staffId,
    required this.userId,
    required this.userName,
    required this.callID,
  });

  @override
  State<VideoChat> createState() => _VideoChatState();
}

class _VideoChatState extends State<VideoChat> {
  final int appID = 639665702; // Your Zego AppID
  final String appSign =
      "7f6c104b5fa917a561058a4da436faf1880fb042d84d1cd22156e80dc651ed98"; // Your Zego AppSign

  late final String chatRoomId;

  @override
  void initState() {
    super.initState();
    // Generate chat room ID based on user and staff IDs
    chatRoomId = _generateChatRoomId(widget.userId, widget.staffId);

    // When the call starts, mark staff as busy
    _updateStaffStatus("busy");
  }

  @override
  void dispose() {
    super.dispose();
    // In case widget is disposed without pressing close
    _updateStaffStatus("online");
  }

  String _generateChatRoomId(String userId, String staffId) {
    if (userId.compareTo(staffId) > 0) {
      return "${staffId}_$userId";
    } else {
      return "${userId}_$staffId";
    }
  }

  Future<void> _updateStaffStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(widget.staffId)
          .update({'status': status});
    } catch (e) {
      debugPrint("Error updating staff status: $e");
    }
  }

  void _endCall() {
    _updateStaffStatus("online"); // change status to online
    Navigator.pop(context); // go back
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference chatCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    staffId: widget.staffId,
                    staffName: widget.staffName,
                    chatRoomId: chatRoomId,
                    chatCollection: chatCollection,
                    currentUserId: widget.userId,
                    currentUserName: widget.userName,
                  ),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: _endCall),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Video Call with ${widget.staffName}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ZegoUIKitPrebuiltCall(
        appID: appID,
        appSign: appSign,
        userID: widget.userId,
        userName: widget.userName,
        callID: widget.callID,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          ..turnOnCameraWhenJoining = true
          ..turnOnMicrophoneWhenJoining = true
          ..useSpeakerWhenJoining = true
          ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
            buttons: [
              ZegoMenuBarButtonName.toggleCameraButton,
              ZegoMenuBarButtonName.switchCameraButton,
              ZegoMenuBarButtonName.toggleMicrophoneButton,
              ZegoMenuBarButtonName.hangUpButton,
              ZegoMenuBarButtonName.switchAudioOutputButton,
            ],
          ),
      ),
    );
  }

  // body: Stack(
  //   children: [
  //     SafeArea(
  //       child:
  //     Positioned(
  //       bottom: 30,
  //       right: 20,
  //       child: FloatingActionButton(
  //         backgroundColor: Colors.blueAccent,
  //         child: const Icon(Icons.chat_bubble_outline),
  //         onPressed: () {

  //     ),
}
