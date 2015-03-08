package team3d.bases
{
	import com.greensock.events.LoaderEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.osflash.signals.Signal;
	import team3d.interfaces.IScreen;
	import team3d.objects.World;
	import team3d.screens.DebugScreen;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class BaseScreen extends Sprite implements IScreen
	{
		public static const TITLE:int = 0;
		public static const CREDITS:int = 1;
		public static const SETTINGS:int = 2;
		public static const GAME:int = 3;
		public static const PAUSE:int = 4;
		public static const WON:int = 5;
		public static const LOST:int = 6;
		public static const CONTROLS:int = 7;
		public static const TUTORIAL:int = 8;
		
		public var	DoneSignal	:Signal;
		
		/* ---------------------------------------------------------------------------------------- */
		
		protected var _screenTitle	:String;
		protected var _fadeTime		:Number;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function BaseScreen()
		{
			super();
			_screenTitle = "BaseScreen";
			_fadeTime = 0.5;
			this.mouseEnabled = true;
			this.mouseChildren = true;
			this.visible = false;
		}
		
		public function Begin():void
		{
			World.instance.addEventListener(Event.RESIZE, resize);
			World.instance.CurrentScreen = _screenTitle;
			this.visible = true;
			
			if (this.width != World.instance.stage.stageWidth || this.height != World.instance.stage.stageHeight)
				resize();
		}
		
		protected function resize($e:Event = null):void
		{
			var scale:Boolean = false;
			if (scale)
			{
			//trace("current size: " + this.width + " - " + this.height);
			//trace("new size: " + World.instance.stage.stageWidth);
				var wRatio:Number = World.instance.stage.stageWidth / this.width;
				var hRatio:Number = World.instance.stage.stageHeight / this.height;
				
				this.width *= wRatio;
				this.height *= hRatio;
			//trace("wRatio: " + wRatio);
			//trace("hRight: " + hRatio);
			}
			else
			{
				this.x = (World.instance.stage.stageWidth - this.width) * 0.5;
				this.y = (World.instance.stage.stageHeight - this.height) * 0.5;
			}
			//this.x *= wRatio;
			//this.y *= hRatio;
		}
		
		public function End():void
		{
			World.instance.removeEventListener(Event.RESIZE, resize);
			this.visible = false;
		}
	}
}