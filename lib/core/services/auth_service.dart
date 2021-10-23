// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:iposter_chat_demo/core/models/iposter_user.dart';
import 'package:iposter_chat_demo/core/providers/app_localization_provider.dart';
import 'package:iposter_chat_demo/core/services/iposter_auth.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/globals.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

enum AuthState {
  NOT_DETERMINED,
  NOT_SIGNED_IN,
  SIGNED_IN,
}

class _SignInOption {
  static const firebase = 'firebaseSignIn';
  static const iPoster = 'iposterSignIn';
}

class AuthService with ChangeNotifier {
  static const _lastSignInOptionKey = 'lastSignInOptionKey';

  // final _auth = FirebaseAuth.instance;
  // final _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _iPosterAuth = iPosterAuth();

  final _secureStorage = storage.FlutterSecureStorage();

  AuthState _authState = AuthState.NOT_DETERMINED;

  String get token => _iPosterAuth.token;
  int get userId => _iPosterAuth.userId;

  AuthState get authState => _authState;

  // Future<bool> get appleSignInAvailible async {
    // return Platform.isIOS && await SignInWithApple.isAvailable();
  // }

  AuthService() {
    init();
  }

  void init() async {
    if (await _iPosterAuth.isSignedIn()) {
      bool firebaseOK = true;
      final lastSignInOption =
          await _secureStorage.read(key: _lastSignInOptionKey);
      if (lastSignInOption == _SignInOption.firebase) {
        // firebaseOK = _auth.currentUser != null;
      }
      if (firebaseOK) {
        _signInChanged(true, lastSignInOption);
      } else {
        _signInChanged(false, null);
      }
    } else {
      _signInChanged(false, null);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  set setLocaleProvider(AppLocalizationProvider provider) {
    _iPosterAuth.setLocaleProvider = provider;
  }

  // User currentFirebaseUser() {
  //   return _auth.currentUser;
  // }

  Future<iPosterAuthUser> currentIPosterUser({update = false}) async {
    final user = await _iPosterAuth.currentUser(update: update);
    if (update == true) notifyListeners();
    return user;
  }

  Future<iPosterAuthResponse> editIPosterUser(iPosterAuthUser newUser) async {
    final response = await _iPosterAuth.editUser(newUser);
    if (response.success) await currentIPosterUser(update: true);
    return response;
  }

  //
  // Don't use because user can sign in with email & password (without Firebase)
  // Insted use _signInChanged below
  //
  // void onAuthChanged(FirebaseUser user) {
  //   if (user != null) {
  //     _authState = AuthState.SIGNED_IN;
  //   } else {
  //     _authState = AuthState.NOT_SIGNED_IN;
  //   }
  //   notifyListeners();
  // }

  void _signInChanged(bool signedIn, String signInOption) {
    if (signedIn == true) {
      _authState = AuthState.SIGNED_IN;
    } else {
      _authState = AuthState.NOT_SIGNED_IN;
      _clearAuthCache();
    }

    if (signInOption != null) {
      _secureStorage.write(key: _lastSignInOptionKey, value: signInOption);
    } else {
      _secureStorage.delete(key: _lastSignInOptionKey);
    }

    notifyListeners();
  }

  Future<String> signIn(String email, String password) async {
    try {
      final response =
          await _iPosterAuth.signInWithEmailAndPassword(email, password);
      _signInChanged(response.user != null, _SignInOption.iPoster);
      return response.success ? null : response.message;
    } catch (error) {
      print(error);
      return S.of(localeContext).failed_to_sign_in;
    }
  }

  // Future<String> signInWithGoogle() async {
    // try {
      // final googleUser = await _googleSignIn.signIn();
      // final googleAuth = await googleUser.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   idToken: googleAuth.idToken,
      //   accessToken: googleAuth.accessToken,
      // );

      // final fireUser = (await _auth.signInWithCredential(credential)).user;
    //   print('FirebaseUser: ${fireUser.displayName}');

    //   final response = await _iPosterAuth
    //       .signInWithFirebaseToken(await fireUser.getIdToken());

    //   _signInChanged(response.user != null, _SignInOption.firebase);
    //   return response.success ? null : response.message;
    // } catch (error) {
    //   print(error);
    //   return S.of(localeContext).failed_to_sign_in;
    // }
  // }

  // Future<String> signInWithApple() async {
    // try {
    //   final credential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [
    //       AppleIDAuthorizationScopes.email,
    //       AppleIDAuthorizationScopes.fullName,
    //     ],
    //   );

    //   final authProvider = OAuthProvider('apple.com');
    //   final authCredential = authProvider.credential(
    //     idToken: credential.identityToken,
    //     accessToken: credential.authorizationCode,
    //   );

    //   final fireUser = (await _auth.signInWithCredential(authCredential)).user;
    //   print('Signed in: ${fireUser.displayName}');

    //   if (fireUser.displayName == null &&
    //       (credential.givenName != null || credential.familyName != null)) {
    //     String displayName =
    //         credential.givenName != null ? (credential.givenName + ' ') : '';
    //     displayName += credential.familyName ?? '';

    //     await fireUser.updateProfile(displayName: displayName);
    //   }

    //   final response = await _iPosterAuth
    //       .signInWithFirebaseToken(await fireUser.getIdToken());

    //   _signInChanged(response.user != null, _SignInOption.firebase);
    //   return response.success ? null : response.message;
    // } catch (error) {
    //   print(error);
    //   return S.of(localeContext).failed_to_sign_in;
    // }
  // }

  void signOut() {
    _signInChanged(false, null);
  }

  void _clearAuthCache() {
    // _googleSignIn.signOut();
    // _auth.signOut();
    _iPosterAuth.signOut();
  }
}
