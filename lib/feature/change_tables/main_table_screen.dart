// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/core/theme/cubit/theme_cubit.dart';
import 'package:night_fall_restaurant/di.dart';
import 'package:night_fall_restaurant/feature/home/home_screen.dart';
import 'package:night_fall_restaurant/utils/constants.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/error_widget.dart';
import 'package:night_fall_restaurant/utils/ui_components/scale_on_press_button.dart';
import 'package:night_fall_restaurant/utils/ui_components/show_snack_bar.dart';
import 'package:night_fall_restaurant/utils/ui_components/standart_text.dart';

import 'bloc/tables_bloc.dart';

class MainTableScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/tables";

  const MainTableScreen({super.key});

  static Future<void> open(BuildContext context) async {
    await Navigator.of(context).popAndPushNamed(ROUTE_NAME);
  }

  @override
  State<StatefulWidget> createState() => _MainTableScreenState();
}

class _MainTableScreenState extends State<MainTableScreen>
    with TickerProviderStateMixin {
  late AnimationController _animateController;
  late int _selectedNumber;
  late AppThemeMode _appThemeMode;
  FocusNode textFieldFocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  static const double kItemExtent = 32;

  @override
  void initState() {
    super.initState();
    _animateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _animateController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectedNumber = context.watch<TablesBloc>().selectedTable;
    _appThemeMode = context.watch<ThemeCubit>().state.appThemeMode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleAppTheme();
            },
            icon: Icon(
              _appThemeMode == AppThemeMode.light
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 32.0,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            getIt<TablesBloc>()..add(TablesOnGetPasswordsEvent()),
        child: BlocConsumer<TablesBloc, TablesState>(
          buildWhen: (previous, current) => current is! TablesActionState,
          listenWhen: (previous, current) => current is TablesActionState,
          builder: (context, state) {
            if (state is TablesSuccessState) {
              final List<int> tableNumbers =
                  state.tablePasswords.map((e) => e.tableNumber).toList();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 30),
                        //welcome text
                        Text(
                          'Welcome to\nNight Fall Restaurant',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Ktwod',
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // number of the table
                        ScaleOnPressButton(
                          controller: AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 500),
                            lowerBound: 0.0,
                            upperBound: 0.1,
                          )..addListener(() {
                              setState(() {});
                            }),
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<TablesBloc>()
                                  .add(TablesOnShowChangeTableDialogEvent(
                                    tableNumbers: tableNumbers,
                                  ));
                            },
                            child: TextView(
                              text: state.tableNumber,
                              textColor:
                                  Theme.of(context).colorScheme.onBackground,
                              textSize: 140.0,
                            ),
                          ),
                        ),
                        // TABLE NUMBER BUTTON with scale on press animation
                      ],
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ScaleOnPressButton(
                          controller: _animateController,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<TablesBloc>()
                                  .add(TablesOnNavigateToHomeScreenEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              minimumSize: const Size(180.0, 50.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Go to menu',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontFamily: 'Ktwod',
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                Icon(
                                  Icons.keyboard_double_arrow_right_rounded,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else if (state is TablesLoadingState) {
              return Center(
                  child: CupertinoActivityIndicator(
                color: Theme.of(context).colorScheme.primary,
                radius: 20.0,
              ));
            } else if (state is TablesErrorState) {
              return errorWidget(state.error, context);
            }
            return Container();
          },
          listener: (BuildContext context, TablesState state) {
            if (state is TablesNavigateToHomeScreenActionState) {
              HomeScreen.open(context);
            }
            if (state is TablesValidPasswordState) {
              showSnackBar(state.isValid, context);
            } else if (state is TablesInValidPasswordState) {
              showSnackBar(state.message, context);
            }
            if (state is TablesShowChangeTableDialogActionState) {
              showCupertinoDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) =>
                    _textFieldDialog(tableNumbers: state.tableNumbers),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _textFieldDialog({required List<int> tableNumbers}) =>
      CupertinoAlertDialog(
        title: TextView(
          text: 'Change the table number',
          textColor: Theme.of(context).colorScheme.onBackground,
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10.0),
            TextView(
              text: 'Table number: ${tableNumbers[_selectedNumber]}',
              textSize: 20.0,
              textColor: Theme.of(context).colorScheme.onBackground,
            ),
            const SizedBox(height: 16.0),

            /// textField
            _buildCupertinoTextField(hintText: 'Enter the password'),
          ],
        ),
        actions: [
          // for change table number with numberPicker
          CupertinoDialogAction(
            onPressed: () {
              _showPopUp(CupertinoPicker(
                magnification: 1.5,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: kItemExtent,
                scrollController: FixedExtentScrollController(
                  initialItem: _selectedNumber,
                ),
                onSelectedItemChanged: (selectedItem) {
                  context.read<TablesBloc>().add(TablesOnChangeTableNumberEvent(
                        tableNumbers: tableNumbers,
                        selectedItem: selectedItem,
                      ));
                },
                children: List<Widget>.generate(
                  tableNumbers.length,
                  (index) => Center(child: Text("${tableNumbers[index]}")),
                ),
              ));
            },
            child: TextView(
              text: 'CHANGE TABLE',
              textSize: 12.0,
              textColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          // it's done, we can click ok
          CupertinoDialogAction(
            onPressed: () {
              if (textEditingController.text.length < 8) {
                showSnackBar(passLengthText, context);
              } else {
                print(
                    '${tableNumbers[_selectedNumber]} and ${textEditingController.text}');
                context.read<TablesBloc>().add(TablesOnPasswordSubmitEvent(
                      tableNumber: "${tableNumbers[_selectedNumber]}",
                      password: textEditingController.text,
                    ));
                Navigator.of(context).pop();
                context.read<TablesBloc>().add(TablesOnGetPasswordsEvent());
              }
            },
            child: TextView(
              text: 'OK',
              textSize: 12.0,
              textColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      );

  Widget _buildCupertinoTextField({
    required String hintText,
  }) =>
      SizedBox(
        width: fillMaxWidth(context),
        height: 36.0,
        child: CupertinoTextField(
          obscureText: true,
          controller: textEditingController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          cursorColor: Theme.of(context).colorScheme.secondary,
          cursorOpacityAnimates: true,
          maxLength: 8,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            letterSpacing: 2.0,
            fontFamily: 'Ktwod',
            fontSize: 18.0,
          ),
        ),
      );

  void _showPopUp(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: Theme.of(context).colorScheme.background,
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
