import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:night_fall_restaurant/feature/main_tables/bloc/tables_bloc.dart';
import 'package:night_fall_restaurant/utils/helpers.dart';
import 'package:night_fall_restaurant/utils/ui_components/cupertino_error_dialog.dart';
import 'package:night_fall_restaurant/utils/ui_components/cupertino_loading_dialog.dart';
import 'package:night_fall_restaurant/utils/ui_components/scale_on_press_button.dart';

import '../../utils/ui_components/show_snack_bar.dart';

class MainTableScreen extends StatefulWidget {
  const MainTableScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainTableScreenState();
}

class _MainTableScreenState extends State<MainTableScreen>
    with TickerProviderStateMixin {
  late AnimationController _animateController;
  int _selectedNumber = 0;
  FocusNode textFieldFocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  static const double kItemExtent = 32;
  final List<String> _tableNumbers = [];

  @override
  void initState() {
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
    context.read<TablesBloc>().add(TablesOnGetPasswordsEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _animateController.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.light_mode_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 32.0,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: BlocConsumer<TablesBloc, TablesState>(
        builder: (blocContext, state) {
          if (state is TablesSuccessState) {
            _tableNumbers.clear();
            for (var element in state.tablePasswords) {
              _tableNumbers.add(element.tableNumber.toString());
            }
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
                      scaleOnPress(
                        child: Text(
                          state.tableNumber,
                          style: TextStyle(
                            fontSize: 140.0,
                            fontFamily: 'Ktwod',
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        controller: _animateController,
                        onPressed: () {
                          _showChangeTableDialog(state, context);
                        },
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
                      child: scaleOnPress(
                        child: ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
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
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontFamily: 'Ktwod',
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              Icon(
                                Icons.keyboard_double_arrow_right_rounded,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ],
                          ),
                        ),
                        controller: AnimationController(
                          duration: const Duration(milliseconds: 500),
                          vsync: this,
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
            return Center(
              child: Text(
                state.error,
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'Ktwod',
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }
          return Container();
        },
        listener: (BuildContext context, TablesState state) {
          if (state is TablesValidPasswordState) {
            showSnackBar(state.isValid, context);
          } else if (state is TablesInValidPasswordState) {
            showSnackBar(state.message, context);
          }
        },
      ),
    );
  }

  void _showChangeTableDialog(TablesState state, BuildContext widgetContext) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            //   Builder(
            // builder: (_) {
            //   return
            _successDialog(state, widgetContext)
        // },
        // ),
        );
  }

  Widget _successDialog(TablesState state, BuildContext widgetContext) =>
      CupertinoAlertDialog(
        title: Text(
          'Change the table number',
          style: TextStyle(
            fontFamily: 'Ktwod',
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Text(
              'Table number: ${_tableNumbers[_selectedNumber]}',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Ktwod',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildCupertinoTextField(
              hintText: 'Enter the password',
              context: context,
              controller: context.watch<TablesBloc>().controller,
            ),
          ],
        ),
        actions: [
          // for change table number with numberPicker
          CupertinoDialogAction(
            onPressed: () {
              _showPopUp(
                context,
                CupertinoPicker(
                  itemExtent: kItemExtent,
                  magnification: 1.5,
                  squeeze: 1.2,
                  useMagnifier: true,
                  scrollController:
                      FixedExtentScrollController(initialItem: _selectedNumber),
                  onSelectedItemChanged: (selectedItem) {
                    setState(() {
                      _selectedNumber = selectedItem;
                    });
                  },
                  children: List<Widget>.generate(
                    _tableNumbers.length,
                    (index) => Center(child: Text(_tableNumbers[index])),
                  ),
                ),
              );
            },
            child: Text(
              'CHANGE TABLE',
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Ktwod',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ), // it's done, we can click ok
          CupertinoDialogAction(
            onPressed: () {
              final textFromController = context.watch<TablesBloc>().controller;
              context
                  .read<TablesBloc>()
                  .add(TablesOnChangeTextFieldEvent(context));
              context.read<TablesBloc>().add(TablesOnPasswordSubmitEvent(
                    tableNumber: _tableNumbers[_selectedNumber],
                    password: textFromController.text,
                  ));
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Ktwod',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      );

  Widget _buildCupertinoTextField({
    required String hintText,
    required BuildContext context,
    required TextEditingController controller,
    // required TablesState state,
  }) =>
      SizedBox(
        width: fillMaxWidth(context),
        height: 36.0,
        child: CupertinoTextField(
          obscureText: true,
          controller: controller,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          cursorColor: Theme.of(context).colorScheme.secondary,
          cursorOpacityAnimates: true,
          maxLength: 12,
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

  void _showPopUp(BuildContext context, Widget child) {
    showCupertinoModalPopup(
      barrierDismissible: true,
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
