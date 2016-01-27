using Toybox.WatchUi as Ui;
using Toybox.Application as App;

class MainMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    if ( item == :menu_item_start ) {
      Ui.pushView( new Rez.Menus.StartMenu(), new StartMenuDelegate(), Ui.SLIDE_UP );
    } else if ( item == :menu_item_stop ) {
      Ui.pushView( new Rez.Menus.StopMenu(), new StopMenuDelegate(), Ui.SLIDE_UP );
    }
  }
}

class StartMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    var value = start_on_countdown;
    if ( item == :menu_item_start_on_countdown ) {
      value = start_on_countdown;
    } else if ( item == :menu_item_start_on_button ) {
      value = start_on_button;
    }
    App.getApp().setProperty("start", value);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }
}

class StopMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    var value = stop_on_button;
    if ( item == :menu_item_stop_on_button ) {
      value = stop_on_button;
    } else if ( item == :menu_item_stop_on_target ) {
      value = stop_on_target;
    }
    App.getApp().setProperty("stop", value);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }
}
