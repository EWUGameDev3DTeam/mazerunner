package team3d.screens
{
	import adobe.utils.CustomActions;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.objects.World;
	import team3d.ui.Button;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class TitleScreen extends BaseScreen
	{
		
		private var _aArrows	:Vector.<Sprite>;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function TitleScreen()
		{
			super();
			
			DoneSignal = new Signal(int);
			_aArrows = new Vector.<Sprite>(3, true);
			_screenTitle = "Title";
			
			initComps();
		}
		
		private function initComps():void
		{
			var overlay:Sprite = LoaderMax.getContent("overlayTitle");
			overlay.width = World.instance.stage.stageWidth;
			overlay.height = World.instance.stage.stageHeight;
			this.addChild(overlay);
			
			var man:Sprite = LoaderMax.getContent("runningManTitle");
			man.x = overlay.width - man.width - 20;
			man.y = 75;
			man.visible = true;
			man.alpha = 1;
			this.addChild(man);
			
			_aArrows[0] = LoaderMax.getContent("titleArrow0");
			_aArrows[0].x = man.x - _aArrows[0].width * 1.5 - 50;
			_aArrows[0].y = man.y + man.height * 0.5 - _aArrows[0].height * 0.5;
			this.addChild(_aArrows[0]);
			for (var i:int = 1; i < _aArrows.length; i++)
			{
				_aArrows[i] = LoaderMax.getContent("titleArrow" + i);
				_aArrows[i].x = _aArrows[i - 1].x + _aArrows[i].width * 0.5 + 5;
				_aArrows[i].y = _aArrows[i - 1].y;
				this.addChild(_aArrows[i]);
			}
			
			var format:TextFormat = new TextFormat();
			format.size = 80;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.name = "titleText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Maze\nRunner";
			tf.x = 50;
			tf.y = 100;
			this.addChild(tf);
			
			var btnPlay:Button = new Button();
			btnPlay.height = 250;
			btnPlay.width = 400;
			btnPlay.text("Play");
			format = new TextFormat();
			format.size = 60;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnPlay.textFormat = format;
			btnPlay.x = tf.x;
			btnPlay.y = tf.y +tf.height + 25;
			this.addChild(btnPlay);
			
			var btnCredits:Button = new Button();
			btnCredits.width = 200;
			btnCredits.height = 100;
			btnCredits.text("Credits");
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnCredits.textFormat = format;
			btnCredits.x = btnPlay.x + btnPlay.width + 100;
			btnCredits.y = btnPlay.y;
			this.addChild(btnCredits);
			
			var btnSettings:Button = new Button();
			btnSettings.width = 200;
			btnSettings.height = 100;
			btnSettings.text("Settings");
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnSettings.textFormat = format;
			btnSettings.x = btnCredits.x;
			btnSettings.y = btnPlay.y + btnPlay.height - btnSettings.height;
			this.addChild(btnSettings);
			
			btnPlay.addEventListener(MouseEvent.CLICK, playClicked);
			btnCredits.addEventListener(MouseEvent.CLICK, creditsClicked);
			btnSettings.addEventListener(MouseEvent.CLICK, settingsClicked);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			
			World.instance.stage.addEventListener(FullScreenEvent.FULL_SCREEN, registerAccepted);
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		private function registerAccepted($e:FullScreenEvent)
		{
			World.instance.stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, goFullScreen);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function playClicked($e:MouseEvent):void 
		{
			if (World.instance.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{
				World.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				this.visible = false;
				// COMMENT THIS LINE BEFORE COMPILING FOR BROWSER DEPLOYMENT
				if(root.loaderInfo.parameters.browser == null)
					goFullScreen();
			}
			else
				TweenMax.fromTo(this, _fadeTime, { autoAlpha:1 }, { autoAlpha:0, onComplete:goFullScreen } );
		}
		
		private function goFullScreen($e:FullScreenEvent = null):void
		{
			World.instance.stage.mouseLock = true;
			World.instance.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, registerAccepted);
			World.instance.stage.removeEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, goFullScreen);
			this.DoneSignal.dispatch(BaseScreen.TUTORIAL);
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Shows the credits screen
		 */
		private function creditsClicked($e:MouseEvent):void
		{
			this.DoneSignal.dispatch(BaseScreen.CREDITS);
			TweenMax.fromTo(this, _fadeTime, { autoAlpha:1 }, { autoAlpha:0 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function settingsClicked($e:MouseEvent):void
		{
			this.DoneSignal.dispatch(BaseScreen.SETTINGS);
			TweenMax.fromTo(this, _fadeTime, { autoAlpha:1 }, { autoAlpha:0 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			super.End();
		}
	}
}