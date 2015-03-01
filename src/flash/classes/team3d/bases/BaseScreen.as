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
		public var	DoneSignal	:Signal;
		
		/* ---------------------------------------------------------------------------------------- */
		
		protected var _screenTitle	:String;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function BaseScreen()
		{
			super();
			_screenTitle = "BaseScreen";
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
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		protected function destroy($e:LoaderEvent = null):void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
	}
	
}