package team3d.screens
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.objects.World;
	import team3d.ui.GameButton;
	import treefortress.sound.SoundAS;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class PauseScreen extends BaseScreen
	{
		private var _btnSettings	:GameButton;
		private var _btnControls	:GameButton;
		private var _btnQuit		:GameButton;
		private var _btnContinue	:GameButton;
		private var _btnFullscreen	:GameButton;
		
		private var _loaded			:Boolean;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function PauseScreen()
		{
			super();
			
			DoneSignal = new Signal(int);
			_screenTitle = "Pause";
			_fadeTime = 0.2;
			
			initComps();
		}
		
		private function initComps()
		{
			//var offset:Number = 0.8;
			var overlay:Sprite = LoaderMax.getContent("overlayPause");
			overlay.width = World.instance.stage.stageWidth;// * offset;
			overlay.height = World.instance.stage.stageHeight;// * offset;
			//overlay.x = (World.instance.stage.stageWidth - overlay.width) * 0.5;
			//overlay.y = (World.instance.stage.stageHeight - overlay.height) * 0.5;
			this.addChild(overlay);
			
			var man:Sprite = LoaderMax.getContent("runningManTitle");
			man.width += 50;
			man.height += 75;
			man.x = overlay.x + 50;
			man.y = overlay.y + 75;
			this.addChild(man);
			
			var btnwidth:Number = 200;
			var btnheight:Number = 75;
			var format:TextFormat = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			
			_btnSettings = new GameButton();
			_btnSettings.name = "btnSettings";
			_btnSettings.text("Settings");
			_btnSettings.width = btnwidth;
			_btnSettings.height = btnheight;
			_btnSettings.textFormat = format;
			_btnSettings.x = man.x + man.width + 25;
			_btnSettings.y = man.y + 20;
			this.addChild(_btnSettings);
			
			_btnControls = new GameButton();
			_btnControls.name = "btnControls";
			_btnControls.text("Controls");
			_btnControls.width = btnwidth;
			_btnControls.height = btnheight;
			_btnControls.textFormat = format;
			_btnControls.x = _btnSettings.x;
			_btnControls.y = _btnSettings.y + _btnSettings.height + 20;
			this.addChild(_btnControls);
			
			_btnQuit = new GameButton();
			_btnQuit.name = "btnQuit";
			_btnQuit.text("Quit");
			_btnQuit.width = btnwidth;
			_btnQuit.height = btnheight;
			_btnQuit.textFormat = format;
			_btnQuit.x = _btnControls.x;
			_btnQuit.y = _btnControls.y + _btnControls.height + 20;
			this.addChild(_btnQuit);
			
			_btnContinue = new GameButton();
			_btnContinue.name = "btnContinue";
			_btnContinue.text("Continue");
			_btnContinue.width = btnwidth;
			_btnContinue.height = btnheight;
			_btnContinue.textFormat = format;
			_btnContinue.x = _btnQuit.x + _btnQuit.width + 20;
			_btnContinue.y = _btnQuit.y + _btnQuit.height + 20;
			this.addChild(_btnContinue);
			
			_btnFullscreen = new GameButton();
			_btnFullscreen.name = "btnFullScreen";
			_btnFullscreen.text("Full Screen");
			_btnFullscreen.width = btnwidth;
			_btnFullscreen.height = btnheight;
			_btnFullscreen.textFormat = format;
			_btnFullscreen.x = _btnQuit.x;
			_btnFullscreen.y = _btnQuit.y + _btnQuit.height + 20;
			this.addChild(_btnFullscreen);
			
			_btnFullscreen.addEventListener(MouseEvent.CLICK, fullscreenClicked);
			_btnSettings.addEventListener(MouseEvent.CLICK, settingsClicked);
			_btnControls.addEventListener(MouseEvent.CLICK, controlsClicked);
			_btnQuit.addEventListener(MouseEvent.CLICK, quitClicked);
			_btnContinue.addEventListener(MouseEvent.CLICK, continueClicked);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			World.instance.stage.addEventListener(FullScreenEvent.FULL_SCREEN, showFullscreenBtn);
			
			_btnFullscreen.visible = true;
			_btnFullscreen.alpha = 1;
			if (World.instance.isFullScreenInteractive)
				_btnFullscreen.visible = false;
			
			World.instance.unlockMouse();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function settingsClicked($e:MouseEvent):void 
		{
			this.DoneSignal.dispatch(BaseScreen.SETTINGS);
		}
		
		private function controlsClicked($e:MouseEvent):void
		{
			this.DoneSignal.dispatch(BaseScreen.CONTROLS);
		}
		
		private function quitClicked($e:MouseEvent):void
		{
			this.DoneSignal.dispatch(BaseScreen.TITLE);
		}
		
		private function continueClicked($e:MouseEvent):void
		{
			if(World.instance.isFullScreenInteractive)
			{
				if(World.instance.lockMouse())
					this.DoneSignal.dispatch(BaseScreen.GAME);
			}
			else
			{
				TweenMax.to(this.getChildByName("btnFullScreen"), 0.2, { glowFilter: { alpha:1, color:0x91e600, blurX:30, blurY:30, strength:2, quality:2 }, yoyo:true, repeat:3} );
			}
		}
		
		private function fullscreenClicked($e:MouseEvent):void
		{
			World.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		
		private function showFullscreenBtn(e:FullScreenEvent = null):void 
		{
			_btnFullscreen.visible = true;
			if (World.instance.isFullScreenInteractive)
				TweenMax.fromTo(_btnFullscreen, 0.5, { autoAlpha:1 }, { autoAlpha:0 } );
			else
				TweenMax.fromTo(_btnFullscreen, 0.5, { autoAlpha:0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			World.instance.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, showFullscreenBtn);
			super.End();
		}
		
		//override protected function resize($e:Event = null):void 
		{
			//super.resize($e);
			// do nothing, VERY intentional
		}
	}
}