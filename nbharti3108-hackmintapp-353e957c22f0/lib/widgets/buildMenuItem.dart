import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
//import '../models/profile.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class buildMenuItem extends StatefulWidget {
  @required
  String? text;
  @required
  IconData? icon;

  buildMenuItem({this.text, this.icon});

  @override
  State<buildMenuItem> createState() => _buildMenuItemState();
}

class _buildMenuItemState extends State<buildMenuItem> {
  VoidCallback? onclicked;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(widget.icon, color: color),
      title: Text(widget.text!, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: () {},
    );
  }
}

class buildHeader extends StatefulWidget {
  @override
  State<buildHeader> createState() => _buildHeaderState();
}

class _buildHeaderState extends State<buildHeader> {
  //String _customerName = '';
  //String _avatarUrl = '';

  Future<void> _loadCustomerDetails() async {
    //final prefs = await SharedPreferences.getInstance();
    setState(() {
      //_customerName = (prefs.getString('_customerName') ?? '');
      //_avatarUrl = (prefs.getString('_avatarUrl'));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    //final changeUserProfile = Provider.of<Profile>(context);
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Avatar(
            //avatarUrl: _avatarUrl,
            onTap: () {
              //Navigator.of(context).pushNamed(ProfileScreen.routeName);
              //Set state to update the current user
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Hi ' + '! ' + ' Welcome to GrammIt',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatefulWidget {
  String? avatarUrl;
  final Function? onTap;

  Avatar({this.avatarUrl, this.onTap});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  // Future<void> _loadCustomerDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     widget.avatarUrl = (prefs.getString('_avatarUrl'));
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //_loadCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        //onTap: widget.onTap,
        child: Center(
            child: Stack(children: [
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(width: 3, color: Colors.white),
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                spreadRadius: 2,
                color: Colors.white.withOpacity(0.1))
          ],
          shape: BoxShape.circle,
        ),
        child: ClipOval(
            child: const Image(image: AssetImage('lib/icons/avatar.png'))),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 4,
              color: Colors.white,
            ),
            color: Colors.blue,
          ),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
    ])));
  }
}
