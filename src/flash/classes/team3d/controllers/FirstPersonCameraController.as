package team3d.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
	import away3d.controllers.FirstPersonController;
	import away3d.core.partition.MeshNode;
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
		
		public function FirstPersonCameraController($rb:AWPRigidBody, $cam:Camera3D, $fpc:FirstPersonController)
		{
			_rb = $rb;
			_cam = $cam;
			_fpc = $fpc;
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
			var zrot:Number = _rb.rotationZ * BaseController.TORADS;
			// move forward
			var speed:Number = 6;
			
			if (KeyboardManager.instance.isKeyDown(KeyCode.SHIFT))
				speed = speed * .5;
			
			var upVector:Vector3D = new Vector3D(speed * Math.sin(zrot), -speed * Math.cos(zrot));
			var downVector:Vector3D = new Vector3D( -speed * Math.sin(zrot), speed * Math.cos(zrot));
			var leftVector:Vector3D = new Vector3D( -speed * Math.cos(zrot), -speed * Math.sin(zrot));
			var rightVector:Vector3D = new Vector3D(speed * Math.cos(zrot), speed * Math.sin(zrot));
			
			
			
			if (this._rb.z > 50.6)
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
			
			_cam.x = _rb.x;// - 300 * Math.cos(zrot);
			_cam.y = _rb.y;// - 300 * Math.sin(zrot);
			_cam.z = _rb.z + 100;// + 20;
			
			_rb.rotationY = _cam.rotationY;
			_rb.rotationZ = _cam.rotationZ;
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
			// move the camera up or down
			_fpc.tiltAngle += $e.movementY * 0.07;
			// move the camera left or right
			//if($e.movementX != 0)
			//_cam.rotationZ += $e.movementX * 0.1;
			_cam.rotationZ += $e.movementX * 0.1;
			
			_rb.rotationX = 0;// _cam.rotationX;
			_rb.rotationY = _cam.rotationY;
			_rb.rotationZ = _cam.rotationZ;
			//_cam.rotationZ = _rb.rotationZ;
		}
		
		public function get Camera():Camera3D
		{
			return _cam;
		}
	}
}