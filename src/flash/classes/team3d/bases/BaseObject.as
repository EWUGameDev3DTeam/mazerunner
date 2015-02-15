package team3d.bases
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import team3d.utils.World;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class BaseObject extends MovieClip
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the BaseObject object.
		 */
		public function BaseObject()
		{
			super();
			
			this.mouseEnabled	= false;
			this.mouseChildren	= false;
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * starts the object
		 */
		public function Begin():void
		{
			World.instance.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * ends the object
		 */
		public function End():void
		{
			World.instance.stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * shows the object
		 */
		public function Show():void
		{
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * hides the object
		 */
		public function Hide():void
		{
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * 
		 */
		protected function enterFrame($e:Event):void
		{
			// do nothing
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

