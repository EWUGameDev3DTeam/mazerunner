package  com.jakobwilson
{
	import away3d.core.base.Object3D;
	import org.osflash.signals.Signal;
	import away3d.containers.ObjectContainer3D;

	/**
	*	A wrapper class for the trigger so it can be applied as a child to assets
	*/
	public class Trigger3D extends ObjectContainer3D
	{
		private var _trig:Trigger;
		public var TriggeredSignal:Signal;
		
		public function Trigger3D(range:int = 100, checkPeriod:int = 20, a:Asset = null) 
		{
			this._trig = new Trigger(range, checkPeriod, a);
			this._trig.position = this.position;
			this.TriggeredSignal = this._trig.TriggeredSignal;
		}
		
		public function begin()
		{
			this._trig.begin();
		}
		
		public function end()
		{
			this._trig.end();
		}
		
		
		/*-----------------------------------ACTIVATOR MANAGEMENT--------------------------------------------*/
		public function addActivator(a:Asset)
		{
			this._trig.addActivator(a);
		}
		
		public function removeActivator(a:Asset)
		{
			this._trig.addActivator(a);
		}
		public function clearActivators()
		{
			this._trig.clearActivators();
		}

	}
	
}
