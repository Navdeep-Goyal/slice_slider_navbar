import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 130,
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late PageController _pageController;
  late ValueNotifier<double> pageNotifier;
  @override
  void initState() {
    _scrollController = ScrollController();
    pageNotifier = ValueNotifier<double>(0.00);
    _pageController = PageController(viewportFraction: 0.25)
      ..addListener(() {
        pageNotifier.value = _pageController.page ?? 0.0;
      });

    super.initState();
  }

  List<IconData> iconDataList = [
    Icons.home,
    Icons.electric_bike,
    Icons.payment,
    Icons.lock_clock,
    Icons.list
  ];

  List<String> iconLabels = ["Home", "Cycles", "Payments", "Premium", "Saved"];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: (value) {
        HapticFeedback.mediumImpact();
      },
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // _pageController.jumpToPage(index);
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 700),
                curve: Curves.ease);
          },
          child: ValueListenableBuilder<double>(
              valueListenable: pageNotifier,
              builder: (context, val, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: (index - val).abs() <= 1
                          ? 1.35 - (index - val).abs() * 0.35
                          : 1,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: (index - val).abs() <= 0.3
                                ? Colors.white
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            boxShadow: [
                              if ((index - val).abs() <= 0.3)
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4 - 4 * (index - val).abs(),
                                  spreadRadius: 2 - 2 * (index - val).abs(),
                                )
                            ]),
                        child: Icon(
                          iconDataList[index],
                          color: (index - val).abs() < 0.3
                              ? Colors.grey.shade800
                              : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Opacity(
                        opacity: (index - val).abs() <= 0.5
                            ? 1 - (index - val).abs()
                            : 0,
                        child: Text(
                          iconLabels[index],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                );
              }),
        );
      },
      itemCount: 5,
      controller: _pageController,
    );
  }
}
