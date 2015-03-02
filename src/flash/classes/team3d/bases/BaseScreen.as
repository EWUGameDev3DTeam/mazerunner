package team3d.bases
{
	import com.greensock.events.LoaderEvent;
	import flash.display.Sprite;
	import org.osflash.signals.Signal;
	import team3d.interfaces.IScreen;
	import team3d.objects.World;
	
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
			World.instance.CurrentScreen = _screenTitle;
		}
		
		public function End():void
		{
			
		}
	}
}