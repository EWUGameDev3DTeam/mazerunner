package  com.jakobwilson.Cannon
{
	import com.jakobwilson.Asset;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;	
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import away3d.materials.TextureMaterial;
	import flash.geom.Vector3D;
	import flash.display.DisplayObject;
	
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
			this._model.rigidBody.gravity = new Vector3D(0,0.0001,0)
			this._model.rigidBody.mass = 10000;
			this._model.transformTo(new Vector3D(this._model.position.x, this._model.position.y, this._model.position.z));
			this._view.scene.addChild(this._model.model);
			this._stateTimer = new Timer(10);
			this._stateTimer.addEventListener(TimerEvent.TIMER, this.grow);
			this._stateTimer.start();
		}
		
		private function grow(e:Event)
		{
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
			this._model.rigidBody.scale = new Vector3D(1,1,1);
			this._scale = 1.0;
			this._firePower.scaleBy(this._model.rigidBody.mass)
			this._model.rigidBody.applyForce(this._firePower, new Vector3D());
			this._stateTimer.removeEventListener(TimerEvent.TIMER, this.shoot);
			this._stateTimer.delay = 2000;
			this._stateTimer.addEventListener(TimerEvent.TIMER, this.fade);
			
		}
		
		private function fade(e:Event)
		{
			this._stateTimer.delay = 100;
			this._scale -= 0.2;
			this._model.rigidBody.scale = new Vector3D(this._scale, this._scale, this._scale);
			
			if(this._scale <= 0.05)
			{
				this._stateTimer.removeEventListener(TimerEvent.TIMER, this.fade);
				this.remove();
			}

		}
		
		private function remove()
		{
			if(this._view.scene.numChildren > 0)
				this._view.scene.removeChild(this._model.model);
			this._world.removeRigidBody(this._model.rigidBody);
			this._model = null;
			this._stateTimer.stop();
			this._stateTimer = null;
		}
		

		
		
	}
	
}
