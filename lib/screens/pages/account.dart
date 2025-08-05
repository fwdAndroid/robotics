import 'package:flutter/material.dart';
import 'package:robotics/screens/setting/edit_profile.dart';

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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (builder) => ChangeLangage()),
                // );
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
                // shareApp();
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
            onPressed: () {},
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
