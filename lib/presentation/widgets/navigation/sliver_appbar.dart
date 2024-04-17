import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/presentation/widgets/common/labels.dart';
import 'package:lebenswiki_app/presentation/constants/colors.dart';

class ViewerAppBar extends StatefulWidget {
  final String heroName;
  final String titleImage;
  final String categoryName;
  final Future<void> Function()? backFunction;
  final Function shareCallback;
  final Function clapCallback;
  final Function bookmarkCallback;
  final int clapCount;
  final Icon bookmarkIcon;

  const ViewerAppBar({
    Key? key,
    required this.heroName,
    required this.titleImage,
    required this.categoryName,
    this.backFunction,
    required this.shareCallback,
    required this.clapCallback,
    required this.bookmarkCallback,
    required this.clapCount,
    required this.bookmarkIcon,
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
            if (widget.backFunction != null) {
              await widget.backFunction!();
            } else {
              context.pop();
            }
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
          child: widget.titleImage.startsWith("assets/")
              ? Image.asset(widget.titleImage, fit: BoxFit.cover)
              : Image.network(
                  widget.titleImage.replaceAll("https", "http"),
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
              top: 10,
              left: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
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
                // IconButton(
                //   constraints: const BoxConstraints(),
                //   onPressed: () => widget.shareCallback(),
                //   icon: const Icon(
                //     Icons.file_upload_outlined,
                //     size: 20,
                //   ),
                // ),
                GestureDetector(
                  onTap: () => widget.clapCallback(),
                  child: Row(
                    children: [
                      Text(Emoji.byName("clapping hands").toString(),
                          style: const TextStyle(fontSize: 17.0)),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 0),
                        child: Text(
                          widget.clapCount.toString(),
                          style: TextStyle(
                              color: CustomColors.offBlack, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  onPressed: () => widget.bookmarkCallback(),
                  icon: widget.bookmarkIcon,
                ),
              ],
            ),
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
