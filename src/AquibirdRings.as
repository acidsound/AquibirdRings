package {

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.ui.Keyboard;

public class AquibirdRings extends Sprite {
  private var stageLoader:Loader;
  private var _Content:MovieClip;
  private var main:MovieClip;
  private var relativeDeltaHeight:Number;

  public function AquibirdRings() {
    stage.align = StageAlign.TOP_LEFT;
    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    /* set Android Exit Handler */
    if (Capabilities.cpuArchitecture == "ARM") {
      NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
      NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
      NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
    }
  }

  private static function handleActivate(event:Event):void {
    NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
  }

  private function handleDeactivate(event:Event):void {
  }

  private static function handleKeys(event:KeyboardEvent):void {
    if (event.keyCode == Keyboard.BACK) {
      NativeApplication.nativeApplication.exit();
    }
  }

  private function onAddedToStage(event:Event):void {
    stageLoader = new Loader();
    stageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
    stageLoader.load(new URLRequest("./AquibirdRingsVersion1.0.swf"));
  }

  private function onComplete(event:Event):void {
    stageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
    _Content = MovieClip(event.currentTarget.content);
    addChild(_Content);
    _Content.visible = true;

    /* scale swf - what the ;; */
    _Content.scaleX = 320 / 409;
    _Content.scaleY = 320 / 409;
    _Content.stopAllMovieClips();

    main = _Content.Main;
    relativeDeltaHeight = (main.BackgroundBox.width / stage.fullScreenWidth * stage.fullScreenHeight) - main.BackgroundBox.height;
    main.SongFrame.y += relativeDeltaHeight;
    main.ButtonFrame.y += relativeDeltaHeight;
  }
}
}
