import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/presentation/providers/provider_helper.dart';
import 'package:lebenswiki_app/repository/backend/token_handler.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/application/loading_helper.dart';
import 'package:lebenswiki_app/router.dart';
import 'package:lebenswiki_app/repository/constants/routing_constants.dart';
import 'package:lebenswiki_app/presentation/screens/authentication_view.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      title: 'Lebenswiki',
      theme: buildTheme(Brightness.light),
      onGenerateRoute: generateRoute,
      initialRoute: authenticationWrapperRoute,
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
        future: startOrDenySession(ref),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (LoadingHelper.isLoading(snapshot)) {
            return LoadingHelper.loadingIndicator();
          }
          return snapshot.data
              ? const NavBarWrapper()
              : const AuthenticationView();
        });
  }

  Future<bool> startOrDenySession(WidgetRef ref) async {
    bool isValid = await TokenHandler().authenticateCurrentToken();
    if (isValid) {
      //In case data has changed set Providers again
      ProviderHelper.resetSessionProviders(ref);

      await ProviderHelper.getDataAndSetSessionProviders(ref);
      return true;
    } else {
      return false;
    }
  }
}
