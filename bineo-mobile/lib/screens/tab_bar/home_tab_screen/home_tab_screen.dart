import 'package:bineo/blocs/home_bloc/home_bloc.dart';
import 'package:bineo/blocs/home_bloc/home_event.dart';
import 'package:bineo/blocs/home_bloc/home_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/widgets/home_tab_screen/account_details_button.dart';
import 'package:bineo/widgets/home_tab_screen/account_pockets_card.dart';
import 'package:bineo/widgets/home_tab_screen/home_tab_top_bar.dart';
import 'package:bineo/widgets/svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({
    super.key,
    required this.globalNavigator,
  });

  /// Use this to navigate on top of the bottom bar. Use it instead of Navigator.of(context)
  final NavigatorState globalNavigator;

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  bool hideAccountNumber = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(InitializeHomeBlocEvent());
  }

  void onTapProfileIcon() {
    // TODO implement
  }

  void onToggleHideAccountNumber() {
    setState(() {
      hideAccountNumber = !hideAccountNumber;
    });
  }

  void onTapNotificationsIcon() {
    // TODO implement
  }

  void onTapBineoIcon() {
    // TODO implement
  }

  void onTapAccountDetails() {
    // TODO implement
  }

  void onTapPocketsCard() {
    // TODO implement
  }

  Widget renderBackground({
    required Widget child,
  }) {
    return Stack(
      children: [
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SVGs.getSVG(
                  svg: SVGs.homeBackground,
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget renderTitle(HomeState state) {
    return Text(
      AppStrings.helloUser(state.user.username),
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderAccountType(HomeState state) {
    return Text(
      state.accountType,
      style: AppStyles.overline1HighEmphasisTextStyle,
    );
  }

  Widget renderInformationCard() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return renderBackground(
      child: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20,
                    bottom: 15,
                  ),
                  child: HomeTabTopBar(
                    username: state.user.username,
                    hasNotifications: state.hasNotifications,
                    hideAccountNumber: hideAccountNumber,
                    onTapBineoIcon: onTapBineoIcon,
                    onTapProfileIcon: onTapProfileIcon,
                    onTapNotificationsIcon: onTapNotificationsIcon,
                    onToggleHideAccountNumber: onToggleHideAccountNumber,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: renderTitle(state),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 12,
                    right: 15,
                    left: 15,
                    bottom: 27,
                  ),
                  child: AccountDetailsButton(
                    isLoading: state.isRefreshingBalance,
                    accountBalance: state.balance,
                    accountNumber: state.accountNumber,
                    hideAccountNumber: hideAccountNumber,
                    onTapAccountDetails: onTapAccountDetails,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 7,
                    right: 20,
                    left: 20,
                  ),
                  child: renderAccountType(state),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AccountPocketsCard(
                    hasPockets: state.hasPockets,
                    onTapPocketsCard: onTapPocketsCard,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
