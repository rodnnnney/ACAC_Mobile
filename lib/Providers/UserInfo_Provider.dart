import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

final pb = PocketBase('https://acac2-thrumming-wind-3122.fly.dev');

class UserInfo extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _password = '';
  dynamic _authData = '';

  int selected = 0;
  bool signInAcc = false;
  bool signInAuth2 = false;

  void signedInWithAccount() {
    signInAcc = true;
    notifyListeners();
  }

  void signedInWithO2Auth() {
    signInAuth2 = true;
    notifyListeners();
  }

  String get name => _name;

  String get email => _email;

  String get password => _password;

  dynamic get authData => _authData;

  set setName(String name) {
    _name = name;
    notifyListeners();
  }

  set setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  set setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void set setO2AuthData(dynamic authData) {
    authData = authData;
    notifyListeners();
  }

  set setAuthData(dynamic inputAuthData) {
    _authData = inputAuthData;
    notifyListeners();
  }

  void setUserDetails() {}

  Future<void> signIn(String email, String password) async {
    try {
      final authData =
          await pb.collection('users').authWithPassword(email, password);
      setAuthData = authData;
      notifyListeners();
    } on ClientException catch (e) {
      print('$e\n');
      print(e.response);
      print(e.response['data']);
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      final body = <String, dynamic>{
        "email": email,
        "emailVisibility": true,
        "password": password,
        "passwordConfirm": password,
        "name": name,
      };
      final record = await pb.collection('users').create(body: body);
      print(await pb.authStore.model);
    } on ClientException catch (e) {
      print('$e\n');
      print(e.response['response']);
    }
  }

  Future<void> sendFeedBack(String feedback, String email) async {
    final body = <String, dynamic>{
      "field": pb.authStore.model.id,
      "feedback": feedback,
      'email': email,
    };
    final record = await pb.collection('feedback').create(body: body);
    print(record);
  }

  Future<void> o2AthSendFeedBack(
      String feedback, String email, dynamic id) async {
    final body = <String, dynamic>{
      "feedback": feedback,
      "field": id,
      'email': email,
    };
    final record = await pb.collection('feedback').create(body: body);
    print(record);
  }

  void setNum(int hover) {
    selected = hover;
    notifyListeners();
  }

  Future<void> signOut() async {
    pb.authStore.clear();
    setName = '';
    setEmail = '';
    setPassword = '';
    notifyListeners();
  }

  Future<bool> emailExists(String email) async {
    try {
      var list =
          await pb.collection('users').getList(filter: 'email = "$email"');
      return list.items.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }

  Future<void> O2AuthSignUp() async {
    // final Uri url = Uri.parse(
    //     'https://acac2-thrumming-wind-3122.fly.dev/api/oauth2-redirect');
    final authData = await pb.collection('users').authWithOAuth2(
      'google',
      (url) async {
        await launchUrl(url);
      },
    );
  }

  void getInfo() {
    print(pb.authStore.isValid);
  }

  void sendUserAuthMail(String email) async {
    try {
      // Sends the user's verification email and waits for the operation to complete
      await pb.collection('users').requestVerification(email);
      // If the requestVerification method completes without throwing an error, the email was sent
      print("Email sent successfully to $email.");
    } catch (e) {
      // If an error occurs, it will be caught here and you can handle it accordingly
      print("Failed to send email to $email. Error: $e");
    }
  }
}
