/*
  TODO:
    - Finish Edit Profile
    - Refactor code
    - Add documentation
    - Create Tests (for edit profile)
    - Finish Settings Page
*/

import 'package:flutter/material.dart';

void main() {

  // Declare User Account
  final userAccount = Account(
    name: 'Jane Doe',
    type: 'Rescuer',
    image: const AssetImage('assets/images/placeholder.png'),
    contactNumber: '(+63) 920 123 4567',
    address: 'Alumni Engineers Centennial Hall P. Velasquez St., University of the Philippines Diliman, Quezon City',
    emailAddress: 'janedoe@email.com',
  );

  runApp(MainApp(account: userAccount,));
}

class Account {
  final String name; // user's name
  final String type; // Rescuer or Citizen
  final AssetImage image; // profile picture
  final String contactNumber;
  final String address;
  final String emailAddress;


  Account({
    required this.name,
    required this.type,
    required this.image,
    required this.contactNumber,
    required this.address,
    required this.emailAddress,
  });
}

class MainApp extends StatelessWidget {
  final Account account;

  const MainApp({required this.account, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color.fromRGBO(43, 58, 103, 1),

        // declare different text themes
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 40,
            color: Color.fromRGBO(43, 58, 103, 1),
            fontWeight: FontWeight.bold,
          ),

          titleMedium: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 24,
            color: Color.fromRGBO(43, 58, 103, 1),
          ),

          displayMedium: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 20,
            color: Color(0xFFFFFFFF),
          ),

          displaySmall: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 12,
            color: Color(0xFFFFFFFF),
          ),

          labelLarge: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 20,
            color: Color.fromRGBO(43, 58, 103, 1),
            fontWeight: FontWeight.bold,
          ),

          labelMedium: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 16,
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
          ),

          labelSmall: TextStyle(
            fontFamily: "WixMadeforText",
            fontSize: 12,
            color: Color.fromRGBO(255, 236, 130, 1)
          ),
        ),
      ),
      home: Home(account: account),
    );
  }
}

class Home extends StatefulWidget {
  final Account account;

  const Home({required this.account, super.key});

  @override
  State<Home> createState() => _MenuState();
}

class _MenuState extends State<Home> {
  late final Account account;
  late final List<Map<String, dynamic>> drawerItems;

  @override
  void initState() {
    super.initState();
    // Access the account
    account = widget.account; 
    drawerItems = [
      {
        'icon': Icons.account_circle,
        'title': 'Profile',
        'page': ProfileScreen(account: account),
      },
      {
        'icon': Icons.settings,
        'title': 'Settings',
        'page': const SettingsScreen()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            MenuHeader(account: account),
            ...drawerItems.map((item) => ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['page']),
                    );
                  },
                )),
          ],
        ),
      ),
      body: const Center(
        child: Text('Page: Home'),
      ),
    );
  }
}

// TODO: Finish Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text("This is the Settings Page"),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final Account account;

  const ProfileScreen({required this.account, super.key});

  @override
  Widget build(BuildContext context) {

    // Configure to add / delete which is information seen in account tab
    final List<Map<String, dynamic>> personalInformation = [
      {
        'icon': Icons.phone,
        'title': 'Contact No.',
        'body': account.contactNumber,
      },
      {
        'icon': Icons.location_city,
        'title': 'Address', 
        'body': account.address,
      },
    ];

    final List<Map<String, dynamic>> accountDetails = [
      {
        'icon': Icons.email,
        'title': 'Email Address', 
        'body': account.emailAddress,
      },
      {
        'icon': Icons.lock,
        'title': 'Password',
        // Not sure if I should show password here
        'body': '********',
      },
    ];

    return Scaffold(

      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.displayMedium),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Name & and Profile Pic Section
            Expanded(
              flex: 3,
              child: Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [

                  // profile pic
                  CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.black,
                      backgroundImage: account.image, // Use account's image here
                      child: const Icon(Icons.person, color: Colors.white,),
                  ),

                  // name and account type
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.name, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
                      Text(account.type, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),

                  // edit account button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(43, 58, 103, 1),
                    ),
                    // Go to Edit Profile Page
                    // TODO: Finish Edit Profile
                    onPressed: () => {}, 
                    child: Text("Edit Profile", style: Theme.of(context).textTheme.labelMedium,),
                  ),]
                ),
              ),
            ),

            // Personal Information + Account Details Section
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Personal Information Section
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          ...personalInformation.map((item) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(43, 58, 103, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Icon(item['icon'], color: Colors.white, size: 32),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title'],
                                                style: Theme.of(context).textTheme.labelMedium,
                                              ),
                                              Text(
                                                item['body'],
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          )),
                        ],
                      ),
                    ),

                    const Divider(height: 20.0),

                    // Account Details Section
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Details',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          ...accountDetails.map((item) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(43, 58, 103, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Icon(item['icon'], color: Colors.white, size: 32,),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: Theme.of(context).textTheme.labelMedium,
                                            ),
                                            Text(
                                              item['body'],
                                              style: Theme.of(context).textTheme.labelSmall,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            // Delete Account Button
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Delete Account', style: Theme.of(context).textTheme.labelMedium,),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// This is the top portion of the drawer
class MenuHeader extends StatelessWidget {
  final Account account;

  const MenuHeader({required this.account, super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: account.image,
            backgroundColor: Colors.black,
            child: const Icon(Icons.person, color: Colors.white,),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium),
                Text(account.type, style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
