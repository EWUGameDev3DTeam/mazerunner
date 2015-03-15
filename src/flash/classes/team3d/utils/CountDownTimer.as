package team3d.utils
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.osflash.signals.Signal;
	import team3d.objects.World;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class CountDownTimer 
	{
		public var CompletedSignal	:Signal;
		
		private var _mark			:int;
		private var _started		:Boolean;
		private var _millis			:int;
		private var _secs			:int;
		private var _mins			:int;
		private var _hasBeenStarted	:Boolean;
		
		public function CountDownTimer($mins:int = 5, $secs:int = 0, $millis:int = 0)
		{
			_started = false;
			_hasBeenStarted = false;
			CompletedSignal = new Signal();
			
			reset($mins, $secs, $millis);
		}
		
		public function reset($mins:int = 5, $secs:int = 0, $millis:int = 0):void
		{
			_mins = $mins;
			_secs = $secs;
			_millis = $millis;
			_hasBeenStarted = false;
		}
		
		public function get Minutes():int
		{
			return _mins;
		}
		
		public function get Seconds():int
		{
			return _secs;
		}
		
		public function get Milliseconds():int
		{
			return _millis;
		}
		
		public function get HasBeenStarted():Boolean
		{
			return _hasBeenStarted;
		}
		
		public function start():void
		{
			_mark = getTimer();
			if(!_started)
				World.instance.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
			_started = true;
			_hasBeenStarted = true;
		}
		
		public function stop():void
		{
			if (!_started) return;
			_started = false;
			World.instance.stage.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function get elapsed():int
		{
			var newTime:int = getTimer();
			var dt:int = _started ? newTime - _mark : 0;
			_mark = newTime
			return dt;
		}
		
		private function enterFrame($e:Event):void
		{
			_millis -= elapsed;
			
			if (_millis <= 0 && _secs > 0)
			{
				_secs -= 1;
				_millis += 999;
			}
			if (_secs <= 0 && _mins > 0)
			{
				_mins -= 1;
				_secs += 59;
			}
			
			if (_mins <= 0 && _secs <= 0 && _millis <= 0)
			{
				_mins = _secs = _millis = 0;
				stop();
				this.CompletedSignal.dispatch();
				return;
			}
		}
		
		public function toString():String
		{
			var ret:String;
			var seconds:String = _secs.toString();
			
			if (_secs < 10)
				seconds = "0" + seconds;
			
			ret = _mins + ":" + seconds;
			
			
			if (_mins < 1)
			{
				var millis:String = _millis.toString();
				if (_millis < 100 && _millis > 10)
					millis = "0" + millis;
				else if (_millis < 10)
					millis = "00" + millis;
				
				ret += ":" + millis;
			}
			
			return ret;
		}
	}
}