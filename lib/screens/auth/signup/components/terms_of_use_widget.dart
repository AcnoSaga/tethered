import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tethered/screens/components/policy_dialog.dart';
import 'package:tethered/utils/text_styles.dart';

class TermsOfUseWidget extends StatelessWidget {
  const TermsOfUseWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "By creating an account, you are agreeing to our\n",
            style: TetheredTextStyles.passiveTextButton,
            children: [
              TextSpan(
                text: "Terms & Conditions ",
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showModal(
                      context: context,
                      configuration: FadeScaleTransitionConfiguration(),
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      },
                    );
                  },
              ),
              TextSpan(text: "and "),
              TextSpan(
                text: "Privacy Policy! ",
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialog(
                          mdFileName: 'privacy_policy.md',
                        );
                      },
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
