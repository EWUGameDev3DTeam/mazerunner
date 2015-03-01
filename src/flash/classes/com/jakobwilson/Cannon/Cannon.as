﻿package com.jakobwilson.Cannon
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
		
		/**
		*	fires a single shot by spawning a new Shot object and adding it to the scene
		*/
		public function shoot(a:Asset)
		{
			if(Math.random() < 0.1)
			{
				var shotModel:Asset = this._shot.clone();
				var positionVector:Vector3D = new Vector3D;
				positionVector.x = this._cannon.position.x +( Math.sin(this._cannon.rotation.y)*100);
				positionVector.y = this._cannon.position.y;
				positionVector.z = this._cannon.position.z +( Math.cos(this._cannon.rotation.y)*100);
				shotModel.transformTo(positionVector);
				var shotForce:Vector3D = new Vector3D(Math.sin(this._cannon.rotation.y), 0, Math.cos(this._cannon.rotation.y));
				shotForce.scaleBy(500);
				var sht:Shot = new Shot(shotModel,shotForce, this._view, this._world);
			}
		}
		
		/**
		*	adds the cannon to the scene
		*/
		public function addToScene(view:View3D, world:AWPDynamicsWorld = null)
		{
			this._view = view;
			this._world = world;
			this._cannon.addToScene(this._view, this._world);
		}
		
		/**
		*	adds an activator to the cannon
		*/
		public function addActivator(a:Asset)
		{
			this._firingTrigger.addActivator(a);
		}
		
		/**
		* Allows the cannon to be moved
		*/
		public function get model():Asset
		{
			return this._cannon;
		}
		
		public function transformTo(v:Vector3D)
		{
			this._cannon.transformTo(v);
		}
		
		public function rotateTo(v:Vector3D)
		{
			this._cannon.rotateTo(v);
		}

	}
	
}
