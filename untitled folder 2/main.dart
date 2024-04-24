import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/models/purchases_configuration.dart'
    as purchases_config;
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:singular_flutter_sdk/singular.dart';
import 'package:singular_flutter_sdk/singular_config.dart';
import 'package:speakly/middleware/constants/app_firebase_options.dart';
import 'package:speakly/middleware/constants/flavor_const.dart';
import 'package:speakly/middleware/constants/revenue_cat_const.dart';
import 'package:speakly/middleware/constants/revenue_cat_const_dev.dart';
import 'package:speakly/repositories/implement_repositories/amplitude_repository.dart';
import 'package:speakly/repositories/implement_repositories/app_metrica_repository.dart';
import 'package:speakly/repositories/implement_repositories/notification_sevices.dart';
import 'package:speakly/repositories/implement_repositories/shared_preferences_repository.dart';
import 'package:upgrader/upgrader.dart';

import 'app.dart';
import 'interceptors/interceptor_initialize.dart';
import 'repositories/implement_repositories/firebase_analytics_service_repository.dart';

Future<void> run({bool isUxCam = false}) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final singularConfig = SingularConfig(
          'YourConfigname', 'YourKey')
        ..waitForTrackingAuthorizationWithTimeoutInterval = 300
        ..skAdNetworkEnabled = true;
      Singular.start(singularConfig);
      await initializeFirebase();
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.ensureInitialized();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 12)));
      await remoteConfig.fetchAndActivate();
      late String apiKey;
      if (Platform.isAndroid) {
        /// For Android dev envoirement is not ready
        apiKey = RevenueCatConst.androidAPIKey;
      } else {
        apiKey = FlavorMode.isDevMode
            ? RevenueCatConstDev.iosAPIKey
            : RevenueCatConst.iosAPIKey;
      }

      purchases_config.PurchasesConfiguration config;

      /// Add usesStoreKit2IfAvailable for this bug  https://community.revenuecat.com/sdks-51/purchases-purchasepackage-doesn-t-return-1956/index2.html
      config = purchases_config.PurchasesConfiguration(apiKey)
        ..usesStoreKit2IfAvailable = true;

      await purchases.Purchases.configure(config);
      await purchases.Purchases.setAttributes({
        'onboarding_type': remoteConfig.getString('onboarding_type'),
        'chat_type': remoteConfig.getString('chat_type')
      });
      final appTrackingStatus = await Permission.appTrackingTransparency.status;
      if (appTrackingStatus == PermissionStatus.denied) {
        await Permission.appTrackingTransparency.request();
        if (await Permission.appTrackingTransparency.status ==
            PermissionStatus.granted) {
          await purchases.Purchases.collectDeviceIdentifiers();
        }
      }
      if (appTrackingStatus == PermissionStatus.granted) {
        await purchases.Purchases.collectDeviceIdentifiers();
      }
      await AmplitudeRepository.init();
      await AppMetricaRepository.activateAppMetrica();
      await LocalNotificationService().init();
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
      await Upgrader.clearSavedSettings(); // REMOVE this for release builds

      await Future.wait([
        EasyLocalization.ensureInitialized(),
        InterceptorInitialize.diInit(),
      ]);
      await AmplitudeRepository.logEvent(logName: 'app_opened');
      await AppMetricaRepository.reportEvent('app_opened');
      await InterceptorInitialize.di<AnalyticServiceRepository>().sendEvent(
          eventName: 'app_opened',
          eventParams: {'device_type': Platform.isIOS ? 'IOS' : 'Android'});

      if (isUxCam) {
        await initializeUxCam();
      }

      final appLanguageCode =
          await SharedPreferencesRepository.getAppLanguage();

      final langCode = appLanguageCode ?? 'en';

      runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('en'),
            Locale('ru'),
            Locale('es'),
            Locale('fr'),
            Locale('de'),
            Locale('it'),
            Locale('pt'),
            Locale('ko'),
          ],
          useFallbackTranslations: true,
          fallbackLocale: Locale(langCode),
          startLocale: Locale(langCode),
          path: 'assets/translations',
          child: const App(),
        ),
      );
    },
    (error, stackTrace) {
      WidgetsFlutterBinding.ensureInitialized();

      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
    zoneSpecification: ZoneSpecification(
      createTimer: (self, parent, zone, duration, void Function() callback) {
        return parent.createTimer(zone, duration, callback);
      },
      createPeriodicTimer:
          (self, parent, zone, duration, void Function(Timer) callback) {
        return parent.createPeriodicTimer(zone, duration, callback);
      },
    ),
  );
}

final config = FlutterUxConfig(
    userAppKey: 'YourUxCamKey', enableAutomaticScreenNameTagging: true);

Future<void> initializeUxCam() async {
  await Future.wait([
    FlutterUxcam.optIntoVideoRecording(),
  ]);

  await FlutterUxcam.startWithConfiguration(config);
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: FlavorMode.isDevMode ? 'dev_project' : null);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest);
}

Future<void> main() async {
  await run();
}
