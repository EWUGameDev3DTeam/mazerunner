﻿package  com.jakobwilson.Cannon
{
	import away3d.audio.drivers.SimplePanVolumeDriver;
	import team3d.sound.Sound3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import awayphysics.data.AWPCollisionFlags;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.events.AWPEvent;
	import com.jakobwilson.Asset;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import team3d.events.MovementOverrideEvent;
	import team3d.objects.players.KinematicPlayer;
	import team3d.objects.World;
	import team3d.screens.DebugScreen;
	import treefortress.sound.SoundAS;
	import team3d.objects.World;
	
	/**
	* A single cannon shot has three states: Growing(for inside the cannon), shooting, and fading. 
	*/
	public class Shot 
	{
		private var _model:Asset;			/**< the asset we will be shooting*/
		private var _stateTimer:Timer;		/**< a timer to control the state*/
		private var _scale:Number = 0.05;	/**< the scale of the shot*/
		private var _firePower:Vector3D;	/**< the force applied to the shot when it's fired*/
		private var _view:View3D; 			/**< The view*/
		private var _world:AWPDynamicsWorld;/**< The physics world*/
		private var _firingSound:Sound3D;
		
		private var _canKnockBack:Boolean = true;
		
		/**
		*	Spawns a new shot
		*/
		public function Shot(shot:Asset, v:Vector3D, view:View3D, world:AWPDynamicsWorld) 
		{
			this._view = view;
			this._world = world;
			this._model = shot;
			this._firePower = v;
			this._model.rigidBody.scale = new Vector3D(this._scale, this._scale, this._scale);
			this._model.transformTo(new Vector3D(this._model.position.x, this._model.position.y, this._model.position.z));
			this._view.scene.addChild(this._model.model);
			this._stateTimer = new Timer(10);
			
			//Knockback event handling
			//this._model.rigidBody.collisionFlags |= AWPCollisionFlags.CF_CUSTOM_MATERIAL_CALLBACK; 
			this._model.rigidBody.addEventListener(AWPEvent.COLLISION_ADDED,this.knockBack);
			//sound3d setup
			this._firingSound = new Sound3D(SoundAS.getSound("CannonFiring").sound, World.instance.view.camera, null, 1.0, 2000);
			this._model.model.addChild(this._firingSound);
			
			this._stateTimer.addEventListener(TimerEvent.TIMER, this.grow);
			this._stateTimer.start();
			
			//this._firingSound = new Sound3D(SoundAS.getSound("CannonFiring").sound, this._view.camera, new SimplePanVolumeDriver());
		}
		
		private function grow(e:Event)
		{
			/** Added by Dan **/
			if (World.instance.IsPaused) return;
			
			this._scale += 0.05;
			this._model.rigidBody.scale = new Vector3D(this._scale, this._scale, this._scale);
			
			if(this._scale > 0.99)
			{
				this._stateTimer.removeEventListener(TimerEvent.TIMER, this.grow);
				this._stateTimer.addEventListener(TimerEvent.TIMER, this.shoot);
				this._world.addRigidBody(this._model.rigidBody);
			}
		}
		

		private function shoot(e:Event)
		{
			/** Added by Dan **/
			if (World.instance.IsPaused) return;
			
			this._model.rigidBody.scale = new Vector3D(1,1,1);
			this._scale = 1.0;
			this._firePower.scaleBy(this._model.rigidBody.mass)
			this._model.rigidBody.applyForce(this._firePower, new Vector3D());
			this._stateTimer.removeEventListener(TimerEvent.TIMER, this.shoot);
			this._stateTimer.delay = 2000;
			this._stateTimer.addEventListener(TimerEvent.TIMER, this.fade);
			
			//SoundAS.playFx("CannonFiring", .15);
			this._firingSound.play();
		}
		
		private function fade(e:Event)
		{
			/** Added by Dan **/
			if (World.instance.IsPaused) return;
			
			this._stateTimer.delay = 100;
			this._scale -= 0.2;
			this._model.rigidBody.scale = new Vector3D(this._scale, this._scale, this._scale);
			
			//this._model.model.removeChild(this._firingSound);
			
			if(this._scale <= 0.05)
			{
				this._stateTimer.removeEventListener(TimerEvent.TIMER, this.fade);
				this.remove();
			}

		}
		
		private function remove()
		{
			if(this._view.scene.contains(this._model.model))
				this._view.scene.removeChild(this._model.model);
			
			this._model.rigidBody.removeEventListener(AWPEvent.COLLISION_ADDED,this.knockBack);
			if(this._world.rigidBodies.indexOf(this._model.rigidBody) > -1 || this._world.nonStaticRigidBodies.indexOf(this._model.rigidBody) > -1)
				this._world.removeRigidBody(this._model.rigidBody);
			this._model = null;
			this._stateTimer.stop();
			this._stateTimer = null;
		}
		

		
		
		/**
		*	In Progress: Checks collision and if it was a cannonball, it uses the cannonball's position to create a vector to knock the player back
		*/
		private function knockBack($e: AWPEvent):void
		{
			this._canKnockBack = true;
			if($e.type == AWPEvent.COLLISION_ADDED && ($e.collisionObject.collisionFlags & AWPCollisionFlags.CF_CHARACTER_OBJECT) > 0)
			{				
				//var Target:Vector3D = $e.collisionObject.position.add(new Vector3D(this._model.rigidBody.linearVelocity.x, 0, this._model.rigidBody.linearVelocity.z));
				//var Target:Vector3D = new Vector3D(this._model.rigidBody.linearVelocity.x, 0, this._model.rigidBody.linearVelocity.z);
				var Target:Vector3D = $e.collisionObject.position.subtract(this._model.position);
				Target.normalize();
				Target.scaleBy(this._model.rigidBody.linearVelocity.length);
				Target.y = 0;
				Target.scaleBy(0.1);
				$e.collisionObject.dispatchEvent(new MovementOverrideEvent(Target));
			}
		}
	}
	
}
