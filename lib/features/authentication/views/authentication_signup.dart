/*import 'package:flutter/material.dart';
import 'package:lebenswiki_app/features/authentication/helpers/authentication_functions.dart';
import 'package:lebenswiki_app/features/styling/input_styling.dart';
import 'package:lebenswiki_app/features/styling/text_styles.dart';

class OnboardingViewOld extends StatefulWidget {
  const OnboardingViewOld({Key? key}) : super(key: key);

  @override
  _OnboardingViewOldState createState() => _OnboardingViewOldState();
}

class _OnboardingViewOldState extends State<OnboardingViewOld> {
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var deviceWidth = queryData.size.width;
    return Scaffold(
      body: Form(
        key: _authFormKey,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: queryData.size.height / 6),
              Text(
                "Registrieren",
                style: LebenswikiTextStyles
                    .authenticationContent.authenticationTitle,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: deviceWidth,
                height: 200,
                child: PageView(
                  controller: _pageController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          AuthInputStyling(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: customInputDecoration(
                                  "Vorname Nachname", Icons.person),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AuthInputStyling(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: customInputDecoration(
                                  "Email", Icons.local_post_office),
                            ),
                          ),
                          const SizedBox(height: 10),
                          AuthInputStyling(
                            child: TextFormField(
                              controller: _passwordController,
                              decoration:
                                  customInputDecoration("Passwort", Icons.lock),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: AuthInputBiography(
                        child: TextFormField(
                          controller: _biographyController,
                          obscureText: false,
                          decoration: customInputDecoration(
                              "Erzähl uns was über dich",
                              Icons.note_alt_rounded),
                          minLines: 4,
                          maxLines: 5,
                        ),
                      ),
                    ),
                    Column(),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInBack);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Spacer(),
                              Text("Weiter",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  )),
                              Expanded(
                                  child: Icon(Icons.arrow_forward_ios_rounded)),
                            ],
                          ),
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
    );
  }

  InputDecoration customInputDecoration(hintText, prefixIcon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      border: InputBorder.none,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black38,
      ),
    );
  }
}*/
