import 'package:flutter/material.dart';
import 'package:issuetracker/service/auth.dart';
import 'package:issuetracker/shared/loading.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.deepOrange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  user.photoURL ??
                      'https://www.gravatar.com/avatar/placeholder',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user.displayName ?? 'Guest',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Text(
                user.email ?? 'No email available',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().signout();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Loading();
    }
  }
}
