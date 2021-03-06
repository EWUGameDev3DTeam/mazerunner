﻿package  com.jakobwilson
{
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import com.jakobwilson.Asset;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.objects.World;
	
	/**
	*	A trigger class that maintains a list of assets that can trigger it(called activators). 
	*	If any of the activators get within range, the trigger is set off and an event is dispatched
	*	@author Jakob Wilson
	**/
	public class Trigger extends Sprite
	{
		/*------------------------------------MEMBERS-------------------------------------------*/
		public var TriggeredSignal:Signal = new Signal(Asset);			/** The signal dispatched when an activator gets in range*/
		public var bIsTriggered = false;								/** A boolean to indicate is the trigger is being activated*/
		private var _watchList:Vector.<Asset> = new Vector.<Asset>();	/** The list of Activators (of type Asset)*/
		private var _objectList:Vector.<AWPCollisionObject> = new Vector.<AWPCollisionObject>();	/** The list of Activators (of type GhostObject)*/
		private var _range = 100;										/** The sensory range of the trigger*/
		private var _position;											/** The position of the trigger*/
		private var _checkNum = 0;										/** A number used to manage how often checks are made*/
		private var _checkPeriod;										/** A number to indicate how many frames to skip between checks*/
		
		/*------------------------------------CONSTRUCTOR-------------------------------------------*/
		/**
		*	Creates a trigger that looks for certain Assets and dispatches a signal if they collide
		*/
		public function Trigger(range:int = 100, checkPeriod:int = 20, a:Asset = null) 
		{
			this._position = new Vector3D();
			this._checkPeriod = checkPeriod;
			this._range = range;// constructor code
			if(a != null)
				this._watchList.push(a);
		}
		
		/*----------------------------------ACTIVATOR CHECKING---------------------------------------------*/
		
		/**
		*	Makes the trigger start listening for activators
		*/
		public function begin()
		{
			//trace("starting trigger");
			this.addEventListener(Event.ENTER_FRAME, this.checkAllActivators);
		}
		
		/**
		*	Makes the trigger stop listening for activators
		*/
		public function end()
		{
			//trace("ending trigger");
			this.removeEventListener(Event.ENTER_FRAME, this.checkAllActivators);
			clearActivators();
			while (_objectList.length > 0)
				_objectList.pop();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		*	Checks if any of the activators are in range, if so, the trigger is fired
		*/
		private function checkAllActivators(e:Event)
		{
			/** Added by Dan **/
			if (World.instance.IsPaused) return;
			
			this._checkNum = (++this._checkNum)%this._checkPeriod;
			
			
			if(this._checkNum!=0)	//don't check every frame
				return;
			
			this.bIsTriggered = false;
			
			var distance:Number;
			var xDist;
			var yDist;
			var zDist;
			for each(var a:Asset in this._watchList)
			{
				//trace("Trigger is checking");
				xDist = this._position.x - a.position.x;
				yDist = this._position.y - a.position.y;
				zDist = this._position.z - a.position.z;
				distance = Math.sqrt(Math.pow(xDist, 2) + Math.pow(yDist, 2) + Math.pow(zDist, 2));
				if(distance < this._range)
				{
					this.TriggeredSignal.dispatch(a);
					this.bIsTriggered = true;
				}
			}
			
			for each(var o:AWPCollisionObject in this._objectList)
			{
				//trace("Trigger is checking");
				xDist = this._position.x - o.position.x;
				yDist = this._position.y - o.position.y;
				zDist = this._position.z - o.position.z;
				distance = Math.sqrt(Math.pow(xDist, 2) + Math.pow(yDist, 2) + Math.pow(zDist, 2));
				if(distance < this._range)
				{
					if (this.TriggeredSignal == null) return;
					this.TriggeredSignal.dispatch(null);
					this.bIsTriggered = true;
				}
			}
		}
		
		
		/*-----------------------------------ACTIVATOR MANAGEMENT--------------------------------------------*/
		/**
		*	Adds an activator so it can set off the trigger
		*/
		public function addActivator(a:Asset)
		{
			this._watchList.push(a);
		}
		
		/**
		*	Adds an activator so it can set off the trigger
		*/
		public function addObjectActivator(a:AWPCollisionObject)
		{
			this._objectList.push(a);
		}
		
		/**
		*	Removes an activator so it can't set off the trigger
		*/
		public function removeActivator(a:Asset)
		{
			this._watchList.splice(this._watchList.indexOf(a),1);
		}
		
		/**
		*	Removes an Object activator so it can't set off the trigger
		*/
		public function removeObjectActivator(a:AWPCollisionObject)
		{
			this._watchList.splice(this._objectList.indexOf(a),1);
		}
		
		
		/**
		*	clears all activators so none of them will set off the trigger
		*/
		public function clearActivators()
		{
			while (_watchList.length > 0)
				_watchList.pop();
			this._watchList = new Vector.<Asset>();
		}
		
		
		
		/*-------------------------------------GETTERS/SETTERS----------------------------------------*/

		/**
		* updates the transform of the trigger
		*/
		public function set position(p:Vector3D)
		{
			if(p!=null)
				this._position = p;
		}
		
		/**
		* gets the transform of the trigger
		*/
		public function  get position():Vector3D
		{
			return this._position;
		}
		
		

	}
	
}
