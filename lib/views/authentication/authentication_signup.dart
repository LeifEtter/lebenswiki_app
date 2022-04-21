import 'package:flutter/material.dart';
import 'package:lebenswiki_app/helper/auth/authentication_functions.dart';
import 'package:lebenswiki_app/components/input/input_styling.dart';
import 'package:lebenswiki_app/data/text_styles.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  //final TextEditingController _profileImageController = TextEditingController();
  final PageController _pageController = PageController();
  Map errorMap = {
    "name": "",
    "email": "",
    "password": "",
    "biography": "",
  };

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
                          errorHint("name"),
                          const SizedBox(height: 10),
                          AuthInputStyling(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: customInputDecoration(
                                  "Email", Icons.local_post_office),
                            ),
                          ),
                          errorHint("email"),
                          const SizedBox(height: 10),
                          AuthInputStyling(
                            child: TextFormField(
                              controller: _passwordController,
                              decoration:
                                  customInputDecoration("Passwort", Icons.lock),
                            ),
                          ),
                          errorHint("password"),
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
}
