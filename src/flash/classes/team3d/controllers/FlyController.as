package team3d.controllers
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.controllers.ControllerBase;
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
	public class FlyController extends BaseController
	{
		public function FlyController()
		{
			var lb:LensBase = new PerspectiveLens(75);
			lb.far = 20000;
			var fpc:FirstPersonController = new FirstPersonController(new Camera3D(lb), 0, 90, -90, 90, 0)
			_baseController = fpc;
			fpc.fly = true;
			fpc.targetObject.z = 3000;
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
			var cam = Camera3D(_baseController.targetObject);
			if (KeyboardManager.instance.isKeyDown(KeyCode.SHIFT))
				$speed *= 0.5;
			
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
				cam.moveForward($speed);
			// move backward
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
				cam.moveBackward($speed);
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
				cam.moveLeft($speed);
			// strafe right
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
				cam.moveRight($speed);
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
			var fpc:FirstPersonController = FirstPersonController(_baseController);
			// move the camera up or down
			fpc.tiltAngle += $e.movementY * 0.07;
			// move the camera left or right
			fpc.panAngle += $e.movementX * 0.1;
		}
	}
}