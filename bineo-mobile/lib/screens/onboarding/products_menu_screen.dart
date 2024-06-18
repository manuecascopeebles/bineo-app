import 'package:bineo/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:bineo/blocs/onboarding_bloc/onboarding_state.dart';
import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:bineo/screens/onboarding/accounts_menu_screen.dart';
import 'package:bineo/widgets/app_scaffold.dart';
import 'package:bineo/widgets/images.dart';
import 'package:bineo/widgets/onboarding/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsMenuScreen extends StatefulWidget {
  const ProductsMenuScreen({super.key});

  @override
  State<ProductsMenuScreen> createState() => _ProductsMenuScreenState();
}

class _ProductsMenuScreenState extends State<ProductsMenuScreen> {
  @override
  void initState() {
    BlocProvider.of<OnboardingBloc>(context).add(
      const RequestNotificationsPermissionEvent(),
    );

    super.initState();
  }

  void chooseBineoAccount() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AccountsMenuScreen(),
      ),
    );
  }

  void chooseBineoLoan() {
    // TODO implement
  }

  void chooseBineoCreditCard() {
    // TODO implement
  }

  Widget renderTitle(OnboardingState state) {
    return Text(
      AppStrings.nowChooseWhatYouWant(state.username),
      style: AppStyles.heading2TextStyle,
    );
  }

  Widget renderProductCards() {
    return Column(
      children: [
        ProductCard(
          title: AppStrings.bineoAccount,
          description: AppStrings.bineoAccountDescription,
          imagePath: Images.bineoAccount,
          onTap: chooseBineoAccount,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ProductCard(
            title: AppStrings.bineoLoan,
            description: AppStrings.bineoLoanDescription,
            imagePath: Images.bineoLoan,
            onTap: chooseBineoLoan,
          ),
        ),
        ProductCard(
          title: AppStrings.bineoCreditCard,
          description: AppStrings.bineoCreditCardDescription,
          imagePath: Images.bineoCreditCard,
          onTap: chooseBineoCreditCard,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideBackButton: true,
      body: Column(
        children: [
          BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: renderTitle(state),
              );
            },
          ),
          renderProductCards(),
        ],
      ),
    );
  }
}
