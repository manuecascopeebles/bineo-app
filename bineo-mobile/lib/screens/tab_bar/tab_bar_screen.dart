import 'dart:async';

import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/tab_bar/cards_tab_screen/cards_tab_screen.dart';
import 'package:bineo/screens/tab_bar/home_tab_screen/home_tab_screen.dart';
import 'package:bineo/screens/tab_bar/personal_tab_screen/personal_tab_screen.dart';
import 'package:bineo/screens/tab_bar/transfers_tab_screen/transfers_tab_screen.dart';
import 'package:bineo/widgets/app_dialog/app_dialog.dart';
import 'package:bineo/widgets/app_dialog/custom_app_dialog.dart';
import 'package:bineo/widgets/images.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({
    super.key,
    this.showGrowAccountDialog = false,
  });

  final bool showGrowAccountDialog;

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int currentIndex = 0;
  bool tappedBarButton = false;
  PageController pageController = PageController();

  late final List<Widget> tabs;
  late final List<GlobalKey<NavigatorState>> navigatorKeys;

  late StreamController<int> pageStream;
  StreamSubscription? pageSubscription;

  @override
  void initState() {
    super.initState();

    initializeTabs();

    pageStream = StreamController<int>();
    pageSubscription = pageStream.stream.listen((index) {
      goToPage(index);
    });

    if (widget.showGrowAccountDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showGrowAccountDialog();
      });
    }
  }

  @override
  void dispose() {
    pageSubscription?.cancel();
    super.dispose();
  }

  void showGrowAccountDialog() {
    AppDialog.showCustomMessage(
      context,
      icon: SizedBox(
        height: 120,
        width: 120,
        child: Images.getImage(
          image: Images.bineoAccount,
        ),
      ),
      title: AppStrings.growYourAccount,
      messageWidget: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.growAccountSpan1,
              style: AppStyles.body1TextStyle,
            ),
            TextSpan(
              text: ' ${AppStrings.bineoAccount} ',
              style: AppStyles.heading5TextStyle,
            ),
            TextSpan(
              text: '${AppStrings.total} ',
              style: AppStyles.heading5PrimaryTextStyle,
            ),
            TextSpan(
              text: AppStrings.growAccountSpan2,
              style: AppStyles.body1TextStyle,
            ),
          ],
        ),
      ),
      showDefaultCloseAction: true,
      defaultCloseActionTitle: AppStrings.later,
      buttons: [
        CustomAppDialogAction(
          title: AppStrings.growNow,
          onTap: onUpgradeToTotalAccount,
        ),
      ],
    );
  }

  void onUpgradeToTotalAccount() {
    // TODO implement

    Navigator.of(context).pop();
  }

  void initializeTabs() {
    List<Widget> tabsList = [];
    List<GlobalKey<NavigatorState>> keysList = [];

    final List<Widget> screens = [
      HomeTabScreen(globalNavigator: Navigator.of(context)),
      TransfersTabScreen(globalNavigator: Navigator.of(context)),
      CardsTabScreen(globalNavigator: Navigator.of(context)),
      PersonalTabScreen(globalNavigator: Navigator.of(context)),
    ];

    for (Widget screen in screens) {
      GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
      keysList.add(key);

      tabsList.add(
        Navigator(
          key: key,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => screen,
            );
          },
        ),
      );
    }

    setState(() {
      tabs = tabsList;
      navigatorKeys = keysList;
    });
  }

  void goToPage(int index) {
    if (currentIndex == index) {
      NavigatorState? navigator = navigatorKeys[index].currentState;

      if (navigator != null && navigator.canPop()) navigator.pop();
    } else {
      setState(() {
        currentIndex = index;
        pageController.jumpToPage(index);
      });
    }
  }

  String getTabLabel(int index) {
    switch (index) {
      case 0:
        return AppStrings.startTab;
      case 1:
        return AppStrings.moveMoney;
      case 2:
        return AppStrings.cards;
      case 3:
      default:
        return AppStrings.forYou;
    }
  }

  Widget getTabIcon(int index) {
    Color color = currentIndex == index
        ? AppStyles.textHighEmphasisColor
        : AppStyles.unselectedTabItemColor;

    switch (index) {
      case 0:
        return SVGs.getSVG(svg: SVGs.homeTab, color: color);
      case 1:
        return SVGs.getSVG(svg: SVGs.transfersTab, color: color);
      case 2:
        return SVGs.getSVG(svg: SVGs.cardsTab, color: color);
      case 3:
      default:
        return SVGs.getSVG(svg: SVGs.personalTab, color: color);
    }
  }

  BottomNavigationBarItem renderTab(int index) {
    return BottomNavigationBarItem(
      label: getTabLabel(index),
      backgroundColor: Colors.transparent,
      icon: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          height: 32,
          child: getTabIcon(index),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> getTabs() {
    return [
      renderTab(0),
      renderTab(1),
      renderTab(2),
      renderTab(3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: currentIndex != 0,
        child: PageView(
          children: tabs,
          controller: pageController,
          onPageChanged: (index) {
            if (!tappedBarButton) {
              pageStream.add(index);
            }
            setState(() => tappedBarButton = false);
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: AppStyles.blackColorGradient,
        ),
        padding: EdgeInsets.only(bottom: 5),
        child: Theme(
          data: ThemeData(
            splashFactory: NoSplash.splashFactory,
            splashColor: AppStyles.transparentColor,
            highlightColor: AppStyles.transparentColor,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            showUnselectedLabels: true,
            selectedItemColor: AppStyles.textHighEmphasisColor,
            unselectedItemColor: AppStyles.unselectedTabItemColor,
            selectedLabelStyle: AppStyles.selectedTabLabelTextStyle,
            unselectedLabelStyle: AppStyles.unselectedTabLabelTextStyle,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppStyles.transparentColor,
            items: getTabs(),
            onTap: (index) {
              setState(() => tappedBarButton = true);
              pageStream.add(index);
            },
          ),
        ),
      ),
    );
  }
}
