package team3d.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.FirstPersonController;
	import away3d.core.partition.MeshNode;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import team3d.screens.DebugScreen;
	import away3d.entities.Mesh;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.dynamics.AWPRigidBody;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import org.flintparticles.threeD.renderers.controllers.FirstPersonCamera;
	import team3d.bases.BaseController;
	import team3d.objects.World;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class FirstPersonCameraController extends BaseController
	{
		private var _fpc	:FirstPersonController;
		private var _rb		:AWPRigidBody;
		private var _cam	:Camera3D;
		
		public function FirstPersonCameraController($rb:AWPRigidBody, $fpc:FirstPersonController)
		{
			_rb = $rb;
			_fpc = $fpc;
			_cam = Camera3D(_fpc.targetObject);
			
			//var c:AWPKinematicCharacterController = new AWPKinematicCharacterController(new AWPGhostObject(_rb, _rb.skin), 5);
			//c.updateTransform
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		override public function Begin():void
		{
			this._rb.forceActivationState(AWPCollisionObject.DISABLE_DEACTIVATION);
			
			World.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		override public function End():void
		{
			World.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the object
		 *
		 * @param	$speed	The speed to move the movie clip
		 */
		override public function Move($speed:Number):void
		{
			var yrot:Number = _rb.rotationY * BaseController.TORADS;
			// move forward
			var speed:Number = 6;
			
			if (KeyboardManager.instance.isKeyDown(KeyCode.SHIFT))
				speed = speed * .5;
			
			/*
			var upVector:Vector3D = new Vector3D(speed * Math.sin(yrot), 0, -speed * Math.cos(yrot));
			var downVector:Vector3D = new Vector3D(-speed * Math.sin(yrot), 0, speed * Math.cos(yrot));
			var leftVector:Vector3D = new Vector3D(-speed * Math.cos(yrot), 0, -speed * Math.sin(yrot));
			var rightVector:Vector3D = new Vector3D(speed * Math.cos(yrot), 0, speed * Math.sin(yrot));
			
			
			if (this._rb.y > 50.6)
			{
				//prevents air walking
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.W) && KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				this._rb.linearVelocity = new Vector3D((speed * .707) * Math.sin(zrot), (-speed * .707) * Math.cos(zrot)).add(new Vector3D((-speed * .707) * Math.cos(zrot),  (-speed * .707) * Math.sin(zrot)));
				
				this._rb.linearDamping = .1;//prevents lockup
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.W) && KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				this._rb.linearVelocity = new Vector3D((speed * .707) * Math.sin(zrot), (-speed * .707) * Math.cos(zrot)).add(new Vector3D((speed * .707) * Math.cos(zrot),  (speed * .707) * Math.sin(zrot)));
				
				this._rb.linearDamping = .1;//prevents lockup
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.S) && KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				this._rb.linearVelocity = new Vector3D((-speed * .707) * Math.sin(zrot), (speed * .707) * Math.cos(zrot)).add(new Vector3D((-speed * .707) * Math.cos(zrot),  (-speed * .707) * Math.sin(zrot)));
				
				this._rb.linearDamping = .1;//prevents lockup
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.S) && KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				this._rb.linearVelocity = new Vector3D((-speed * .707) * Math.sin(zrot), (speed * .707) * Math.cos(zrot)).add(new Vector3D((speed * .707) * Math.cos(zrot),  (speed * .707) * Math.sin(zrot)));
				
				this._rb.linearDamping = .1;//prevents lockup
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.W)) // move forward
			{
				this._rb.linearVelocity = upVector;
				
				this._rb.linearDamping = .1;//prevents lockup
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.S)) // move backward
			{
				this._rb.linearVelocity = downVector;

				this._rb.linearDamping = .1;//prevents lockup
			}
			else if (KeyboardManager.instance.isKeyDown(KeyCode.A)) // strafe left
			{
				this._rb.linearVelocity = leftVector;
				
				this._rb.linearDamping = .1;//prevents lockup
			}
			// strafe right
			else if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				this._rb.linearVelocity = rightVector;

				this._rb.linearDamping = .1;//prevents lockup
			}
			else if(this._rb.z > 50.4 && this._rb.z < 50.6)
			{
				this._rb.linearDamping = 1;
			}
			
			if (KeyboardManager.instance.isKeyDown(KeyCode.SPACEBAR) && this._rb.z > 50.4 && this._rb.z < 50.6)
			{
				this._rb.linearVelocity = this._rb.linearVelocity.add(new Vector3D(0, 0, 6));
			}
			//*/
			
			_fpc.targetObject.x = _rb.x;
			_fpc.targetObject.y = _rb.y + 100;
			_fpc.targetObject.z = _rb.z;
			
			_rb.rotationX = _fpc.targetObject.rotationX;
			_rb.rotationY = _fpc.targetObject.rotationY;
			_rb.rotationZ = 0;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * 
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		protected function mouseMove($e:MouseEvent):void
		{
			//DebugScreen.Text("Mouse y: " + $e.movementY);
			//DebugScreen.Text("\nmouse x: " + $e.movementX, true);
			// move the camera up or down
			_fpc.tiltAngle += $e.movementY * 0.07;
			// move the camera left or right
			_fpc.panAngle += $e.movementX * 0.1;
		}
		
		public function get Camera():Camera3D
		{
			return _cam;
		}
	}
}