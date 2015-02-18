package team3d.utils
{
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class World 
	{
		/* ---------------------------------------------------------------------------------------- */
		
		private static	var	_instance	:World;
		
		/* ---------------------------------------------------------------------------------------- */
		
		private 		var _stage		:Stage;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function World($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("Cannot be initialized");
			
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Provides a random number between $min and $max. $max must be equal to or larger than $min
		 *
		 * @param	$min	The minimum number (inclusive)
		 * 			$max	The maximum number (inclusive)
		 * @return			A random number between $min and $max
		 */
		public function Random($min:int, $max:int):int
		{
			if ($max < $min)
				throw new Error("Max is less than min.");
				
			return Math.floor(Math.random() * ($max - $min + 1) + $min);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the stage reference
		 */
		public function get	stage():Stage
		{
			return _stage;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set stage($stage:Stage):void
		{
			_stage = $stage;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public static function get instance():World
		{
			if (_instance == null)
				_instance = new World(SingletonLock);
			
			return _instance;
		}
	}
	
}

class SingletonLock{}