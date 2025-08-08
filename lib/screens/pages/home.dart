import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robotics/screens/chat/video_chat.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference _staffRef = FirebaseFirestore.instance.collection(
    'staff',
  );
  String? currentUserName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCurrentUserName();
  }

  Future<void> _fetchCurrentUserName() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          currentUserName = userDoc['username'] ?? 'No Name';
        });
      }
    } catch (e) {
      debugPrint("Error fetching username: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/logo.png", height: 50, width: 50),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff0A5EFE),
        title: const Text(
          'Online Members',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _staffRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No staff members found"));
          }

          var staffList = snapshot.data!.docs;

          // Sort: Active first, then inactive
          staffList.sort((a, b) {
            String statusA = a['status'] ?? 'inactive';
            String statusB = b['status'] ?? 'inactive';
            if (statusA == 'active' && statusB != 'active') return -1;
            if (statusA != 'active' && statusB == 'active') return 1;
            return 0;
          });

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              var staff = staffList[index];
              var name = staff['name'] ?? 'No Name';
              var status = staff['status'] ?? 'inactive';
              var profilePic = staff['profileImage'] ?? 'assets/user.png';
              var staffId = staff['id'];

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profilePic.startsWith('http')
                          ? NetworkImage(profilePic)
                          : AssetImage(profilePic) as ImageProvider,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2C2D3A),
                      ),
                    ),
                    subtitle: Text(
                      status == 'active' ? "🟢 Active now" : "🔴 Offline",
                      style: TextStyle(
                        fontSize: 12,
                        color: status == 'active'
                            ? Colors.green
                            : const Color(0xff9A9BB1),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: status == 'active'
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => VideoChat(
                                  staffName: name,
                                  staffId: staffId,
                                  userId: FirebaseAuth
                                      .instance
                                      .currentUser!
                                      .uid, // Replace with actual user ID
                                  userName: currentUserName!,
                                ),
                              ),
                            )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: status == 'active'
                            ? const Color(0xff0A5EFE)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Join",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Color(0xffE5E5E5),
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
