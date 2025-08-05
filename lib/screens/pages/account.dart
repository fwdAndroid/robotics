import 'package:flutter/material.dart';
import 'package:robotics/screens/setting/change_language.dart';
import 'package:robotics/screens/setting/edit_profile.dart';
import 'package:robotics/service/auth_service.dart';
import 'package:share_plus/share_plus.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset("assets/logo.png", height: 200),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => EditProfile()),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              title: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.person, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (builder) => NotificationSetting(),
                //   ),
                // );
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              title: Text(
                "Notifications",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.notifications, color: Colors.black),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => ChangeLangage()),
                );
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              title: Text(
                "Change Language",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.language, color: Colors.black),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: ListTile(
              onTap: () {
                shareApp();
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              title: Text(
                "Invite Friends",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.share, color: Colors.black),
            ),
          ),

          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // Close dialog

                        await FirebaseService().logout();
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void shareApp() {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.example.yourapp";
    Share.share("Hey, check out this amazing app: $appLink");
  }
}
