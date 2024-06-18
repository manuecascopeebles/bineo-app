import 'package:bineo/models/user.dart';

class HomeState {
  late User user;
  String accountType = '';
  String accountNumber = '';
  double balance;
  bool isRefreshingBalance = false;
  bool hasErrorGettingBalance = false;
  bool hasPockets = false;
  bool hasNotifications = false;

  // TODO remove test values

  HomeState({
    required this.user,
    this.accountType = 'Ahorro',
    this.accountNumber = '12345678',
    this.balance = 0.0,
    this.isRefreshingBalance = false,
    this.hasErrorGettingBalance = false,
    this.hasPockets = false,
    this.hasNotifications = true,
  });

  HomeState copyWith({
    User? user,
    String? accountType,
    String? accountNumber,
    double? balance,
    bool? isRefreshingBalance,
    bool? hasErrorGettingBalance,
    bool? hasPockets,
    bool? hasNotifications,
  }) {
    return HomeState(
      user: user ?? this.user,
      accountType: accountType ?? this.accountType,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      isRefreshingBalance: isRefreshingBalance ?? this.isRefreshingBalance,
      hasErrorGettingBalance:
          hasErrorGettingBalance ?? this.hasErrorGettingBalance,
      hasPockets: hasPockets ?? this.hasPockets,
      hasNotifications: hasNotifications ?? this.hasNotifications,
    );
  }
}
