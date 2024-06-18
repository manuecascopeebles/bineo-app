import 'dart:async';
import 'dart:math';

import 'package:bineo/common/app_strings.dart';
import 'package:bineo/common/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLoader {
  AppLoader._();

  static BuildContext? _loaderContext;

  static void show(
    BuildContext context, {
    required Duration loadingTime,
    required List<String> loadingTasks,
  }) {
    _loaderContext = context;

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => _AppLoader(
        loadingTime: loadingTime,
        loadingTasks: loadingTasks,
      ),
    );
  }

  static void hide() {
    if (_loaderContext != null) {
      Navigator.of(_loaderContext!).pop();
    }
    _loaderContext = null;
  }

  static bool canHide() {
    if (_loaderContext != null) {
      return Navigator.of(_loaderContext!).canPop();
    }
    return false;
  }
}

class _AppLoader extends StatefulWidget {
  const _AppLoader({
    required this.loadingTime,
    required this.loadingTasks,
  });

  final Duration loadingTime;
  final List<String> loadingTasks;

  @override
  State<_AppLoader> createState() => __AppLoaderState();
}

class __AppLoaderState extends State<_AppLoader> with TickerProviderStateMixin {
  late String loadingTask;
  late String informativeMessage;
  List<String> shownInformativeMessages = [];

  Timer? loadingTaskTimer;
  Timer? informativeMessagesTimer;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    loadingTask =
        widget.loadingTasks.isNotEmpty ? widget.loadingTasks.first : '';
    if (widget.loadingTasks.length > 1) {
      getLoadingTask();
    }

    getRandomInformativeMessage();

    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    loadingTaskTimer?.cancel();
    animationController.dispose();
    informativeMessagesTimer?.cancel();

    super.dispose();
  }

  void getLoadingTask() {
    int taskDuration =
        widget.loadingTime.inMilliseconds ~/ widget.loadingTasks.length;
    Duration timerDuration = Duration(milliseconds: taskDuration);

    loadingTaskTimer = Timer(timerDuration, () {
      int index = widget.loadingTasks.indexOf(loadingTask);

      if ((widget.loadingTasks.length - 1) > index) {
        setState(() {
          loadingTask = widget.loadingTasks[index + 1];
        });
        getLoadingTask();
      }
    });
  }

  void getRandomInformativeMessage() {
    Random random = Random();
    List<String> allMessages = AppStrings.loaderInformativeMessages;

    if (shownInformativeMessages.isEmpty) {
      String message = allMessages[random.nextInt(allMessages.length)];

      setState(() {
        informativeMessage = message;
        shownInformativeMessages = [message];
      });
    } else if (shownInformativeMessages.length == allMessages.length) {
      List<String> messagesToUse = [...allMessages];
      messagesToUse.remove(informativeMessage);

      String message = messagesToUse[random.nextInt(messagesToUse.length)];

      setState(() {
        informativeMessage = message;
        shownInformativeMessages = [message];
      });
    } else {
      List<String> messagesToUse = [...allMessages];
      messagesToUse.removeWhere((message) {
        return shownInformativeMessages.contains(message);
      });

      String message = messagesToUse[random.nextInt(messagesToUse.length)];

      setState(() {
        informativeMessage = message;
        shownInformativeMessages = [...shownInformativeMessages, message];
      });
    }

    informativeMessagesTimer = Timer(Duration(seconds: 7), () {
      getRandomInformativeMessage();
    });
  }

  Widget renderLoader() {
    return Lottie.asset(
      'assets/animations/bineo-loader-animation.json',
      repeat: true,
      controller: animationController,
      onLoaded: (_) {
        animationController.duration = widget.loadingTime;
        animationController.repeat();
      },
    );
  }

  Widget renderLoadingTask() {
    return Text(
      loadingTask,
      textAlign: TextAlign.center,
      style: AppStyles.body1TextStyle,
    );
  }

  Widget renderEstimatedLoadingTime() {
    if (widget.loadingTime < Duration(seconds: 15)) {
      return Container();
    }

    return Text(
      AppStrings.estimatedLoadingTime(widget.loadingTime),
      textAlign: TextAlign.center,
      style: AppStyles.subtitleTextStyle,
    );
  }

  Widget renderInformativeMessage() {
    return Text(
      informativeMessage,
      textAlign: TextAlign.center,
      style: AppStyles.subtitleTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppStyles.surfaceColor,
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: renderLoader(),
              ),
              IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    renderLoadingTask(),
                    Container(
                      height: 20,
                      margin: const EdgeInsets.only(
                        top: 7,
                        bottom: 30,
                      ),
                      child: renderEstimatedLoadingTime(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 65,
                child: renderInformativeMessage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
