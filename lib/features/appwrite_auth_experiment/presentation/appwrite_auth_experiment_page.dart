import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:appwrite/models.dart' as models;

class AppwriteAuthExperimentPage extends StatefulWidget {
  const AppwriteAuthExperimentPage({super.key});

  @override
  AppwriteAuthExperimentPageState createState() =>
      AppwriteAuthExperimentPageState();
}

class AppwriteAuthExperimentPageState
    extends State<AppwriteAuthExperimentPage> {
  final Account account = GetIt.instance.get<Account>();

  models.User? loggedInUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> login(String email, String password) async {
    await account.createEmailPasswordSession(email: email, password: password);
    final user = await account.get();
    setState(() {
      loggedInUser = user;
    });
  }

  Future<void> register(String email, String password, String name) async {
    await account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    await login(email, password);
  }

  Future<void> logout() async {
    await account.deleteSession(sessionId: 'current');
    setState(() {
      loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Appwrite Auth Experiment'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(loggedInUser != null
                ? 'Logged in as ${loggedInUser!.name}'
                : 'Not logged in'),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    login(emailController.text, passwordController.text);
                  },
                  child: Text('Login'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    register(emailController.text, passwordController.text,
                        nameController.text);
                  },
                  child: Text('Register'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
