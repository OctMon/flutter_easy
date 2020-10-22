// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `System default`
  String get systemDefault {
    return Intl.message(
      'System default',
      name: 'systemDefault',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Example`
  String get example {
    return Intl.message(
      'Example',
      name: 'example',
      desc: '',
      args: [],
    );
  }

  /// `Picture waterfall flow`
  String get example_PictureWaterfallFlow {
    return Intl.message(
      'Picture waterfall flow',
      name: 'example_PictureWaterfallFlow',
      desc: '',
      args: [],
    );
  }

  /// `Extract prominent colors from an Image`
  String get example_ExtractProminentColorsFromAnImage {
    return Intl.message(
      'Extract prominent colors from an Image',
      name: 'example_ExtractProminentColorsFromAnImage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number`
  String get example_InputPhoneNumber {
    return Intl.message(
      'Please enter phone number',
      name: 'example_InputPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get example_InputPassword {
    return Intl.message(
      'Please enter password',
      name: 'example_InputPassword',
      desc: '',
      args: [],
    );
  }

  /// `New User Registration`
  String get example_NewUserRegister {
    return Intl.message(
      'New User Registration',
      name: 'example_NewUserRegister',
      desc: '',
      args: [],
    );
  }

  /// `Forget password?`
  String get example_ForgetPassword {
    return Intl.message(
      'Forget password?',
      name: 'example_ForgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree`
  String get example_ReadAndAgree {
    return Intl.message(
      'I have read and agree',
      name: 'example_ReadAndAgree',
      desc: '',
      args: [],
    );
  }

  /// `"User Agreement"`
  String get example_UserAgreement {
    return Intl.message(
      '"User Agreement"',
      name: 'example_UserAgreement',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get example_And {
    return Intl.message(
      'and',
      name: 'example_And',
      desc: '',
      args: [],
    );
  }

  /// `"Privacy Policy"`
  String get example_PrivacyPolicy {
    return Intl.message(
      '"Privacy Policy"',
      name: 'example_PrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Need to agree to continue using`
  String get example_AgreeToContinueTip {
    return Intl.message(
      'Need to agree to continue using',
      name: 'example_AgreeToContinueTip',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get example_ValidPhoneNumberTip {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'example_ValidPhoneNumberTip',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}