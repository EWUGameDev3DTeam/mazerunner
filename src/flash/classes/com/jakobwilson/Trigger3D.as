package  com.jakobwilson
{
	import away3d.core.base.Object3D;
	import org.osflash.signals.Signal;
	import away3d.containers.ObjectContainer3D;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import flash.geom.Vector3D;


	/**
	*	A trigger that can be applied as a child to a mesh using Mesh.addChild()
	*	A wrapper class for the trigger so it can be applied as a child to assets
	*/
	public class Trigger3D extends ObjectContainer3D
	{
		/**NOTE: */
		private var _trig:Trigger;					/**The Trigger object that this wraps(since trigger must have an onFrame handler, it cannot extend ObjectContainer3D)*/
		public var TriggeredSignal:Signal;			/**A signal telling when the trigger has been triggered
		
		/**
		*	Creates a trigger3D with default values for range checkperiod, and Activators
		*	@param int range - how close an activator must be to activate the trigger
		*	@param checkperiod - how often we want to check the trigger(frames)
		*	@param Asset a - a single activator that can be added so you don't have to add it with addActivator()
		*/
		public function Trigger3D(range:int = 100, checkPeriod:int = 20, a:Asset = null) 
		{
			this._trig = new Trigger(range, checkPeriod, a);
			this._trig.position = this.position;
			this.TriggeredSignal = this._trig.TriggeredSignal;
		}
		
		/**
		*	Starts the trigger
		*/
		public function begin()
		{
			this._trig.begin();
		}
		
		/**
		*	Stops the trigger from detecting
		*/
		public function end()
		{
			this._trig.end();
		}
		
		
		/*-----------------------------------ACTIVATOR MANAGEMENT--------------------------------------------*/
		/**
		* Allows you to add an activator(Asset) that will set off the trigger when in range
		*	@param Asset a - the asset that can now set off the trigger
		*/
		public function addActivator(a:Asset)
		{
			this._trig.addActivator(a);
		}
		
		/**
		* Allows you to add an activator(AWPGhostObject) that will set off the trigger when in range
		*	@param AWPGhostObject a - the asset that can now set off the trigger
		*/
		public function addObjectActivator(a:AWPCollisionObject)
		{
			this._trig.addObjectActivator(a);
		}
		
		/**
		* 	Allows you to remove an activator(Asset) so it will no longer set off the trigger
		*	@param Asset a - the asset that can now set off the trigger
		*/
		public function removeActivator(a:Asset)
		{
			this._trig.addActivator(a);
		}
		
		/**
		*	clears all activators so nothing can set off the trigger
		*/
		public function clearActivators()
		{
			this._trig.clearActivators();
		}
		
		override public function set position(v:Vector3D):void
		{
			//this.position = v;
			this._trig.position = v;
		}

	}
	
}
﻿package  com.jakobwilson
{
	import away3d.core.base.Object3D;
	import org.osflash.signals.Signal;
	import away3d.containers.ObjectContainer3D;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import flash.geom.Vector3D;

	/**
	*	A trigger that can be applied as a child to a mesh using Mesh.addChild()
	*	A wrapper class for the trigger so it can be applied as a child to assets
	*/
	public class Trigger3D extends ObjectContainer3D
	{
		/**NOTE: */
		private var _trig:Trigger;					/**The Trigger object that this wraps(since trigger must have an onFrame handler, it cannot extend ObjectContainer3D)*/
		public var TriggeredSignal:Signal;			/**A signal telling when the trigger has been triggered
		
		/**
		*	Creates a trigger3D with default values for range checkperiod, and Activators
		*	@param int range - how close an activator must be to activate the trigger
		*	@param checkperiod - how often we want to check the trigger(frames)
		*	@param Asset a - a single activator that can be added so you don't have to add it with addActivator()
		*/
		public function Trigger3D(range:int = 100, checkPeriod:int = 20, a:Asset = null) 
		{
			this._trig = new Trigger(range, checkPeriod, a);
			this._trig.position = this.position;
			this.TriggeredSignal = this._trig.TriggeredSignal;
		}
		
		/**
		*	Starts the trigger
		*/
		public function begin()
		{
			this._trig.begin();
		}
		
		/**
		*	Stops the trigger from detecting
		*/
		public function end()
		{
			this._trig.end();
		}
		
		
		/*-----------------------------------ACTIVATOR MANAGEMENT--------------------------------------------*/
		/**
		* Allows you to add an activator(Asset) that will set off the trigger when in range
		*	@param Asset a - the asset that can now set off the trigger
		*/
		public function addActivator(a:Asset)
		{
			this._trig.addActivator(a);
		}
		
		/**
		* Allows you to add an activator(AWPGhostObject) that will set off the trigger when in range
		*	@param AWPGhostObject a - the asset that can now set off the trigger
		*/
		public function addObjectActivator(a:AWPCollisionObject)
		{
			this._trig.addObjectActivator(a);
		}
		
		/**
		* 	Allows you to remove an activator(Asset) so it will no longer set off the trigger
		*	@param Asset a - the asset that can now set off the trigger
		*/
		public function removeActivator(a:Asset)
		{
			this._trig.addActivator(a);
		}
		
		/**
		*	clears all activators so nothing can set off the trigger
		*/
		public function clearActivators()
		{
			this._trig.clearActivators();
		}
		
		
		override public function set position(v:Vector3D):void
		{
			this._pos = v;
			this._trig.position = v;
		}

	}
	
}
