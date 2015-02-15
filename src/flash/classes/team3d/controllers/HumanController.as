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
		public function Begin():void
		{
			World.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function End():void
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
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				//trace("moving forward");
				_model.x += $speed * Math.sin((_model.rotationZ * Math.PI) / 180);
				_model.y -= $speed * Math.cos((_model.rotationZ * Math.PI) / 180);
			}
			
			// move backward
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				//trace("moving backward");
				_model.x -= $speed * Math.sin((_model.rotationZ * Math.PI) / 180);
				_model.y += $speed * Math.cos((_model.rotationZ * Math.PI) / 180);
			}
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				_model.y -= $speed * Math.sin((_model.rotationZ * Math.PI) / 180);
				_model.x -= $speed * Math.cos((_model.rotationZ * Math.PI) / 180);
			}
			// strafe right
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				_model.y += $speed * Math.sin((_model.rotationZ * Math.PI) / 180);
				_model.x += $speed * Math.cos((_model.rotationZ * Math.PI) / 180);
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