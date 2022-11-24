import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:lebenswiki_app/domain/models/pack_content_models.dart';
import 'package:lebenswiki_app/domain/models/pack_model.dart';
import 'package:lebenswiki_app/presentation/providers/provider_helper.dart';
import 'package:lebenswiki_app/presentation/screens/creator/new_creator_screen.dart';
import 'package:lebenswiki_app/presentation/screens/other/onboarding.dart';
import 'package:lebenswiki_app/presentation/widgets/interactions/custom_flushbar.dart';
import 'package:lebenswiki_app/repository/backend/token_handler.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/application/other/loading_helper.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/repository/backend/user_api.dart';
import 'package:lebenswiki_app/repository/constants/routing_constants.dart';
import 'package:lebenswiki_app/presentation/screens/other/authentication.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'repository/firebase_options.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum AuthType {
  newUser,
  loggedOut,
  error,
  user,
  anonymous,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lebenswiki',
        theme: buildTheme(Brightness.light),
        onGenerateRoute: generateRoute,
        initialRoute: authenticationWrapperRoute,
      ),
    );
  }
}

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool sessionIsPossible = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: determineWidget(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (LoadingHelper.isLoading(snapshot)) {
            return LoadingHelper.loadingIndicator();
          }
          return snapshot.data!;
        });
  }

  Future<Widget> determineWidget() async {
    return NewCreatorScreen(
      pack: Pack(
        title: "Something",
        description: "Something",
        pages: [
          PackPage(items: [], pageNumber: 1),
          PackPage(items: [], pageNumber: 2),
          PackPage(items: [], pageNumber: 3)
        ],
        categories: [],
        titleImage: "asdamdlaskdm",
        creatorId: 0,
      ),
    );
    SharedPreferences _shared = await SharedPreferences.getInstance();
    String? existingToken = await TokenHandler().get();
    //TODO Test token stuff

    //Get Auth Type from Storage and transform into enum
    String? authTypeString = _shared.getString("authType") ?? "newUser";
    AuthType authType =
        EnumToString.fromString(AuthType.values, authTypeString) ??
            AuthType.error;

    //If Token exists set authType to user
    /*if (existingToken != null) {
      authType = AuthType.user;
    }*/

    switch (authType) {
      case AuthType.newUser:
        return const OnboardingViewStart();
      case AuthType.loggedOut:
        return const AuthenticationView();
      case AuthType.error:
        return const Center(child: Text("Etwas ist schiefgelaufen"));
      case AuthType.anonymous:
        bool authenticated = await UserApi().authenticate();
        if (authenticated) {
          ProviderHelper.resetSessionProviders(ref);
          await ProviderHelper.getDataAndSessionProvidersForAnonymous(ref);
          return const NavBarWrapper();
        } else {
          Either<CustomError, String> loginResult =
              await UserApi().loginAnonymously();
          if (loginResult.isLeft) {
            CustomFlushbar.error(
                    message: "Du konntest nicht anonym angemeldet werden")
                .show(context);
            return const AuthenticationView();
          } else {
            await TokenHandler().set(loginResult.right);
            return const NavBarWrapper();
          }
        }
      case AuthType.user:
        bool authenticated = await UserApi().authenticate();
        if (authenticated) {
          ProviderHelper.resetSessionProviders(ref);
          await ProviderHelper.getDataAndSetSessionProviders(ref);
          return const NavBarWrapper();
        } else {
          CustomFlushbar.error(
                  message:
                      "Du wurdest ausgeloggt und musst dich wieder einloggen")
              .show(context);
          return const AuthenticationView();
        }
    }
  }
}
