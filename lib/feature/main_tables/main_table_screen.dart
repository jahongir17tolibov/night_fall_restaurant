import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/utils/scale_on_press_button.dart';

class MainTableScreen extends StatefulWidget {
  const MainTableScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainTableScreenState();
}

class _MainTableScreenState extends State<MainTableScreen>
    with TickerProviderStateMixin {
  int _selectedNumber = 0;
  late AnimationController _animateController;

  static const double kItemExtent = 32;
  final List<String> tableNumbers = ['1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  void initState() {
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.change_circle_outlined,
        //     color: Theme.of(context).colorScheme.onSurface,
        //     size: 36.0,
        //   ),
        // ),
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
      body: Column(
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
                      color: Theme.of(context).colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),
                // number of the table
                scaleOnPress(
                  child: Text(
                    tableNumbers[_selectedNumber],
                    style: TextStyle(
                      fontSize: 140.0,
                      fontFamily: 'Ktwod',
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  controller: _animateController,
                )
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: scaleOnPress(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
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
                          color: Theme.of(context).colorScheme.background,
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
          )
        ],
      ),
    );
  }

  void _showTablePassword(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        insetAnimationCurve: Curves.easeIn,
        title: Text(
          'Change the table number',
          style: TextStyle(
            fontFamily: 'Ktwod',
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        content: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'My Dialog ${tableNumbers[_selectedNumber]}',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Ktwod',
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        )),
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
                    tableNumbers.length,
                    (index) => Center(child: Text(tableNumbers[index])),
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
          ),
          // it's done, we can click ok
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
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
      ),
    );
  }

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
