import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/application/auth/prefs_handler.dart';
import 'package:lebenswiki_app/presentation/providers/category_provider.dart';
import 'package:lebenswiki_app/presentation/providers/user_provider.dart';
import 'package:lebenswiki_app/router.dart';
import 'package:lebenswiki_app/data/category_api.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await dotenv.load(fileName: ".env");
  (String, User?) initRouteResults = await getRoute();
  List<Category> categories = await CategoryApi().getCategories();
  GoRouter router = createRouter(initRouteResults.$1);

  // Test Token
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c30e1c85e3fcf934335f96d328f23ae0@o4506802868846592.ingest.sentry.io/4506802920226816';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(
          child: LebenswikiApp(
        user: initRouteResults.$2,
        categories: categories,
        router: router,
      )),
    ),
  );
}

Future<(String, User?)> getRoute() async {
  final TokenHandler tokenHandler = TokenHandler();
  String? token = await tokenHandler.get();

  if (token == null || token == "") {
    return ("/register", null);
  }

  if ((await PrefHandler.isBrowsingAnonymously()) && token == "") {
    return ("/", null);
  }

  Either<CustomError, User> authResult =
      await UserApi().authenticate(token: token);
  if (authResult.isLeft) {
    await TokenHandler().delete();
    return ("/login", null);
  }
  if (authResult.isRight) {
    return ("/", authResult.right);
  }
  return ("/login", null);
}

class LebenswikiApp extends ConsumerWidget {
  final User? user;
  final List<Category> categories;
  final GoRouter router;

  const LebenswikiApp({
    super.key,
    this.user,
    required this.router,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user != null
          ? ref.read(userProvider).setUser(user!)
          : ref.read(userProvider).removeUser();
      ref.read(categoryProvider).setCategories(categories);
    });
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: "root",
      title: "Lebenswiki",
      theme: buildTheme(Brightness.light),
      routerConfig: router,
    );
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
