package team3d.objects.players
{
	import away3d.cameras.Camera3D;
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
	import awayphysics.collision.dispatch.AWPGhostObject;
	import flash.media.Camera;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import team3d.bases.BasePlayer;
	import awayphysics.data.AWPCollisionFlags;
	import flash.events.Event;
	import awayphysics.events.AWPEvent;

	/**
	 * A player that uses the AWPKinematicCharacterController
	 * @author	Jakob Wilson
	 */
	public class KinematicPlayer extends BasePlayer
	{
		private var _ghostObject:AWPGhostObject;
		private var _character:AWPKinematicCharacterController;
		private var _fpc	:FirstPersonController;
		private var _cam 	:Camera3D;
		private var _speed:Number = 1;
		private var _pan:Number = 0.0;
		private var _tilt:Number = 90.0;
		
		/**
		*	Creates a kinematic character controller 
		*/
		public function KinematicPlayer($cam:Camera3D, $height:int, $radius:int, $speed:Number)
		{
			_cam = $cam;
			_fpc = new FirstPersonController($cam);
			_fpc.targetObject.z = height * 0.8;
			_fpc.fly = true;
			this._speed = $speed;
			
			
			var shape:AWPCapsuleShape = new AWPCapsuleShape($radius, $height);
			
			this._ghostObject = new AWPGhostObject(shape, Camera3D(_fpc.targetObject));
			this._ghostObject.collisionFlags = AWPCollisionFlags.CF_CHARACTER_OBJECT;
			_character = new AWPKinematicCharacterController(_ghostObject, 1);
			_character.setWalkDirection(new Vector3D(0,0,0));
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Inits listeners for controls
		 */
		override public function Begin():void
		{
			World.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.addEventListener(Event.ENTER_FRAME,this.onFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * clears listeners for controls
		 */
		override public function End():void
		{
			World.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.removeEventListener(Event.ENTER_FRAME,this.onFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function onFrame(e:Event)
		{
			this.Move(this._speed);
		}
		
		/**
		 * Moves the object based on keyboard input
		 *
		 * @param	Number $speed	The speed to move the movie clip
		 */
		public function Move($speed:Number):void
		{
			//$speed = 1;
			var vf:Vector3D = new Vector3D();
			var vs:Vector3D = new Vector3D();
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				vf = _character.ghostObject.front;
				vf.scaleBy($speed);
			}
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				vf = _character.ghostObject.front;
				vf.scaleBy(-$speed);
			}
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				vs = _character.ghostObject.right;
				vs.scaleBy(-$speed*0.5);
				vf.scaleBy(0.7);
			}
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				vs = _character.ghostObject.right;
				vs.scaleBy($speed*0.5);
				vf.scaleBy(0.7);
			}
			if(KeyboardManager.instance.isKeyDown(KeyCode.SPACEBAR))
				_character.jump();
			if(KeyboardManager.instance.isKeyDown(KeyCode.SHIFT))
			{
				vs.scaleBy(0.5);
				vf.scaleBy(0.5);
			}
			vs.y = 0;
			vf.y = 0;

			_character.setWalkDirection(vf.add(vs));
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Updates mouse movement
		 * @param	$e - MouseEvent
		 */
		protected function mouseMove($e:MouseEvent):void
		{
			this._pan += $e.movementX * 0.1;
			this._tilt += $e.movementY * 0.07;


			if(this._tilt > 45)
				this._tilt = 45;	
			if(this._tilt < -45)
				this._tilt = -45;
			
			_character.ghostObject.rotation = new Vector3D(this._tilt,this._pan,0);
			
		}
		
		/**
		*	Gets the camera
		*/
		public function get Camera():Camera3D
		{
			return Camera3D(_fpc.targetObject);
		}
		
		/**
		*	Adds the player to the world
		*/
		public function addToWorld($view:View3D, $physics:AWPDynamicsWorld)
		{
			$physics.addCharacter(this._character);
		}
		
		/**
		*	gets the kinematic controller
		*/
		public function get controller():AWPKinematicCharacterController
		{
			return this._character;
		}
	}
}