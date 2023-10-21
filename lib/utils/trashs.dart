/*
*
* Text(
            String.fromCharCode(Icons.keyboard_double_arrow_up_sharp.codePoint),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 70.0,
              fontWeight: FontWeight.w100,
              fontFamily: Icons.keyboard_double_arrow_up_sharp.fontFamily,
            ),
          )
*
*
* NUMBER PICKER   ##############################################################
* _showPopUp(
                      context,
                      CupertinoPicker(
                        itemExtent: kItemExtent,
                        magnification: 1.5,
                        squeeze: 1.2,
                        useMagnifier: true,
                        scrollController: FixedExtentScrollController(
                            initialItem: _selectedNumber),
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
*
*
*
 transitionDuration: const Duration(milliseconds: 250),
 transitionBuilder: (context, animation, secondaryAnimation, child) =>
     FadeTransition(
   opacity: animation,
   child: ScaleTransition(
     scale: animation,
     child: child,
   ),
 ),
*
*
* scale on press v2.0
* GestureDetector(
                  onTap: () {
                    _animateController.forward();
                    Future.delayed(const Duration(milliseconds: 200), () {
                      _animateController.reverse();
                    });
                    _showTablePassword(context);
                  },
                  child: Transform.scale(
                    scale: _scale,
                    child: Text(
                      tableNumbers[_selectedNumber],
                      style: TextStyle(
                        fontSize: 140.0,
                        fontFamily: 'Ktwod',
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
*
* */
