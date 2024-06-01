import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:issuetracker/service/auth.dart';
import 'package:issuetracker/shared/loading.dart';

class Detail {
  final String title;
  final String description;
  final String location;
  final String imageurl;

  const Detail(this.title, this.description, this.location, this.imageurl);
}

class Issue extends StatefulWidget {
  const Issue({super.key});

  @override
  State<Issue> createState() => _IssueState();
}

void showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // Navigate to profile screen
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Perform logout action
              AuthService().signout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      );
    },
  );
}

class _IssueState extends State<Issue> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _issueStream =
      FirebaseFirestore.instance.collection('issues').snapshots();
  late final List<Detail> detailInfo;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String location1 = '';

// when issue tapped takes the tapped to detail screen
    void _sendDataToDetailScreen(BuildContext context) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              text: location1,
            ),
          ));
    }

    Color getStatusColor(String status) {
      switch (status) {
        case 'In progress':
          return Colors.red;
        case 'pending':
          return Colors.amber;
        case 'completed':
          return Colors.green;
        default:
          return Colors.yellow;
      }
    }

    IconData getStatusIcon(String status) {
      switch (status) {
        case 'In progress':
          return Icons
              .autorenew; // Change this to an appropriate icon for 'In progress'
        case 'pending':
          return Icons
              .pending; // Change this to an appropriate icon for 'pending'
        case 'completed':
          return Icons
              .check_circle; // Change this to an appropriate icon for 'completed'
        default:
          return Icons.info; // Default icon
      }
    }

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        // backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
        title: const Text('Issues Reported'),
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

      //Main Body
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _issueStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Something went wrong :/',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }

            // Issue box
            final data = snapshot.requireData;

            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    location1 = data.docs[index].get('location');
                    _sendDataToDetailScreen(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  data.docs[index].get('imageUrl'),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.docs[index].get('category'),
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      data.docs[index].get('location'),
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        width: 100,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: getStatusColor(
                                              data.docs[index].get('status')),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data.docs[index].get('status'),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                                width:
                                                    4.0), // Space between text and icon
                                            Icon(
                                              getStatusIcon(data.docs[index]
                                                  .get('status')),
                                              color: Colors.white,
                                              size: 16.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
        ],
        // fixedColor: Colors.blueGrey[200],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/reportIssue');
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    ));
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.text});

  final String text;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Stream<QuerySnapshot> _issueStream;
  int vote = 0;

  @override
  void initState() {
    super.initState();
    _issueStream = FirebaseFirestore.instance
        .collection('issues')
        .where('location', isEqualTo: widget.text)
        .snapshots();
  }

  void incVote() {
    setState(() {
      vote++;
    });
  }

  void decVote() {
    setState(() {
      if (vote == 0) {
      } else {
        vote--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Issues in ${widget.text}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _issueStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot issue = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          issue.get('imageUrl'),
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.get('category'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              issue.get('description'),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Location',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              issue.get('location'),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Reported By',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              issue.get('name'),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              issue.get('email'),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Upvote or Devote to show authorities the urgency of this issue.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_upward,
                                      size: 30, color: Colors.green),
                                  onPressed: incVote,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  vote.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                  onPressed: decVote,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
