package team3d.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.core.partition.MeshNode;
	import away3d.entities.Mesh;
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
	public class ThirdPersonCameraController extends BaseController
	{
		private var _fpc	:FirstPersonController;
		private var _rb		:AWPRigidBody;
		private var _cam	:Camera3D;
		
		public function ThirdPersonCameraController($rb:AWPRigidBody, $cam:Camera3D, $fpc:FirstPersonController)
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
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		/**
		 * Moves the object
		 *
		 * @param	$speed	The speed to move the movie clip
		 */
		override public function Move($speed:Number):void
		{
			var zrot:Number = _rb.rotationZ * BaseController.TORADS;
			// move forward
			var speed:Number = 15;
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				
				_rb.linearVelocity = new Vector3D(speed * Math.sin(zrot), -speed * Math.cos(zrot));
				//_rb.x += speed * Math.sin(zrot) // ignores physics
				//_rb.y -= speed * Math.cos(zrot); // ignores physics
				//trace("moving forward");
				//_model.x += $speed * Math.sin(zrot);
				//_model.y -= $speed * Math.cos(zrot);
			}
			
			// move backward
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				//_rb.x -= speed * Math.sin(zrot); // ignores physics
				//_rb.y += speed * Math.cos(zrot); // ignores physics
				//trace("moving backward");
				//_model.x -= $speed * Math.sin(zrot);
				//_model.y += $speed * Math.cos(zrot);
			}
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				//_model.y -= $speed * Math.sin(zrot);
				//_model.x -= $speed * Math.cos(zrot);
			}
			// strafe right
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				//_model.y += $speed * Math.sin(zrot);
				//_model.x += $speed * Math.cos(zrot);
			}
			
			/*
			var cam_distance:Number = 500;
			var _scale:Number   = 3;
			var smooth:Number   = 1;
			var dir:Vector3D   = _rb.front;// new Vector3D(_rb.front.x, _rb.front.y, _rb.front.z, _rb.front.w);
			var pos:Vector3D   = _rb.position;
			var angle:Number   = Math.atan2( dir.y, dir.x);
			//trace("angle: " + angle);
			var delta:Vector3D = new Vector3D(Math.sin(angle) * cam_distance / 2, 0, Math.cos(angle) * cam_distance / 2);
			//trace("delta: " + delta);
			var pos2:Vector3D = pos.add(new Vector3D( -delta.y * _scale, 200, delta.x * _scale));
			
			pos2.x = pos2.x + (_x - pos2.x) * smooth;
			pos2.y = pos2.y + (_y - pos2.y) * smooth;
			pos2.z = pos2.z + (_z - pos2.z) * smooth;
			//trace("pos2: " + pos2);
			_x = pos2.x;
			_y = pos2.y;
			_z = pos2.z;
			
			_cam.position = pos2;
			//trace("cam pos1 " + _cam.position);
			_cam.lookAt(_rb.position, new Vector3D(0,0,1));
			//trace("cam pos2 " + _cam.position);
			*/
			
			_rb.rotationX = 0;
			_rb.rotationY = 0;
			
			_cam.x = _rb.worldTransform.position.x + 300 * Math.cos(zrot + Math.PI * 0.5);
			_cam.y = _rb.worldTransform.position.y + 300 * Math.sin(zrot + Math.PI * 0.5);
			_cam.z = _rb.z + 50;
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
			_rb.rotationZ += $e.movementX * 0.1;
			
			
			
			//_cam.rotationX = _rb.rotationX;
			//_cam.rotationY = _rb.rotationY;
			_cam.rotationZ = _rb.rotationZ;
			//_cam.rotationZ = _rb.rotationZ;
		}
	}
}