package com.jakobwilson.Cannon
{
	import away3d.core.base.Object3D;
	import com.jakobwilson.Asset;
	import com.jakobwilson.Trigger3D;
	import away3d.containers.View3D;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;
	/**
	*	A class to wrap a cannon. Handles spawning cannon balls and displaying the cannon
	*
	*/
	public class Cannon
	{
		private var _cannon:Asset;
		private var _shot:Asset;
		private var _firingTrigger:Trigger3D;
		private var _view:View3D;
		private var _world:AWPDynamicsWorld;
		/**
		* Creates a cannon and sets up its shot 
		*/
		public function Cannon(can:Asset, shot:Asset) 
		{
			this._cannon = can;
			this._shot = shot;
			this._shot.transformTo(this._cannon.position);
			this._firingTrigger = new Trigger3D(1000, 20);
			this._cannon.model.addChild(ObjectContainer3D(this._firingTrigger));
			this._firingTrigger.TriggeredSignal.add(this.shoot);
			this._firingTrigger.begin();
			
		}
		
		public function shoot(a:Asset)
		{
			if(Math.random() < 0.1)
			{
				var shotModel:Asset = this._shot.clone();
				shotModel.transformTo(this._cannon.position);
				var sht:Shot = new Shot(shotModel, this._view, this._world);
				
				/*var sht:Asset = this._shot.clone();
				sht.transformTo(this._cannon.position);
				sht.addToScene(this._view, this._world);
				sht.rigidBody.applyForce(new Vector3D(0,0,200),new Vector3D());*/
			}
		}
		
		public function addToScene(view:View3D, world:AWPDynamicsWorld = null)
		{
			this._view = view;
			this._world = world;
			this._cannon.addToScene(this._view, this._world);
		}
		
		public function addActivator(a:Asset)
		{
			this._firingTrigger.addActivator(a);
		}

	}
	
}
