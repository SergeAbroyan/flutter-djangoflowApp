import 'dart:developer';
import 'dart:math' as math;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speakly/models/registration_models/practice_time_model.dart';
import 'package:speakly/models/user_model.dart';
import 'package:speakly/widget/shared/custom_dialog.dart';

class LocalNotificationService {
  final AwesomeNotifications flutterLocalNotificationsPlugin =
      AwesomeNotifications();

  Future<void> init() async {
    await flutterLocalNotificationsPlugin
        .initialize('resource://drawable/ic_launcher', [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Notifications scheduled daily',
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
      ),
    ]);
    flutterLocalNotificationsPlugin.setListeners(
        onActionReceivedMethod: _onActionReceivedMethod);
  }

  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  Future<void> disposeNotification() async {
    await flutterLocalNotificationsPlugin.dispose();
  }

  Future<void> scheduleNotification(
      {required String title,
      required String subtitle,
      required int id,
      required DateTime time}) async {
    await flutterLocalNotificationsPlugin.createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'scheduled_channel',
          title: title,
          body: subtitle,
        ),
        schedule: NotificationCalendar.fromDate(date: time));
  }

  Future<void> delayNotification(
      {required String title,
      required String subtitle,
      required int id,
      required PracticeTimeModel time}) async {
    await flutterLocalNotificationsPlugin.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: subtitle,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minutes,
        repeats: true,
      ),
    );
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    log('cancel All Notification');
  }

  Future<void> cancelNotification({required int id}) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> whenOpenAppDefault(UserModel userModel) async {
    final status = await Permission.notification.status;
    final permissionsGranted = status == PermissionStatus.granted;
    if (!permissionsGranted) {
      return;
    }
    await cancelAllNotification();
    await _showReasonNotification(userModel);
    _showTopicNotification(userModel),
    _showGenericNotification(userModel)
  }

  Future<void> _showGenericNotification(UserModel userModel) async {
    await delayNotification(
        id: 1,
        title: 'Time For English Practice',
        subtitle: 'You can do this, just practice for a few minutes.',
        time: PracticeTimeModel(
            hour: (userModel.practiceTime?.hour ?? 16) + 2,
            minutes: userModel.practiceTime?.minutes ?? 0));
  }

  Future<void> _showReasonNotification(UserModel userModel) async {
    final reasonsModel = userModel.reasonsModel;
    var randomReason = reasonsModel?[0];
    if (reasonsModel != null) {
      randomReason = reasonsModel.length > 1
          ? reasonsModel[math.Random().nextInt(reasonsModel.length - 1)]
          : reasonsModel[0];
    }
    await delayNotification(
        id: 0,
        title: 'Time For English Practice',
        subtitle: randomReason?.description ?? '',
        time: userModel.practiceTime ??
            PracticeTimeModel(
                hour: TimeOfDay.now().hour, minutes: TimeOfDay.now().minute));
  }

  Future<void> _showTopicNotification(UserModel userModel) async {
    final userTime = userModel.practiceTime;
    final now = DateTime.now();
    if (userTime != null) {
      for (var i = 0; i < 7; i++) {
        final topicModel = userModel.reasonsModel;
        var randomTopic = topicModel?[0];
        if (topicModel != null) {
          randomTopic = topicModel.length > 1
              ? topicModel[math.Random().nextInt(topicModel.length - 1)]
              : topicModel[0];
        }
        await scheduleNotification(
            id: i + 2,
            title: 'English Practice Time',
            subtitle: randomTopic?.description ?? '',
            time: DateTime(now.year, now.month, now.day, userTime.hour,
                    userTime.minutes)
                .add(Duration(days: i, minutes: 30)));
      }
      await _checkDateTimeNotification(userModel);
    }
  }

  Future<void> _checkDateTimeNotification(UserModel userModel) async {
    final userTime = userModel.practiceTime;
    if (userTime != null) {
      if (userTime.hour > DateTime.now().hour) {
        if (userTime.minutes > DateTime.now().minute + 40) {
          await cancelNotification(id: 2);
        }
      }
    }
  }

  Future<bool> checkPermissionsGranted(BuildContext context) async {
    var status = await Permission.notification.status;

    if (status == PermissionStatus.denied) {
      status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      status = await _requestUserPermissions(context);
      return status == PermissionStatus.granted;
    }

    return status == PermissionStatus.granted;
  }

  Future<PermissionStatus> _requestUserPermissions(
    BuildContext context,
  ) async {
    await showDialog(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: false,
        builder: (context) {
          return customDialog(
              context: context,
              yesText: 'Settings',
              noText: 'Deny',
              title: 'We need your permission to send you notifications!',
              tapNo: () {
                Navigator.pop(context);
              },
              tapYes: () async {
                await flutterLocalNotificationsPlugin
                    .requestPermissionToSendNotifications();
                Navigator.pop(context);
              });
        });

    return await Permission.notification.status;
  }
}
