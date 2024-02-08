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
*
*
*
* INPUT DECORATION #############################################################
*
          decoration: InputDecoration(
            errorText: (state is TablesPasswordInputErrorState)
                ? state.passwordError
                : null,
            floatingLabelStyle: TextStyle(
              color: textFieldFocusNode.hasFocus
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.outline,
            ),
            labelText: hintText,
            hintMaxLines: 1,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.errorContainer,
                  width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 2.0),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            errorStyle: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 18.0),
            labelStyle: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.outline,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: Icon(
                _isObscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: textFieldFocusNode.hasFocus
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
*
*
*
  final List<String> categories = [
    'Milliy taomlar',
    'Turk taomlari',
    'Salatlar',
    'Nonlar',
    'Ichimliklar',
  ];
*
*
* // home
* Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TabBar(
                    tabs: categoriesList,
                    labelStyle: const TextStyle(fontFamily: 'Ktwod'),
                    controller: _tabController,
                    physics: const ClampingScrollPhysics(),
                    isScrollable: true,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    splashBorderRadius:
                        const BorderRadius.all(Radius.circular(120.0)),
                    indicator: CustomTabIndicator(
                      Theme.of(context).colorScheme.primary,
                    ),
                    indicatorPadding: const EdgeInsets.all(4.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    automaticIndicatorColorAdjustment: true,
                    dividerColor: Colors.transparent,
                    onTap: (categoryIndex) {},
                  ),
                  Expanded(
                      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          orientation == Orientation.portrait ? 2 : 4,
                      childAspectRatio: (itemWidth / itemHeight),
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: Platform.isIOS
                        ? const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast)
                        : const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast),
                    padding: const EdgeInsets.all(10.0),
                    controller: _scrollController,
                    itemCount: state.response.length,
                    itemBuilder: (context, itemIndex) {
                      if (_buttonStates.length <= itemIndex) {
                        _buttonStates.add(false);
                      }
                      // indexing sorted data
                      final item = state.response[itemIndex];
                      final gridItem = _gridItemView(
                        productId: item.id!,
                        name: item.name,
                        price: item.price,
                        image: item.image,
                        weight: item.weight,
                        orientation: orientation,
                        itemIndex: itemIndex,
                      );
                      return gridItem;
                    },
                  )),
                ],
              );
*
*
* */
