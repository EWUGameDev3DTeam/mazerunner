package team3d.screens
{
	import adobe.utils.CustomActions;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.TweenMax;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.osflash.signals.Signal;
	import team3d.objects.World;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class LoadScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		public var		DoneSignal	:Signal;
		
		private var		_titleLogo	:Sprite;
		
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
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		public function Begin():void
		{
			World.instance.CurrentScreen = "Loading";
			DebugScreen.Text.text = "Now in loading screen";
			var loading:ImageLoader = new ImageLoader("Images/loading.jpg", { name:"loadingImage", container:this, x:0, y:0, width:900, height:600, scaleMode:"strech", onComplete:show } );
			loading.load();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		private function show($e:LoaderEvent = null):void
		{
			trace("load screen loaded");
			_titleLogo = Sprite($e.target.content);
			TweenMax.fromTo(_titleLogo, 1, { autoAlpha:0 }, { autoAlpha:1 } );
			this.visible = true;
			
			World.instance.stage.addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function mouseClick(e:MouseEvent):void 
		{
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		public function End():void
		{
			World.instance.stage.removeEventListener(MouseEvent.CLICK, mouseClick);
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
			TweenMax.fromTo(_titleLogo, 1, { autoAlpha: 1 }, { autoAlpha:0, onComplete:destroy } );
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

