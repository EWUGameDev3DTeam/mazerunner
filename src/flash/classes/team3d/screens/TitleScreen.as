package team3d.screens
{
	import adobe.utils.CustomActions;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
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
	public class TitleScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		public var	DoneSignal	:Signal;
		
		private var _titleLogo	:Sprite;
		
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
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		public function Begin():void
		{
			World.instance.CurrentScreen = "Title";
			DebugScreen.Text.text = "Now in title screen";
			var title:ImageLoader = new ImageLoader("Images/titlescreen.jpg", { name:"titleimage", container:this, x:0, y:0, width:900, height:600, scaleMode:"stretch", onComplete:show } );
			title.load();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		public function show($e:LoaderEvent):void
		{
			trace("title loaded");
			_titleLogo = Sprite($e.target.content);
			TweenMax.fromTo(_titleLogo, 1, { autoAlpha: 0 }, { autoAlpha:1 } );
			this.visible = true;
			World.instance.stage.addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function mouseClick($e:MouseEvent):void 
		{
			if (World.instance.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE)
			{
				DebugScreen.Text.text = "here";
				World.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				DebugScreen.Text.text += "\nand here";
			}
			this.DoneSignal.dispatch(0);
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
		 */
		protected function hide():void
		{
			TweenMax.fromTo(_titleLogo, 1, { autoAlpha:1 }, { autoAlpha:0, onComplete:destroy } );
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

