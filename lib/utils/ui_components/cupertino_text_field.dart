import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/main_tables/bloc/tables_bloc.dart';
import '../helpers.dart';

Widget _buildTextField({
  required String hintText,
  required BuildContext context,
  required TablesState state,
  required bool isObscure,
  required TextEditingController controller,
}) =>
    SizedBox(
      width: fillMaxWidth(context),
      height: 36.0,
      child: CupertinoTextField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        cursorColor: Theme.of(context).colorScheme.secondary,
        cursorOpacityAnimates: true,
        maxLength: 10,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          letterSpacing: 2.0,
          fontFamily: 'Ktwod',
          fontSize: 17.0,
        ),
      ),
    );
