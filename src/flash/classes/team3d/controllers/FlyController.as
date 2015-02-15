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
	import team3d.utils.World;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class FlyController extends BaseController
	{
		private var _fpc	:FirstPersonController;
		private var _cam	:Camera3D;
		
		public function FlyController($cam:Camera3D, $fpc:FirstPersonController)
		{
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
			var zrots:Number = _cam.rotationZ * BaseController.TORADS;
			var yrots:Number = _cam.rotationY * BaseController.TORADS;
			var xrots:Number = _cam.rotationX * BaseController.TORADS;
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				//trace("moving forward");
				_cam.x += $speed * Math.sin(zrots);
				_cam.y -= $speed * Math.cos(zrots);
				_cam.z += $speed * Math.cos(_fpc.tiltAngle * BaseController.TORADS);
			}
			
			// move backward
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				//trace("moving backward");
				_cam.x -= $speed * Math.sin(zrots);
				_cam.y += $speed * Math.cos(zrots);
				_cam.z -= $speed * Math.cos(_fpc.tiltAngle * BaseController.TORADS);
			}
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				_cam.y -= $speed * Math.sin(zrots);
				_cam.x -= $speed * Math.cos(zrots);
			}
			// strafe right
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				_cam.y += $speed * Math.sin(zrots);
				_cam.x += $speed * Math.cos(zrots);
			}
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
			_cam.rotationZ += $e.movementX * 0.1;
		}
	}
}