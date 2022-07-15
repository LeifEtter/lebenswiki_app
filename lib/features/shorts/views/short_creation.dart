import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/features/shorts/api/short_api.dart';
import 'package:lebenswiki_app/features/common/components/tab_bar.dart';
import 'package:lebenswiki_app/features/common/components/buttons/main_buttons.dart';
import 'package:lebenswiki_app/models/category_model.dart';
import 'package:lebenswiki_app/features/shorts/models/short_model.dart';
import 'package:lebenswiki_app/features/menu/views/your_shorts_view.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

class CreateShort extends ConsumerStatefulWidget {
  const CreateShort({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateShortState();
}

class _CreateShortState extends ConsumerState<CreateShort> {
  final ShortApi shortApi = ShortApi();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  int currentCategory = 0;

  @override
  Widget build(BuildContext context) {
    final List<ContentCategory> categories =
        ref.watch(categoryProvider).categories;
    final User user = ref.watch(userProvider).user;
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: categories.length,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        CloseButton(),
                      ],
                    ),
                    buildTabBar(
                        categories: categories,
                        callback: (int value) => setState(() {
                              currentCategory = value;
                            })),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Titel",
                          border: InputBorder.none,
                        ),
                        controller: _titleController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: _buildProfileIndicator(user.profileImage),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: "Was geht dir durch den Kopf?",
                                border: InputBorder.none,
                              ),
                              controller: _contentController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  right: 15.0,
                  bottom: 20.0,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 150,
                      child: Row(children: [
                        lebenswikiBlueButtonInverted(
                            text: "Entwürfe", callback: navigateToDrafts),
                        lebenswikiBlueButtonNormal(
                          text: "Post",
                          callback: () => createCallback(
                              categories: categories, user: user),
                        ),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToDrafts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YourShorts(
          chosenTab: 1,
        ),
      ),
    );
  }

  Widget _buildProfileIndicator(String profileImage) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(profileImage),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  //TODO implement succesfull popup
  void createCallback({
    required User user,
    required List<ContentCategory> categories,
  }) {
    shortApi
        .createShort(
            short: Short(
          id: 0,
          categories: [categories[currentCategory]],
          title: _titleController.text.toString(),
          content: _contentController.text.toString(),
          creator: user,
          creationDate: DateTime.now(),
        ))
        .then(
          (_) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const YourShorts(
                chosenTab: 1,
              ),
            ),
          ),
        );
  }
}
