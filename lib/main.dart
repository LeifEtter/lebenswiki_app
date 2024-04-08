import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:lebenswiki_app/application/auth/prefs_handler.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/data/category_api.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await dotenv.load(fileName: ".env");
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c30e1c85e3fcf934335f96d328f23ae0@o4506802868846592.ingest.sentry.io/4506802920226816';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(child: LebenswikiApp()),
    ),
  );
}

class LebenswikiApp extends ConsumerWidget {
  final TokenHandler tokenHandler = TokenHandler();

  LebenswikiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      // child: MaterialApp(home: SafeArea(child: AuthWrapper())),
      child: FutureBuilder(
          future: determineWidgetNew(ref),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return LoadingHelper.loadingIndicator();
            }
            if (snapshot.data == null) {
              print("Error during Widget determining");
              return MaterialApp(home: Scaffold(body: backendDown()));
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Lebenswiki',
              theme: buildTheme(Brightness.light),
              onGenerateRoute: generateRoute,
              initialRoute: snapshot.data,
              // initialRoute: snapshot.data,
            );
          }),
    );
  }

  Future<String> determineWidgetNew(WidgetRef ref) async {
    List<Category> existingCategories = ref.read(categoryProvider).categories;
    if (existingCategories.isEmpty) {
      List<Category> categories = await CategoryApi().getCategories();
      ref.read(categoryProvider).setCategories(categories);
    }

    // TODO: Add when adding onboarding
    // if (!(await PrefHandler.hasCompletedOnboarding())) {
    //   log("New User detected");
    //   return authRoute;
    // }
    if ((await PrefHandler.isBrowsingAnonymously())) {
      return homeRoute;
    }

    String? token = await tokenHandler.get();
    if (token == null || token == "") {
      await handleTokenInvalid(ref);
    }
    Either<CustomError, User> tokenCheckResult =
        await UserApi().authenticate(token: await tokenHandler.get() ?? "");
    bool tokenValid = tokenCheckResult.isRight;
    return tokenValid
        ? await handleTokenValid(ref, tokenCheckResult.right)
        : await handleTokenInvalid(ref);
  }

  Future<String> handleTokenValid(WidgetRef ref, User user) async {
    if (ref.read(userProvider).user == null) {
      ref.read(userProvider).setUser(user);
    }
    log("User logged in with account");
    return homeRoute;
  }

  Future<String> handleTokenInvalid(WidgetRef ref) async {
    await tokenHandler.delete();
    ref.read(userProvider).removeUser();
    bool anonymous = await PrefHandler.isBrowsingAnonymously();
    if (!anonymous) {
      log("User is not browsing anonymously and token isn't valid");
      return authRoute;
    } else {
      log("User is logged in anonymously");
      return homeRoute;
    }
  }

  Widget backendDown() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Backend wird derzeit gewartet,"),
            ),
            Text("versuche es später erneut."),
          ],
        ),
      );
}
