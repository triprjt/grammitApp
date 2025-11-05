import 'package:first_app/screens/google_login_screen.dart';
import 'package:first_app/screens/learn_more_screen.dart';
import 'package:first_app/screens/link_account_appDrawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './buildMenuItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/email_auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final storage = const FlutterSecureStorage();

  // final Uri url = Uri.parse('https://grammit.gitbook.io/hackmint/');

  // Future<void> _launchURL() async {
  //   if (!await launchUrl(url)) {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromRGBO(3, 27, 52, 1),
        child: ListView(
          children: [
            buildHeader(),
            const SizedBox(height: 48),
            ListTile(
              leading: const Icon(
                Icons.link,
                color: Colors.white,
              ),
              title: const Text(
                'Link Coding Accounts',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LinkAccountAppDrawerScreen.routeName);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
                leading: const Icon(
                  FontAwesomeIcons.commentDots,
                  color: Colors.white,
                  size: 20,
                ),
                title: const Text(
                  'Join the community',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  final Uri url =
                      Uri.parse('https://telegram.me/+nJGi4WKZA3FhZDll');
                  if (!await launchUrl(url,
                      mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $url';
                  }
                }),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              title: const Text(
                'T & C',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                final Uri url = Uri.parse('https://grammit.club');
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.live_help,
                color: Colors.white,
              ),
              title: const Text(
                'Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                final Uri url = Uri.parse('https://grammit.club');
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await storage.delete(key: 'uid');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPage(),
                    ),
                    (route) => false);
              },
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white70),
            const SizedBox(height: 16),
            buildMenuItem(
              text: 'v 1.0.0',
              icon: Icons.swap_vert_circle,
            ),
          ],
        ),
      ),
    );
  }
}
