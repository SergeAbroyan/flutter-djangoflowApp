extension UtilsAppExtension on UtilsAppType {
  String getFAQText() {
    switch (this) {
      case UtilsAppType.user:
        return 'Student';
      case UtilsAppType.driver:
        return 'Professors';
    }
  }
}

enum UtilsAppType { user, driver }
