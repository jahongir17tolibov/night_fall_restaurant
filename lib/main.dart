import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:night_fall_restaurant/core/theme/theme.dart';
import 'package:night_fall_restaurant/core/theme/theme_manager.dart';
import 'package:night_fall_restaurant/feature/splash/SplashScreen.dart';
import 'package:night_fall_restaurant/utils/custom_tab_bar_indicator.dart';
import 'firebase_options.dart';
import 'core/navigation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouterNavigation.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: const SplashScreen(),
    );
  }
}

ThemeManager _themeManager = ThemeManager();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController =
      ScrollController(keepScrollOffset: false);
  int _selectedTabIndex = 0;
  List<double> itemOffsets = [];

  final List<DemoTabItems> productsData = [
    DemoTabItems(category: 'Milliy Taomlar', items: [
      Items('milliy1', '565656'),
      Items('milliy2', '565656'),
      Items('milliy3', '565656'),
      Items('milliy4', '565656'),
      Items('milliy5', '565656'),
      Items('milliy6', '565656'),
      Items('milliy7', '565656'),
      Items('milliy8', '565656'),
      Items('milliy9', '565656'),
      Items('milliy9', '565656'),
    ]),
    DemoTabItems(category: 'Chet el taomlar', items: [
      Items('chet el', '21458'),
      Items('chet el1', '21458'),
      Items('chet el2', '21458'),
      Items('chet e3', '21458'),
      Items('chet e4', '21458'),
      Items('chet e4', '21458'),
      Items('chet e4', '21458'),
      Items('chet e4', '21458'),
    ]),
    DemoTabItems(category: 'Ichimliklar', items: [
      Items('ichimlik1', '20'),
      Items('ichimlik2', '20'),
      Items('ichimlik2', '20'),
      Items('ichimlik2', '20'),
    ]),
    DemoTabItems(category: 'Boshqa', items: [
      Items('boshqacha1', '222'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
      Items('boshqacha2', '2'),
    ]),
  ];

  void setupScrollController({required gridItemHeight}) {
    double offset = 0.0;
    productsData.forEach((category) {
      itemOffsets.add(offset); //birinchi categoriya itemlari 0.0 dan boshlanadi
      offset += (gridItemHeight * category.items.length) / 2;
      print('${category.items.length} and $offset');
    });

    print('$_selectedTabIndex and $gridItemHeight');

    _scrollController.addListener(() {
      double currentOffset = _scrollController.offset;
      int newTabIndex = 0;

      for (int i = 1; i < itemOffsets.length; i++) {
        if (currentOffset > itemOffsets[i]) {
          newTabIndex = i;
        }
      }

      //tanlangan tab indexini set qildim
      if (newTabIndex != _selectedTabIndex) {
        setState(() {
          _selectedTabIndex = newTabIndex;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(themeListeners);
    // setupScrollController(gridItemHeight: );
  }

  @override
  void dispose() {
    _themeManager.dispose();
    _scrollController.removeListener(themeListeners);
    super.dispose();
  }

  void themeListeners() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3.5;
    final double itemWidth = size.width / 2;

    // setupScrollController(gridItemHeight: itemHeight);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {
              bool themeModeValue = _themeManager.themeMode == ThemeMode.dark;
              _themeManager.toggleTheme(themeModeValue);
            },
            icon: Icon(
              Icons.light_mode_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 16.0)
        ],
        title: Text(
          'Night Fall Restaurant',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        bottom: TabBar(
          tabs: productsData
              .map((category) => Tab(text: category.category))
              .toList(),
          controller: TabController(
            animationDuration: const Duration(milliseconds: 400),
            length: productsData.length,
            vsync: this,
            initialIndex: _selectedTabIndex,
          ),
          physics: const ClampingScrollPhysics(),
          isScrollable: true,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          splashBorderRadius: const BorderRadius.all(Radius.circular(120.0)),
          indicator: CustomTabIndicator(Theme.of(context).colorScheme.primary),
          indicatorPadding: const EdgeInsets.all(4.0),
          indicatorSize: TabBarIndicatorSize.tab,
          automaticIndicatorColorAdjustment: true,
          dividerColor: Colors.transparent,
          onTap: (categoryIndex) {
            setState(() {
              _selectedTabIndex = categoryIndex;
              _scrollToCategory(categoryIndex);
            });
          },
        ),
      ),
      body: Center(
          child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10.0),
        controller: _scrollController,
        itemCount: productsData.expand((category) => category.items).length,
        itemBuilder: (context, index) {
          final item = productsData
              .expand((category) => category.items)
              .elementAt(index);

          final itemSize = gridItemView(
            name: item.name,
            price: item.price,
            context: context,
          );
          // return Container()
          return itemSize;
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.shopping_cart_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () async {
          // await addMenuToFireStore();
        },
      ),
    );
  }

  void _scrollToCategory(int categoryIndex) {
    double itemOffset = itemOffsets[categoryIndex];
    print('${itemOffsets[categoryIndex]} + $categoryIndex');
    _scrollController.animateTo(
      itemOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  static Text gridItemText(String text, BuildContext context) => Text(text,
      style: TextStyle(
          fontSize: 14.0,
          color: Theme.of(context).colorScheme.onTertiaryContainer),
      overflow: TextOverflow.ellipsis,
      maxLines: 1);

  static Widget gridItemView({
    required String name,
    required String price,
    required BuildContext context,
  }) {
    return Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(height: 6.0),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  gridItemText(name, context),
                  const SizedBox(height: 4),
                  gridItemText(price, context),
                ],
              ))
            ],
          ),
        ));
  }
}

class DemoTabItems {
  final String category;
  final List<Items> items;

  DemoTabItems({required this.items, required this.category});
}

class Items {
  final String name;
  final String price;

  Items(this.name, this.price);
}
