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
		private var _model:Asset;
		private var _stateTimer:Timer;
		private var _scale:Number = 0.05;
		private var _alpha = 1.0;
		private var _count:int = 0;
		private var _view:View3D; 
		private var _world:AWPDynamicsWorld;
		
		public function Shot(shot:Asset, view:View3D, world:AWPDynamicsWorld) 
		{
			this._view = view;
			this._world = world;
			this._model = shot;
			this._model.rigidBody.scale = new Vector3D(this._scale, this._scale, this._scale);
			this._model.transformTo(new Vector3D(this._model.position.x, this._model.position.y, this._model.position.z + 100));
			this._view.scene.addChild(this._model.model);
			this._world.addRigidBody(this._model.rigidBody);
			this._count  = 0;
			this._stateTimer = new Timer(10);
			this._stateTimer.addEventListener(TimerEvent.TIMER, this.grow);
			this._stateTimer.start();
		}
		
		private function grow(e:Event)
		{
			trace("Growing");
			this._scale += 0.05;
			this._model.rigidBody.scale = new Vector3D(this._scale, this._scale, this._scale);
			if(this._scale > 0.99)
			{
				this._stateTimer.removeEventListener(TimerEvent.TIMER, this.grow);
				this._stateTimer.addEventListener(TimerEvent.TIMER, this.shoot);
			}
		}
		

		private function shoot(e:Event)
		{
			trace("Shooting");
			this._model.rigidBody.scale = new Vector3D(1,1,1);
			this._scale = 1.0;
			//this._model.rigidBody.applyForce(new Vector3D(0,0,200), new Vector3D());
			this._stateTimer.removeEventListener(TimerEvent.TIMER, this.shoot);
			this._stateTimer.delay = 2000;
			this._stateTimer.addEventListener(TimerEvent.TIMER, this.fade);
			
		}
		
		private function fade(e:Event)
		{
			//trace("Shrinking: " + this._scale);
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
			this._view.scene.removeChild(this._model.model);
			this._world.removeRigidBody(this._model.rigidBody);
			this._model = null;
			this._stateTimer.stop();
			this._stateTimer = null;
		}
		
		
	}
	
}
