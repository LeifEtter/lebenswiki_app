import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lebenswiki_app/api/general/result_model_api.dart';
import 'package:lebenswiki_app/api/user_api.dart';
import 'package:lebenswiki_app/features/authentication/components/custom_form_field.dart';
import 'package:lebenswiki_app/features/authentication/providers/auth_providers.dart';
import 'package:lebenswiki_app/features/common/components/buttons/authentication_buttons.dart';
import 'package:lebenswiki_app/features/common/components/nav/top_nav.dart';
import 'package:lebenswiki_app/models/enums.dart';
import 'package:lebenswiki_app/models/user_model.dart';
import 'package:lebenswiki_app/providers/providers.dart';

//TODO show popups for succesfull changing
//TODO implement proper validation
//TODO adapt biography field
class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final UserApi userApi = UserApi();
  late User user;
  late FormNotifier _formProvider;
  final GlobalKey<FormState> _authFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.watch(userProvider).user!;
    _formProvider = ref.watch(formProvider);
    _formProvider.convertFromUser(user);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _authFormKey,
        child: ListView(
          children: [
            const TopNav(pageName: "Profil", backName: "Menu"),
            const SizedBox(height: 10.0),
            CircleAvatar(
              child: ClipOval(child: Image.network(user.profileImage)),
              radius: 45,
            ),
            const SizedBox(height: 10.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Profilbild"),
            ),
            CustomInputField(
              initialValue: user.profileImage,
              paddingTop: 5,
              hintText: "Profilbild",
              errorText: _formProvider.profileImage.error,
              onChanged: _formProvider.validateProfileImage,
              iconData: Icons.image,
            ),
            const SizedBox(height: 10.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Biografie"),
            ),
            const SizedBox(height: 5),
            CustomInputField(
              paddingTop: 5,
              initialValue: user.biography,
              hintText: "Biography",
              onChanged: _formProvider.validateBiography,
              errorText: _formProvider.biography.error,
              iconData: Icons.note_alt_rounded,
            ),
            const SizedBox(height: 30.0),
            CustomInputField(
              initialValue: user.name,
              paddingTop: 5,
              hintText: "Vorname Nachname",
              errorText: _formProvider.name.error,
              iconData: Icons.person,
              onChanged: _formProvider.validateName,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-Z]+|\s"),
                )
              ],
            ),
            const SizedBox(height: 15.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Email Adresse"),
            ),
            CustomInputField(
              initialValue: user.email,
              paddingTop: 5,
              hintText: "Email Adresse",
              onChanged: _formProvider.validateEmail,
              errorText: _formProvider.email.error,
              iconData: Icons.local_post_office,
            ),
            const SizedBox(height: 30),
            AuthenticationButton(
              text: "Änderungen Speichern",
              color: Colors.blue,
              onPress: () => update(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Altes Passwort"),
            ),
            const SizedBox(height: 5.0),
            CustomInputField(
              paddingTop: 5,
              hintText: "Altes Passwort",
              onChanged: _formProvider.validatePassword,
              errorText: _formProvider.password.error,
              iconData: Icons.key,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Neues Passwort"),
            ),
            const SizedBox(height: 5.0),
            CustomInputField(
              paddingTop: 5,
              hintText: "Neues Passwort",
              onChanged: _formProvider.validatePassword,
              errorText: _formProvider.password.error,
              iconData: Icons.key,
              isPassword: true,
            ),
            const SizedBox(height: 15.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Neues Passwort wiederholen"),
            ),
            CustomInputField(
              paddingTop: 5,
              hintText: "Neues Passwort Wiederholen",
              onChanged: _formProvider.validateRepeatPassword,
              errorText: _formProvider.repeatPassword.error,
              iconData: Icons.key,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            AuthenticationButton(
              text: "Passwort Speichern",
              color: Colors.blue,
              onPress: () => changePassword(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  void update() {
    //TODO create user object for updatin
    //TODO set user provider to new user

    /*
      Probably by implementing a new method insie the user notifier
      that updates the user variable to the passed value and calls
      "notifyListeners()""
    */
    User newUser = _formProvider.convertToUser();
    userApi.updateProfile(user: newUser).then((ResultModel result) {
      if (result.type == ResultType.success) {
        setState(() {});
      } else {}
    });
  }

  void changePassword() {
    userApi
        .updatePassword(
            oldpassword: _formProvider.oldPassword.value ?? "",
            password: _formProvider.password.value ?? "")
        .then((ResultModel result) {
      if (result.type == ResultType.success) {
      } else {}
    });
  }
}
