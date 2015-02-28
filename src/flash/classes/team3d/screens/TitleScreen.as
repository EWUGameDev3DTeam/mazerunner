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
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.objects.World;
	import team3d.ui.Button;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class TitleScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		public var	DoneSignal	:Signal;
		
		private var _aArrows	:Vector.<Sprite>;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function TitleScreen()
		{
			super();
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.visible = false;
			
			DoneSignal = new Signal(int);
			_aArrows = new Vector.<Sprite>(3, true);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		public function Begin():void
		{
			World.instance.CurrentScreen = "Title";
			var queue:LoaderMax = new LoaderMax( { onComplete: show } );
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayTitle", container:this, width:this.stage.stageWidth, height:this.stage.stageHeight, scaleMode:"stretch" } );
			var runningMan:ImageLoader = new ImageLoader("images/GUI/Man.png", { name: "runningMan", container:this } );
			
			queue.append(overlay);
			queue.append(runningMan);
			
			for (var i:int = 0; i < _aArrows.length; i++)
				queue.append(new ImageLoader("images/GUI/Arrow.png", { name: ("titleArrow" + i), width:146, height:175, container:this } ));
			
			queue.load();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		private function show($e:LoaderEvent = null):void
		{
			var man:Sprite = LoaderMax.getContent("runningMan");
			man.x = this.width - man.width - 20;
			man.y = 75;
			
			_aArrows[0] = LoaderMax.getContent("titleArrow0");
			_aArrows[0].x = man.x - _aArrows[0].width * 1.5 - 50;
			_aArrows[0].y = man.y + man.height * 0.5 - _aArrows[0].height * 0.5;
			for (var i:int = 1; i < _aArrows.length; i++)
			{
				_aArrows[i] = LoaderMax.getContent("titleArrow" + i);
				_aArrows[i].x = _aArrows[i - 1].x + _aArrows[i].width * 0.5 + 5;
				_aArrows[i].y = _aArrows[i - 1].y;
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
			btnPlay.x = tf.x;
			btnPlay.y = tf.y + 125;
			btnPlay.height = 400;
			btnPlay.text("Play");
			format = new TextFormat();
			format.size = 60;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnPlay.textFormat = format;
			this.addChild(btnPlay);
			
			var btnCredits:Button = new Button();
			btnCredits.width = 250;
			btnCredits.height = 175;
			btnCredits.x = btnPlay.width + 100;
			btnCredits.y = btnPlay.y + 50;
			btnCredits.text("Credits");
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnCredits.textFormat = format;
			this.addChild(btnCredits);
			
			var btnSettings:Button = new Button();
			btnSettings.width = 250;
			btnSettings.height = 175;
			btnSettings.x = btnCredits.x;
			btnSettings.y = btnPlay.y + btnPlay.height - btnSettings.height;
			btnSettings.text("Settings");
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnSettings.textFormat = format;
			this.addChild(btnSettings);
			
			btnPlay.addEventListener(MouseEvent.CLICK, mouseClick);
			TweenMax.fromTo(this, 1, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function mouseClick($e:MouseEvent):void 
		{
			if (World.instance.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{
				World.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			this.DoneSignal.dispatch(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		public function End():void
		{
			hide();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Hides the screen
		 */
		protected function hide():void
		{
			TweenMax.fromTo(this, 1, { autoAlpha:1 }, { autoAlpha:0, onComplete:destroy } );
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy($e:LoaderEvent = null):void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}