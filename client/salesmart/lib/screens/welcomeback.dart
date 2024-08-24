import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesmart/screens/create_account.dart';
import 'package:salesmart/screens/login_as_attendant.dart';
import 'package:salesmart/screens/login_as_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> preloadImage(BuildContext context, String imagePath) async {
    await precacheImage(AssetImage(imagePath), context);
  }

  @override
  Widget build(BuildContext context) {
    const imagePath = 'assets/images/welcome2.jpg'; // Your image path

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Column(
          children: [
            Text(
              "SaleSmart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.12,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(225, 128, 0, 128),
                Color.fromARGB(224, 0, 0, 0),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: preloadImage(context, imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6),
                      BlendMode.darken,
                    ),
                    child: Image.asset(
                      'assets/images/welcome1.jpg', // Replace with your actual image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Foreground content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 73,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.1,
                      ),
                      _buildLoginButton(
                        context,
                        label: 'Log in as manager',
                        onPressed: () {
                          // Add your navigation or action here
                          Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginPageManager()));
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.06),
                      _buildLoginButton(
                        context,
                        label: 'Log in as attendant',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginPageAttendant()));
                          // Add your navigation or action here
                        },
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                
                              },
                              child: const Text(
                                "Create one",
                                style: TextStyle(
                                  color: Color.fromARGB(223, 189, 179, 36),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(), // Loading indicator
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.24,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color.fromARGB(225, 128, 0, 128),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.arrow_forward_sharp,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
