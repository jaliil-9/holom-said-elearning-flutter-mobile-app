import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  final projectRoot = Directory.current.path;

  // Source files
  final statusBarIcon = File(
      path.join(projectRoot, 'assets', 'icons', 'notification_icon_white.png'));
  final notificationIcon = File(path.join(
      projectRoot, 'assets', 'icons', 'notification_icon_colored.png'));

  // Android drawable directories
  final drawableDirs = [
    'mdpi',
    'hdpi',
    'xhdpi',
    'xxhdpi',
    'xxxhdpi',
  ].map((density) => Directory(path.join(projectRoot, 'android', 'app', 'src',
      'main', 'res', 'drawable-$density')));

  // Create directories if they don't exist
  for (var dir in drawableDirs) {
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    // Copy status bar icon
    final statusBarTarget =
        File(path.join(dir.path, 'ic_stat_notification.png'));
    statusBarIcon.copySync(statusBarTarget.path);

    // Copy notification icon
    final notificationTarget = File(path.join(dir.path, 'ic_notification.png'));
    notificationIcon.copySync(notificationTarget.path);
  }

  // Copy to main drawable directory
  final mainDrawableDir = Directory(path.join(
      projectRoot, 'android', 'app', 'src', 'main', 'res', 'drawable'));
  if (!mainDrawableDir.existsSync()) {
    mainDrawableDir.createSync(recursive: true);
  }

  statusBarIcon
      .copySync(path.join(mainDrawableDir.path, 'ic_stat_notification.png'));
  notificationIcon
      .copySync(path.join(mainDrawableDir.path, 'ic_notification.png'));

  print('Notification icons setup completed!');
}
