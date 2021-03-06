﻿package com.jakobwilson.Cannon
{
	import away3d.audio.drivers.ISound3DDriver;
	import away3d.audio.Sound3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import com.jakobwilson.Asset;
	import com.jakobwilson.Trigger3D;
	import flash.geom.Vector3D;
	import team3d.objects.World;
	import team3d.screens.DebugScreen;
	import treefortress.sound.SoundAS;

	/**
	*	A class to wrap a cannon. Handles spawning cannon balls and displaying the cannon
	*
	*/
	public class Cannon
	{
		private static const MAXFIRE = 10;
		
		private var _cannon:Asset;
		private var _shot:Asset;
		private var _firingTrigger:Trigger3D;
		private var _view:View3D;
		private var _world:AWPDynamicsWorld;
		private const degreesToRad:Number = 0.0174532925;
		private var _nFire:Number;
		private var _nMaxFire:Number;
		private var _firingTriggerContainer:ObjectContainer3D;
		
		/**
		* Creates a cannon and sets up its shot 
		*/
		public function Cannon(can:Asset, shot:Asset, activationRange:int = 2000) 
		{
			this._cannon = can;
			this._shot = shot;
			this._shot.transformTo(this._cannon.position);
			this._firingTrigger = new Trigger3D(activationRange, 60);
			this._firingTrigger.position = new Vector3D(0, 0, 0);
			this._firingTriggerContainer = ObjectContainer3D(this._firingTrigger);
			this._cannon.model.addChild(this._firingTriggerContainer);
			
			this._nMaxFire = int(Math.random() * MAXFIRE);
			_nFire = 0;
			this._firingTrigger.TriggeredSignal.add(this.shoot);
			this._firingTrigger.begin();
			//trace("cannon starting");
		}
		
		/**
		*	fires a single shot by spawning a new Shot object and adding it to the scene
		*/
		public function shoot(a:Asset)
		{
			/** Added by Dan **/
			if (World.instance.IsPaused) return;
			
			if(this._nFire >= _nMaxFire)
			{
				var positionVector:Vector3D = new Vector3D();
				positionVector.x = this._cannon.position.x +( Math.sin(this._cannon.rotation.y*this.degreesToRad)*100);
				positionVector.y = this._cannon.position.y;
				positionVector.z = this._cannon.position.z +( Math.cos(this._cannon.rotation.y*this.degreesToRad)*100);
				
				var shotModel:Asset = this._shot.clone();
				shotModel.transformTo(positionVector);
				
				var shotForce:Vector3D = new Vector3D(Math.sin(this._cannon.rotation.y*this.degreesToRad), 0, Math.cos(this._cannon.rotation.y*this.degreesToRad));
				shotForce.scaleBy(500);
				
				var sht:Shot = new Shot(shotModel,shotForce, this._view, this._world);
				
				this._nFire = 0;
			}
			else
				this._nFire++;
		}
		
		/**
		*	Cleans up the cannon
		*/
		public function End()
		{
			//trace("cannon ending");
			this._firingTrigger.end();
		}
		
		/**
		*	adds the cannon to the scene
		*/
		//*
		public function addToScene(view:View3D, world:AWPDynamicsWorld = null)
		{
			this._view = view;
			this._world = world;
			this._cannon.addToScene(this._view, this._world);
		}//*/
		
		/**
		*	adds an activator to the cannon
		*/
		public function addActivator(a:Asset)
		{
			this._firingTrigger.addActivator(a);
		}
		
		/**
		*	adds a ghostobject activator
		*/
		public function addObjectActivator(a:AWPGhostObject)
		{
			this._firingTrigger.addObjectActivator(a);
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
			this._firingTrigger.position = v;
		}
		
		public function rotateTo(v:Vector3D)
		{
			this._cannon.rotateTo(v);
		}
		


	}
	
}
