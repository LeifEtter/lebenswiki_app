import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/repository/constants/colors.dart';

class ViewerAppBar extends StatefulWidget {
  final String heroName;
  final String titleImage;
  final String categoryName;
  final Function? backFunction;

  const ViewerAppBar({
    Key? key,
    required this.heroName,
    required this.titleImage,
    required this.categoryName,
    this.backFunction,
  }) : super(key: key);

  @override
  State<ViewerAppBar> createState() => _ViewerAppBarState();
}

class _ViewerAppBarState extends State<ViewerAppBar> {
  double opacity = 0;

  @override
  void initState() {
    fadeIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 75,
      toolbarHeight: 70,
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10),
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.8),
          onPressed: () async {
            await widget.backFunction?.call();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.offBlack,
            size: 28,
          ),
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      pinned: false,
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        background: Hero(
          tag: widget.heroName,
          child: Image.network(
            widget.titleImage,
            fit: BoxFit.cover,
          ),
        ),
        title: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: Container(
            height: 40,
            padding: const EdgeInsets.only(
              right: 20,
              top: 15,
              left: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InfoLabel(
                  text: widget.categoryName,
                  backgroundColor: CustomColors.lightGrey,
                  fontSize: 8,
                ),
                const Spacer(),
                const Icon(
                  Icons.file_upload_outlined,
                  size: 20,
                ),
                const SizedBox(width: 15),
                Image.asset(
                  "assets/icons/clapping.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 15),
                const Icon(
                  Icons.bookmark_add_outlined,
                  size: 20,
                ),
              ],
            ),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
          ),
        ),
      ),
    );
  }

  void fadeIn() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity = 1;
    });
  }
}
