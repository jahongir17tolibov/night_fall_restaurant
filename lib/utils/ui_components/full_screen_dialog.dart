import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeTablePasswordDialog extends StatelessWidget {
  const ChangeTablePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 32.0,
          ),
          tooltip: 'Chat with admin',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.mark_unread_chat_alt_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 32.0,
            ),
            tooltip: 'Chat with admin',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Dialog.fullscreen(
        insetAnimationDuration: const Duration(milliseconds: 1000),
        backgroundColor: Theme.of(context).colorScheme.surface,
        insetAnimationCurve: Curves.fastEaseInToSlowEaseOut,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            ],
          ),
        ),
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

void _showFullScreenDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog.fullscreen(
      insetAnimationDuration: const Duration(milliseconds: 1000),
      backgroundColor: Theme.of(context).colorScheme.surface,
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
