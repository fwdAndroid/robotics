import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:robotics/screens/main_dashboard.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    setState(() {
      nameController.text = data['username'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Edit Profile")),
        body: Column(
          children: [
            // Full Name Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
            ),

            Spacer(),

            // Save Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.blue))
                  : ElevatedButton(
                      child: Text("Edit Profile"),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({"username": nameController.text});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Successfully Updated Profile"),
                            ),
                          );
                        } catch (e) {
                          print("Error updating profile: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Profile not updated")),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => MainDashboard(),
                            ),
                          );
                        }
                      },
                    ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
