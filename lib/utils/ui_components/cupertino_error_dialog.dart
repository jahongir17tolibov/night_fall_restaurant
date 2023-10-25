import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget errorDialog({
  required String errorText,
  required BuildContext context,
}) =>
    CupertinoAlertDialog(
      insetAnimationCurve: Curves.easeIn,
      insetAnimationDuration: const Duration(milliseconds: 1000),
      title: Text(
        'Error on fetching data',
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'Ktwod',
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            errorText,
            style: TextStyle(
              fontFamily: 'Ktwod',
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'RETRY',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Ktwod',
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
