package {

import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.ui.Keyboard;

[SWF(backgroundColor="0x000000", scaleMode="noScale", quality=1)]
public class main extends Sprite {
  private var stageLoader:Loader;
  public var _Content:MovieClip;
  private var relativeDeltaHeight:Number;
  private var c:MovieClip;
  private var songFiles:Array;
  private var soundLoader:Sound;
  private var playStatus:Boolean=false;
  private var soundChannel:SoundChannel;
  private var SongBox:MovieClip;
  private var HelpBox:MovieClip;
  private var DownloadBox:MovieClip;

  public function main() {
    stage.align = StageAlign.TOP_LEFT;

    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

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
    removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    stageLoader = new Loader();
    stageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
    stageLoader.load(new URLRequest("AquibirdRingsVersion1.0.swf"));
  }

  private function onComplete(event:Event):void {
    stageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
    _Content = MovieClip(event.currentTarget.content);
    addChild(_Content);
    _Content.visible = false;

    /* scale swf - what the ;; */
    _Content.scaleX = 320 / 409;
    _Content.scaleY = 320 / 409;
    _Content.stopAllMovieClips();

    c = _Content.Main;
    relativeDeltaHeight = (c.BackgroundBox.width / stage.fullScreenWidth * stage.fullScreenHeight) - c.BackgroundBox.height;
    c.SongBox.y += relativeDeltaHeight;
    c.ButtonBox.y += relativeDeltaHeight;

    SongBox = MovieClip(c.SongBox);
    HelpBox = MovieClip(c.HelpBox);
    DownloadBox = MovieClip(c.DownloadBox);
    attachEvents();
  }

  private function attachEvents():void {
//    trace(File.applicationStorageDirectory.resolvePath("data/filename.dat").exists))
//    songFiles = File.applicationDirectory.resolvePath("./mp3_128/").getDirectoryListing();
//    c.SongBox.SongInfo.SongTitleLeft = songFiles[0]
    _Content.visible = true;
//    soundLoader = new Sound(new URLRequest("./mp3_128/01_My Name.mp3"));
//    playCurrentTrack();

    // transport
    MovieClip(c.ButtonBox.PlayButton).addEventListener(MouseEvent.CLICK, onPlayButtonClick);
    MovieClip(c.ButtonBox.LeftButton).addEventListener(MouseEvent.CLICK, onLeftButtonClick);
    MovieClip(c.ButtonBox.RightButton).addEventListener(MouseEvent.CLICK, onRightButtonClick);
    MovieClip(c.ButtonBox.HelpButton).addEventListener(MouseEvent.CLICK, onHelpButtonClick);
    MovieClip(c.ButtonBox.DownloadButton).addEventListener(MouseEvent.CLICK, onDownloadButtonClick);
  }

  private function onPlayButtonClick(event:MouseEvent):void {
    MovieClip(c.ButtonBox.PlayButton).gotoAndStop(
      MovieClip(c.ButtonBox.PlayButton).currentLabel === "Play" && "Pause" || "Play"
    );
  }

  private function onFlyFrame(event:Event):void {
    if (event.currentTarget.currentLabel==="StopL" || event.currentTarget.currentLabel==="StopR") {
      SongBox.stop();
      SongBox.removeEventListener(Event.ENTER_FRAME, onFlyFrame);
    }
  }

  private function resetEventListener(object:MovieClip, event:String, callBack:Function):void {
    if (object.hasEventListener(event)) {
      object.removeEventListener(event, callBack);
    }
    object.addEventListener(event, callBack);
  }

  private function onLeftButtonClick(event:MouseEvent):void {
    SongBox.gotoAndPlay("FlyLeft");
    resetEventListener(SongBox, Event.ENTER_FRAME, onFlyFrame);
  }

  private function onRightButtonClick(event:MouseEvent):void {
    SongBox.gotoAndPlay("FlyRight");
    resetEventListener(SongBox, Event.ENTER_FRAME, onFlyFrame);
  }

  private function onHelpButtonClick(event:MouseEvent):void {
    if (HelpBox.currentFrame>1) {
      onHelpClose(event);
    } else {
      HelpBox.gotoAndPlay(0);
      HelpBox.addEventListener(MouseEvent.CLICK, onHelpClose);
      resetEventListener(HelpBox, Event.ENTER_FRAME, onHelpFrame);
    }
  }

  private function onHelpClose(event:MouseEvent):void {
    HelpBox.gotoAndStop(0);
    HelpBox.removeEventListener(MouseEvent.CLICK, onHelpClose);
  }

  private function onHelpFrame(event:Event):void {
    if (event.currentTarget.currentFrame === event.currentTarget.totalFrames) {
      event.currentTarget.stop();
      event.currentTarget.removeEventListener(Event.ENTER_FRAME, onHelpFrame);
    }
  }

  private function onDownloadButtonClick(event:MouseEvent):void {
    /* Do Something */
    DownloadBox.gotoAndPlay(0);
    resetEventListener(DownloadBox, Event.ENTER_FRAME, onDownloadFrame);
  }

  private function onDownloadFrame(event:Event):void {
    if (event.currentTarget.currentFrame === event.currentTarget.totalFrames) {
      event.currentTarget.stop();
      event.currentTarget.removeEventListener(Event.ENTER_FRAME, onHelpFrame);
    }
  }

  private function playCurrentTrack():void {
    if (playStatus) {
      soundChannel.stop();
      soundChannel = soundLoader.play(0);
      soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    } else {
      soundChannel.stop();
    }
  }

  private function pauseCurrentTrack():void {
    soundChannel.stop();
  }

  private function onSoundComplete(e:Event):void {
    playStatus = false;
    setPlayStatus();
  }

  private function setPlayStatus():void {

  }

}
}
