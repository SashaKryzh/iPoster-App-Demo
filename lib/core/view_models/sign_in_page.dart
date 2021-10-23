import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/view_models/base_view_model.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class SignInPageViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String error;

  String _email;
  String _password;

  void setEmail(String text) => _email = text;
  void setPassword(String text) => _password = text;

  SignInPageViewModel(BuildContext context) : super(context: context);

  void showLoading() {
    isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    isLoading = false;
    notifyListeners();
  }

  void onSignInPressed() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      showLoading();
      error = await authService.signIn(_email, _password);
      if (error != null) {
        hideLoading();
      }
    }
  }

  void _redirectToWebsite(String url) async {
    // Uncomment to show dialog before to Web
    // showOnlyOnWebsiteDialog(context).then((_) async {
    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url, forceSafariVC: false);
    }
    // });
  }

  void onSignUpPressed() {
    _redirectToWebsite(iPosterAPI.baseUrl + '/signup');
  }

  void onForgotPasswordPressed() {
    _redirectToWebsite(iPosterAPI.baseUrl + '/login');
  }

  void onAppleSignInPressed() async {
    showLoading();
    // error = await authService.signInWithApple();
    error = await authService.signIn('_email', '_password');
    if (error != null) {
      hideLoading();
    }
  }

  void onGoogleSignInPressed() async {
    showLoading();
    error = await authService.signIn('_email', '_password');
    if (error != null) {
      hideLoading();
    }
  }
}
