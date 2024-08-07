import 'package:ACAC/common/providers/riverpod_light_dark.dart';
import 'package:ACAC/common/widgets/helper_functions/phone_call.dart';
import 'package:ACAC/common/widgets/ui/app_bar.dart';
import 'package:ACAC/common/widgets/ui/confirm_quit.dart';
import 'package:ACAC/common/widgets/ui/response_pop_up.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountInfo extends ConsumerWidget {
  static String id = 'Account_screen';
  AccountInfo({super.key});
  String feedbackText = '';
  bool isSwitched = false;
  String email = '';
  String name = '';
  LaunchLink launchLink = LaunchLink();

  Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  Future<void> fetchUserInfo() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        if (element.userAttributeKey.toString() == 'email') {
          email = element.value.toString();
        } else if (element.userAttributeKey.toString() == 'name') {
          name = element.value.toString();
        }
      }
    } on AuthException catch (e) {
      safePrint('Error fetching user attributes: ${e.message}');
    }
  }

  Center text() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          child: AnimatedTextKit(
            animatedTexts: [
              FadeAnimatedText('Digital ACAC card?'),
              FadeAnimatedText('Report a bug🐜?'),
              FadeAnimatedText('AI integration🤖? '),
              FadeAnimatedText(
                  'Does this app make finding ACAC restaurants easier?'),
              FadeAnimatedText('Is this app easy to use?'),
              FadeAnimatedText('All feedback is appreciated! '),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUserInfo(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return buildLayout(context, ref);
            }
          }
        },
      ),
    );
  }

  Widget buildLayout(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.6, // Adjust the width as needed
                            child: Text(
                              email,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {
                          const ResponsePopUp(
                            response: 'Coming Soon...😂',
                            location: DelightSnackbarPosition.top,
                            icon: Icons.error_outline,
                            color: Colors.redAccent,
                          ).showToast(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ref.watch(darkLight).theme
                                  ? Colors.white
                                  : Colors.black,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Change',
                            style: TextStyle(
                              color: ref.watch(darkLight).theme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('*******')
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all(0),
                        ),
                        onPressed: () {
                          const ResponsePopUp(
                            response: 'Coming Soon...😂',
                            location: DelightSnackbarPosition.top,
                            icon: Icons.error_outline,
                            color: Colors.redAccent,
                          ).showToast(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: ref.watch(darkLight).theme
                                ? Border.all(color: Colors.white, width: 1)
                                : Border.all(color: Colors.black, width: 1),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Change',
                            style: TextStyle(
                                color: ref.watch(darkLight).theme
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'App Appearance',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(ref.watch(darkLight).theme
                              ? 'Dark Mode🌚'
                              : 'Light Mode🌞'),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(0),
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              ref.watch(darkLight).theme == false
                                  ? null
                                  : ref.read(darkLight).toggleThemeOff();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: ref.watch(darkLight.notifier).theme
                                    ? null
                                    : Border.all(color: Colors.black, width: 1),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.light_mode,
                                  color: ref.watch(darkLight).theme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                                elevation: WidgetStateProperty.all(0),
                                padding:
                                    WidgetStateProperty.all(EdgeInsets.zero)),
                            onPressed: () {
                              ref.watch(darkLight).theme
                                  ? null
                                  : ref
                                      .read(darkLight.notifier)
                                      .toggleThemeOn();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: ref.watch(darkLight).theme
                                      ? Border.all(
                                          color: Colors.white, width: 1)
                                      : null
                                  //borderRadius: BorderRadius.circular(8),
                                  ),
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.dark_mode,
                                color: ref.watch(darkLight).theme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmQuit(
                                  destination: signOutCurrentUser,
                                  title: 'Confirm Sign Out',
                                  subtitle:
                                      'Are you sure you want to sign out?',
                                  actionButton: 'Sign Out',
                                );
                              });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Colors.red,
                                  width: 1.0), // Border color and width
                            ),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Questions or Concerns?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text('Reach out below(Tap) : '),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  launchLink.launchURL(
                                      'https://www.instagram.com/asiancanadians_carleton/');
                                },
                                child: Image.asset(
                                  'images/ig2.png',
                                  width: 50,
                                ),
                              ),
                              const SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.heavyImpact();
                                  launchLink.launchEmail(
                                      'asiancanadianscarleton@gmail.com');
                                },
                                child: Image.asset(
                                  'images/gmail.png',
                                  width: 50,
                                ),
                              )
                            ])
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBarBottom(id: AccountInfo.id),
    );
  }
}
