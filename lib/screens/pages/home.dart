import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotics/screens/chat/video_chat.dart';
import 'package:robotics/screens/provider/language_provider.dart';

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
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/logo.png", height: 50, width: 50),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff0A5EFE),
        title: Text(
          languageProvider.localizedStrings['Online Members'] ??
              'Online Members',
          style: const TextStyle(
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
            return Center(
              child: Text(
                languageProvider.localizedStrings['No staff members found'] ??
                    "No staff members found",
              ),
            );
          }

          var staffList = snapshot.data!.docs;

          // Sort: online first, then busy, then offline
          staffList.sort((a, b) {
            String statusA = a['status'] ?? 'inactive';
            String statusB = b['status'] ?? 'inactive';
            List<String> order = ['online', 'busy', 'inactive'];
            return order.indexOf(statusA).compareTo(order.indexOf(statusB));
          });

          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              var staff = staffList[index];
              var name = staff['name'] ?? 'No Name';
              var status = staff['status'] ?? 'inactive';
              var profilePic = staff['profileImage'] ?? '';
              var staffDocId = staff.id; // actual Firestore document ID
              var staffId = staff['id']; // your custom staff id field

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          (profilePic.isNotEmpty &&
                              profilePic.startsWith('http'))
                          ? NetworkImage(profilePic)
                          : const AssetImage('assets/user.png')
                                as ImageProvider,
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
                      status == 'online'
                          ? "🟢 Active now"
                          : status == 'busy'
                          ? "🟡 Busy"
                          : "🔴 Offline",
                      style: TextStyle(
                        fontSize: 12,
                        color: status == 'online'
                            ? Colors.green
                            : status == 'busy'
                            ? Colors.yellow[800]
                            : const Color(0xff9A9BB1),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: (status == 'online')
                          ? () async {
                              // Change status to busy
                              await _staffRef.doc(staffDocId).update({
                                'status': 'busy',
                              });

                              // Navigate to call screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => VideoChat(
                                    callID: staffId,
                                    staffName: name,
                                    staffId: staffId,
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    userName: currentUserName ?? 'Guest',
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: status == 'online'
                            ? const Color(0xff0A5EFE)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        languageProvider.localizedStrings['Join'] ?? "Join",
                        style: const TextStyle(color: Colors.white),
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
