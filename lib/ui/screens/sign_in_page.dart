import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:iposter_chat_demo/core/constants/constants.dart';
import 'package:iposter_chat_demo/core/constants/palette.dart';
import 'package:iposter_chat_demo/core/utils/validators.dart';
import 'package:iposter_chat_demo/core/view_models/sign_in_page.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/view_model_provider.dart';
import 'package:iposter_chat_demo/ui/widgets/error_block.dart';
import 'package:iposter_chat_demo/ui/widgets/keyboard_hider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignInPageViewModel>(
      model: SignInPageViewModel(context),
      builder: (model) {
        Widget socialButtons() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Disable Apple sign in button for the demo
              // FutureBuilder<bool>(
              //   initialData: false,
              //   future: Provider.of<AuthService>(context, listen: false)
              //       .appleSignInAvailible,
              //   builder: (context, snapshot) {
              //     if (snapshot.data == false) {
              //       return Container();
              //     } else {
              //       return Column(
              //         children: [
              //           SizedBox(
              //             height: 50,
              //             child: SignInWithAppleButton(
              //               text: S.of(context).sign_in_with_Apple,
              //               iconAlignment: IconAlignment.left,
              //               onPressed: model.onAppleSignInPressed,
              //             ),
              //           ),
              //           SizedBox(height: kListSpaceSmall * 2),
              //         ],
              //       );
              //     }
              //   },
              // ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: SignInButton(
                  Buttons.Google,
                  onPressed: model.onGoogleSignInPressed,
                  text: S.of(context).sign_in_with_google,
                ),
              ),
              SizedBox(height: kListSpaceSmall * 2),
            ],
          );
        }

        return Scaffold(
          body: LoadingOverlay(
            isLoading: model.isLoading,
            child: KeyboardHider(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kListSpaceBig),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: constraints.maxHeight * 0.30,
                              child: Center(
                                child: Text(
                                  'iPoster.ua',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(color: Palette.black),
                                ),
                              ),
                            ),
                            if (model.error != null)
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: ErrorBlock(text: model.error),
                                  ),
                                  SizedBox(height: kListSpaceBig),
                                ],
                              ),
                            _InputFields(),
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.08),
                        socialButtons(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InputFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SignInPageViewModel>(context, listen: false);

    Widget forgotSignUpButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: model.onForgotPasswordPressed,
              child: Text(S.of(context).forgot_password),
            ),
          ),
          Container(
            height: 25,
            child: VerticalDivider(
              thickness: 0,
            ),
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: model.onSignUpPressed,
              child: Text(S.of(context).sing_up),
            ),
          ),
        ],
      );
    }

    Widget signInButton() {
      return SizedBox(
        width: double.infinity,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(kButtonBorderRadius))),
          child: Text(S.of(context).uviyty),
          onPressed: () => model.onSignInPressed(),
        ),
      );
    }

    return Form(
      key: model.formKey,
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Palette.green),
        child: Column(
          children: <Widget>[
            AutofillGroup(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (t) => emailValidator(context, t),
                    onSaved: model.setEmail,
                    autofillHints: [AutofillHints.email],
                  ),
                  SizedBox(height: kListSpaceSmall),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(labelText: S.of(context).parol),
                    validator: (t) => passwordValidator(context, t),
                    onSaved: model.setPassword,
                    autofillHints: [AutofillHints.password],
                  ),
                ],
              ),
            ),
            SizedBox(height: kListSpaceSmall),
            signInButton(),
            SizedBox(height: kListSpaceSmall),
            forgotSignUpButtons(),
          ],
        ),
      ),
    );
  }
}
