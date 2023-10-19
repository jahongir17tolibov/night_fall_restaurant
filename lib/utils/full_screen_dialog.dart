import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void _displayFullScreenDialog(BuildContext context) {
  showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog.fullscreen(
      insetAnimationDuration: const Duration(milliseconds: 300),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      insetAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Hai This Is Full Screen Dialog',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 20.0),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "DISMISS",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                // _showPopUp(
                //   context,
                //   CupertinoPicker(
                //     itemExtent: kItemExtent,
                //     magnification: 1.5,
                //     squeeze: 1.2,
                //     useMagnifier: true,
                //     scrollController: FixedExtentScrollController(
                //         initialItem: _selectedNumber),
                //     onSelectedItemChanged: (selectedItem) {
                //       setState(() {
                //         _selectedNumber = selectedItem;
                //       });
                //     },
                //     children: List<Widget>.generate(
                //       tableNumbers.length,
                //           (index) => Center(child: Text(tableNumbers[index])),
                //     ),
                //   ),
                // );
              },
              child: Text(
                "show Pop Up",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}