enum TabEnum {home, map, alert, trip}

extension TabEnumExtension on TabEnum {
  String get enumToString {
    switch (this) {
      case TabEnum.home:
        return "Home";
      case TabEnum.map:
        return "Map";
      case TabEnum.alert:
        return "Alert";
      case TabEnum.trip:
        return "Trip";
    }
  }
}
