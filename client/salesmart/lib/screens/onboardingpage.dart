import 'package:flutter/material.dart';
import 'package:salesmart/screens/intropage1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:salesmart/screens/intropage2.dart';
import 'package:salesmart/screens/intropage3.dart';
import 'package:salesmart/screens/register.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool Onlastpage = false;
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              Onlastpage = (index == 2);
            });
          },
          children: const [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),
        Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    //_controller.jumpToPage(3);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RegisterScreen();
                    }));
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                Onlastpage
                    ? GestureDetector(
                        onTap: () {
                          // _controller.nextPage(
                          //     duration: const Duration(milliseconds: 500),
                          //     curve: Curves.easeIn);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const RegisterScreen();
                          }));
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 245, 232, 113),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: const Center(
                              child: Icon(
                            Icons.arrow_forward_sharp,
                            color: const Color.fromARGB(255, 12, 60, 133),
                          )),
                        ),
                      )
              ],
            ))
      ],
    ));
  }
}
