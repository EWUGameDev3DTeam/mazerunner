package team3d.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.core.partition.MeshNode;
	import away3d.entities.Mesh;
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
	public class HumanController extends BaseController
	{
		private var _fpc	:FirstPersonController;
		private var _model	:Mesh;
		private var _cam	:Camera3D;
		
		public function HumanController($model:Mesh, $cam:Camera3D, $fpc:FirstPersonController)
		{
			_model = $model;
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
		
		/**
		 * Moves the object
		 *
		 * @param	$speed	The speed to move the movie clip
		 */
		override public function Move($speed:Number):void
		{
			var zrot:Number = _model.rotationZ * BaseController.TORADS;
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				//trace("moving forward");
				_model.x += $speed * Math.sin(zrot);
				_model.y -= $speed * Math.cos(zrot);
			}
			
			// move backward
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				//trace("moving backward");
				_model.x -= $speed * Math.sin(zrot);
				_model.y += $speed * Math.cos(zrot);
			}
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				_model.y -= $speed * Math.sin(zrot);
				_model.x -= $speed * Math.cos(zrot);
			}
			// strafe right
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				_model.y += $speed * Math.sin(zrot);
				_model.x += $speed * Math.cos(zrot);
			}
			
			_cam.x = _model.x;
			_cam.y = _model.y;
			_cam.z = _model.z;
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
			_model.rotationZ += $e.movementX * 0.1;
			_cam.rotationZ = _model.rotationZ;
		}
	}
}