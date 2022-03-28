import 'package:flutter/material.dart';

class NewAuthenticationView extends StatefulWidget {
  const NewAuthenticationView({Key? key}) : super(key: key);

  @override
  _NewAuthenticationViewState createState() => _NewAuthenticationViewState();
}

class _NewAuthenticationViewState extends State<NewAuthenticationView> {
  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    return Scaffold(
      body: Column(
        children: [
          Text("Registrieren"),
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                Center(child: Text("1")),
                Center(child: Text("2")),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }
}
