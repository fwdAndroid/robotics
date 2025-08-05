import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotics/screens/provider/language_provider.dart';

class ChangeLangage extends StatefulWidget {
  const ChangeLangage({super.key});

  @override
  State<ChangeLangage> createState() => _ChangeLangageState();
}

class _ChangeLangageState extends State<ChangeLangage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
    ); // Access the provider

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          languageProvider.localizedStrings['Language'] ?? "Language",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/logo.png", height: 150),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 16),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  languageProvider.localizedStrings['Select Language'] ??
                      'Select Language',
                ),
              ),
            ),

            // ListTile for English
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('en'); // Change to English
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'en'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.black,
                size: 20,
              ),
              title: Text(
                languageProvider.localizedStrings['English'] ?? "English",
              ),
            ),
            // ListTile for French
            ListTile(
              onTap: () {
                languageProvider.changeLanguage('nl'); // Change to French
                Navigator.pop(context);
              },
              trailing: Icon(
                languageProvider.currentLanguage == 'nl'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Colors.black,
                size: 20,
              ),
              title: Text(
                languageProvider.localizedStrings['French'] ?? "French",
              ),
            ),

            // ListTile for Portuguese
          ],
        ),
      ),
    );
  }
}
