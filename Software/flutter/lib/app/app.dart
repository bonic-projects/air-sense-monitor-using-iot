import 'package:air_quality_sensor/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:air_quality_sensor/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:air_quality_sensor/ui/views/home/home_view.dart';
import 'package:air_quality_sensor/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:air_quality_sensor/services/database_service.dart';
import 'package:air_quality_sensor/services/alert_service.dart';
import 'package:air_quality_sensor/services/notification_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: AlertService),
    LazySingleton(classType: NotificationService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
