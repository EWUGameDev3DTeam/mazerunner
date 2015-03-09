package team3d.utils
{
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class GameData
	{
		public static const SHAREDNAME		:String = "dataTeam3D";
		public static const AUDIO			:String = "audio";
		public static const MOUSEX			:String = "mouseX";
		public static const MOUSEY			:String = "mouseY";
		public static const INVERT			:String = "invertY";
		
		/*
		private static var _instance		:GameData;
		
		private var _data					:SharedObject;
		
		public function GameData($lock:Class)
		{
			if ($lock != singletonlock)
				throw new Error("This is a singleton");
			
			_data = SharedObject.getLocal(SHAREDNAME);
		}
		
		public function getData($s:String):String
		{
			return _data.data[$s];
		}
		
		public function setData($s:String, $data:String):void
		{
			_data.data[$s] = $data;
		}
		
		public function dataExists($s:String):Boolean
		{
			return _data.data[$s] != undefined;
		}
		
		public static function get instance():GameData
		{
			if (_instance == null)
				_instance = new GameData(singletonlock);
			
			return _instance;
		}
		*/
	}
}

class singletonlock{}