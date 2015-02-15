package team3d.screens
{
	import flash.display.Sprite;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class DebugScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the DebugScreen object.
		 */
		public function DebugScreen()
		{
			super();
			
			this.mouseEnabled	= false;
			this.mouseChildren	= false;
			
			
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

