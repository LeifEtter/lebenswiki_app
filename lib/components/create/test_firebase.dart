import 'package:flutter/material.dart';
import 'package:lebenswiki_app/components/create/data/example_data.dart';
import 'package:lebenswiki_app/components/create/data/models.dart';
import 'package:lebenswiki_app/data/loading.dart';

class FireBaseTest extends StatefulWidget {
  const FireBaseTest({Key? key}) : super(key: key);

  @override
  State<FireBaseTest> createState() => _FireBaseTestState();
}

class _FireBaseTestState extends State<FireBaseTest> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              "Testing Firebase",
            ),
            const SizedBox(height: 50),
            Container(),
            FutureBuilder(
              future: getPacks(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null || !snapshot.hasData) {
                  return const Loading();
                } else {
                  var pack = CreatorPack.fromSnapshot(snapshot);
                  return Column(
                    children: [
                      const SizedBox(height: 100),
                      Text(pack.title),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

Future getPacks() async {
  var pack = ExampleRequest().pack;
  print(pack);
  return pack;
}
