package team3d.screens
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	import team3d.objects.World;
	import team3d.ui.Button;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class LoadScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		public var		DoneSignal	:Signal;
		private var		_aArrows	:Vector.<Sprite>;
		private var 	_tProgress	:Timer;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function LoadScreen()
		{
			super();
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.visible = false;
			
			this.DoneSignal = new Signal();
			_aArrows = new Vector.<Sprite>(25, true);
			_tProgress = new Timer(200, _aArrows.length);
			_tProgress.addEventListener(TimerEvent.TIMER, tick);
			_tProgress.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
		}
		
		private function timerDone(e:TimerEvent):void 
		{
			var tf:TextField = TextField(this.getChildByName("loadingText"));
			TweenMax.fromTo(tf, 0.5, { autoAlpha:1 }, { autoAlpha:0, delay:1 } );
			for (var i:int = 0; i < _aArrows.length; i++)
				TweenMax.fromTo(_aArrows[i], 0.5, { autoAlpha:1 }, { autoAlpha:0, delay:1 } );
			
			TweenMax.fromTo(this.getChildByName("btnContinue"), 0.5, { autoAlpha:0 }, { autoAlpha:1, delay:1 } );
		}
		
		var lastTick:int;
		private function tick(e:TimerEvent):void 
		{
			var curTick:int = Timer(e.target).currentCount;
			var dif:int = curTick - lastTick;
			for (var i:int = 0; i < dif; i++)
				TweenMax.fromTo(_aArrows[lastTick + i], 0.5, { autoAlpha:0 }, { autoAlpha:1 } );
			
			lastTick = curTick;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		public function Begin():void
		{
			World.instance.CurrentScreen = "Loading";
			var queue:LoaderMax = new LoaderMax( { onProgress:initProg, onComplete:show } );
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name:"overlayLoad", width:900, height:600, scaleMode:"strech" } );
			
			queue.append(overlay);
			
			for (var i:int = 0; i < _aArrows.length; i++)
				queue.append(new ImageLoader("images/GUI/Arrow.png", { name:("arrow" + i), width:50, height:60, alpha:0 } ));
			
			queue.load();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Displays the initial progress to the trace (maybe screen?)
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		protected function initProg($e:LoaderEvent = null):void
		{
			trace($e.target.progress);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		private function show($e:LoaderEvent = null):void
		{
			
			var background:Sprite = Sprite(LoaderMax.getContent("overlayLoad"));
			
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.name = "loadingText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Loading...";
			tf.x = 50;
			tf.y = 425;
			
			this.addChild(background);
			this.addChild(tf);
			
			format = new TextFormat();
			format.size = 48;
			format.bold = true;
			tf = new TextField();
			tf.name = "summaryText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Sentenced to life you have chosen to take\n";
			tf.appendText("on the Doxen Empire's maze.\n");
			tf.appendText("This is your only chance for escape;\n");
			tf.appendText("however, those who fail die...\n");
			tf.appendText("        ... and there is no turning back.");
			tf.x = 45;
			tf.y = 100;
			this.addChild(tf);
			
			_aArrows[0] = LoaderMax.getContent("arrow0");
			_aArrows[0].x = 50;
			_aArrows[0].y = 475;
			this.addChild(_aArrows[0]);
			for (var i:int = 1; i < _aArrows.length; i++)
			{
				_aArrows[i] = LoaderMax.getContent("arrow" + i);
				_aArrows[i].x = _aArrows[i - 1].x + _aArrows[i].width * 0.5 + 5;
				_aArrows[i].y = _aArrows[i - 1].y;
				this.addChild(_aArrows[i]);
			}
			
			var btn:Button = new Button();
			btn.name = "btnContinue";
			btn.visible = false;
			btn.x = (this.width - btn.width) * 0.5;
			btn.y = 450 - btn.height * 0.5 + 20;
			btn.text("Proceed");
			format = new TextFormat();
			format.size = 60;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btn.textFormat = format;
			btn.addEventListener(MouseEvent.CLICK, mouseClick);
			this.addChild(btn);
			
			TweenMax.fromTo(this, 1, { autoAlpha:0 }, { autoAlpha:1 } );
			_tProgress.start();
			
			
		}
		
		private function mouseClick(e:MouseEvent):void 
		{
			trace("done");
			this.DoneSignal.dispatch();
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
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		protected function hide():void
		{
			TweenMax.fromTo(this, 1, { autoAlpha: 1 }, { autoAlpha:0, onComplete:destroy } );
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

