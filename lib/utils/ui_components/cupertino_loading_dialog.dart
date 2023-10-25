import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoAlertDialog loadingDialog({required BuildContext context}) =>
    CupertinoAlertDialog(
      insetAnimationCurve: Curves.easeIn,
      insetAnimationDuration: const Duration(milliseconds: 1000),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoActivityIndicator(
            color: Theme.of(context).colorScheme.onBackground,
            radius: 14.0,
          ),
          const SizedBox(height: 6.0),
          Text(
            'Loading',
            style: TextStyle(
              fontFamily: 'Ktwod',
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
