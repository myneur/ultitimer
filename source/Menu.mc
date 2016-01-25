using Toybox.WatchUi as Ui;

class MainMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    if ( item == :menu_item_start ) {
      Ui.pushView( new Rez.Menus.StartMenu(), new StartMenuDelegate(), Ui.SLIDE_UP );
    } else if ( item == :menu_item_rest ) {
      Ui.pushView( new Rez.Menus.RestMenu(), new RestMenuDelegate(), Ui.SLIDE_UP );
    }
  }
}

class StartMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    var value = start_on_countdown;
    if ( item == :menu_item_countdown ) {
      value = start_on_countdown;
    } else if ( item == :menu_item_random ) {
      value = start_on_random;
    } else if ( item == :menu_item_button ) {
      value = start_on_button;
    } else if ( item == :menu_item_motion ) {
      value = start_on_motion;
    }
    App.getApp().setProperty("start", value);
    Ui.popView(Ui.SLIDE_IMMEDIATE);
  }
}

class RestMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
    if ( item == :menu_item_rest_type ) {
      Ui.pushView( new Rez.Menus.RestTypeMenu(), new RestTypeMenuDelegate(), Ui.SLIDE_UP );
    } else if ( item == :menu_item_rest_starts ) {
      Ui.pushView( new Rez.Menus.RestStartsMenu(), new RestStartsMenuDelegate(), Ui.SLIDE_UP );
    }
  }
}

class RestTypeMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
  }
}

class RestStartsTypeMenuDelegate extends Ui.MenuInputDelegate {
  function onMenuItem(item) {
  }
}
