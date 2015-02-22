package team3d.utils
{
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class Utils 
	{
		private static var _instance	:Utils;
		
		public function Utils($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("Cannot be instantiated.");
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
		 * Returns the instance of the singleton
		 * @return			The instance
		 */
		public static function get instance():Utils
		{
			if (_instance == null)
				_instance = new Utils(SingletonLock);
			
			return _instance;
		}
	}
	
}
class SingletonLock{}