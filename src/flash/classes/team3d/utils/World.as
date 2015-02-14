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