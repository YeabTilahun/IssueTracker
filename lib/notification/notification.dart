// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print
import 'package:flutter/material.dart';
// import 'package:issuetracker/PAGES/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:issuetracker/service/auth.dart';

void showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Navigate to profile screen
              Navigator.pushNamed(context, '/profile');
              // runApp(ProfilePage());
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Perform logout action
              AuthService().signout();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void messageDisplay(context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text(
      'Detail Info will be available soon!',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
  ));
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
        title: const Text('Notification'),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                showOptions(context);
              },
              child: SizedBox(
                height: 45,
                width: 45,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user?.photoURL ??
                        'https://www.gravatar.com/avatar/placeholder',
                  ),
                ),
              ))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            title:
                Text('The issue you reported on 03/21/2024 has been resolved'),
            subtitle: Text('Thank you for reporting the issue!'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              messageDisplay(context);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            title:
                Text('The issue you reported on 03/12/2024 has been resolved'),
            subtitle: Text('Thank you for reporting the issue!'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              messageDisplay(context);
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            title:
                Text('The issue you reported on 03/23/2024 has been resolved'),
            subtitle: Text('Thank you for reporting the issue!'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              messageDisplay(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(
                FontAwesomeIcons.bell,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
            label: 'notification',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(
                FontAwesomeIcons.exclamationCircle,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/issue');
              },
            ),
            label: 'Issue',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(
                FontAwesomeIcons.user,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            label: 'profile',
          ),
        ],
        // fixedColor: Colors.blueGrey[200],
      ),
    );
  }
}
