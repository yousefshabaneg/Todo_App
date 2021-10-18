abstract class AppStates {}

class AppInitialState extends AppStates {
  AppInitialState() {}
}

class AppChangeBottomNavBarState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}

class AppInsertDatabaseState extends AppStates {}

class AppUpdateDatabaseState extends AppStates {}

class AppDeleteDatabaseState extends AppStates {}

class AppGetDatabaseState extends AppStates {}

class AppLoadingIndicatorState extends AppStates {}

class ChangeBottomSheetState extends AppStates {}
