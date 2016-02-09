using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class WorkoutMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    if ( item == :menu_item_workout_plan ) {
      Ui.pushView( new Rez.Menus.WorkoutPlanMenu(), new WorkoutPlanMenuDelegate(), Ui.SLIDE_UP );
    } else if ( item == :menu_item_workout_settings ) {
      Ui.pushView( new Rez.Menus.WorkoutSettingsMenu(), new WorkoutSettingsMenuDelegate(), Ui.SLIDE_UP );
    }
  }
}

class WorkoutPlanMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    if ( item == :menu_item_workout_plan_distance ) {
      Ui.pushView(
        new DistancePicker("Distance"),
        new DistancePickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    } else if ( item == :menu_item_workout_plan_target ) {
      var distance = App.getApp().getProperty("distance");
      var time = App.getApp().getProperty("target");
      Ui.pushView(
        new NumberPicker([1, 180], time - 1, "Target time for " + distance + "m"),
        new TargetPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    } else if ( item == :menu_item_workout_plan_reps ) {
      var reps = App.getApp().getProperty("reps");
      Ui.pushView(
        new NumberPicker([1, 12], reps - 1, "Number of reps"),
        new RepsPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    } else if ( item == :menu_item_workout_plan_rest ) {
      var distance = App.getApp().getProperty("distance");
      var rest = App.getApp().getProperty("rest");
      Ui.pushView(
        new TimePicker([1, 180], rest, "Rest time for " + distance + "m"),
        new RestPickerDelegate(),
        Ui.SLIDE_IMMEDIATE);
    }
  }
}

class WorkoutSettingsMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    if ( item == :menu_item_workout_settings_start ) {
      Ui.pushView( new Rez.Menus.WorkoutSettingsStartMenu(), new WorkoutSettingsStartMenuDelegate(), Ui.SLIDE_UP );
    } else if ( item == :menu_item_workout_settings_stop ) {
      Ui.pushView( new Rez.Menus.WorkoutSettingsStopMenu(), new WorkoutSettingsStopMenuDelegate(), Ui.SLIDE_UP );
    } else if ( item == :menu_item_workout_settings_backlight ) {
      Ui.pushView( new Rez.Menus.WorkoutSettingsBacklightMenu(), new WorkoutSettingsBacklightMenuDelegate(), Ui.SLIDE_UP );
    }
  }
}

class WorkoutSettingsStartMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    var value = start_on_button;
    if ( item == :menu_item_workout_settings_start_on_countdown ) {
      value = start_on_countdown;
    } else if ( item == :menu_item_workout_settings_start_on_button ) {
      value = start_on_button;
    }
    App.getApp().setProperty("start", value);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }
}

class WorkoutSettingsStopMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    var value = stop_on_target;
    if ( item == :menu_item_workout_settings_stop_on_button ) {
      value = stop_on_button;
    } else if ( item == :menu_item_workout_settings_stop_on_target ) {
      value = stop_on_target;
    }
    App.getApp().setProperty("stop", value);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }
}

class WorkoutSettingsBacklightMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    var value = backlight_on;
    if ( item == :menu_item_workout_settings_backlight_on ) {
      value = backlight_on;
    } else if ( item == :menu_item_workout_settings_backlight_off ) {
      value = backlight_off;
    }
    App.getApp().setProperty("backlight", value);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }
}
