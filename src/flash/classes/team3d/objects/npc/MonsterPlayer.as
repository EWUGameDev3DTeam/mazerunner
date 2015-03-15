package  team3d.objects.npc
{
	
	import away3d.audio.Sound3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	import awayphysics.data.AWPCollisionFlags;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import com.jakobwilson.Asset;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.bases.BasePlayer;
	import team3d.events.MovementOverrideEvent;
	import team3d.sound.Sound3D;
	import team3d.utils.pathfinding.NavGraph;
	import team3d.utils.pathfinding.PathNode;
	import treefortress.sound.SoundAS;
	import flash.media.Sound;
	import team3d.sound.Sound3D;
	import away3d.audio.drivers.SimplePanVolumeDriver;

	/**
	 * A player that uses the AWPKinematicCharacterController
	 * @author	Jakob Wilson
	 */
	public class MonsterPlayer extends BasePlayer
	{
		private const IDLE = 0;
		private const SEARCHING = 1;
		private const CHASING = 2;
		private const ATTACKING = 3;
		
		private var _ghostObject	:AWPGhostObject;
		private var _character		:AWPKinematicCharacterController;
		private var _speed			:Number = 1;
		private var _overrideVector	:Vector3D = new Vector3D();
		
		private var _navGraph		:NavGraph;
		private var _currentPath	:Vector.<PathNode>;
		private var _counter		:int;
		private var _target			:ObjectContainer3D;
		private var _state			:int = IDLE;
		private var _currentTarget	:Vector3D;
		public var targetTouchedSignal:Signal = new Signal();
		
		private var _bSoundPlaying	:Boolean;
		private var _bIsEnabled		:Boolean;
		public var done				:Boolean;
		private var _mainSound:Sound3D;

		/**
		*	Creates a kinematic character controller 
		*/
		public function MonsterPlayer($model:Asset, $height:int, $radius:int, $speed:Number)
		{
			//_fpc = new FirstPersonController($cam);
			//_fpc.targetObject.z = height * 0.8;
			this._speed = $speed;
			
			
			var shape:AWPCapsuleShape = new AWPCapsuleShape($radius, $height);
			
			this._ghostObject = new AWPGhostObject(shape, $model.model);
			this._ghostObject.collisionFlags = AWPCollisionFlags.CF_CHARACTER_OBJECT;
			_character = new AWPKinematicCharacterController(_ghostObject, 20);
			_character.jumpSpeed = 12;
			_character.fallSpeed = _character.jumpSpeed * 0.8;
			_character.setWalkDirection(new Vector3D(0, 0, 0));
			
			this._bIsEnabled = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Inits listeners for controls
		 */
		override public function Begin():void
		{
			this.addEventListener(Event.ENTER_FRAME,this.onFrame);
			//this._character.ghostObject.addEventListener("MovementOverride", this.overrideMovement);
			
			this._bSoundPlaying = false;
			this._bIsEnabled = true;
			this.done = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * clears listeners for controls
		 */
		override public function End():void
		{
			this.removeEventListener(Event.ENTER_FRAME,this.onFrame);
			if(this._mainSound != null)
				this._mainSound.removeEventListener("soundComplete", this.playSound);
			//this._character.ghostObject.removeEventListener("MovementOverride", this.overrideMovement);
			
			this._bIsEnabled = false;
			this.done = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function onFrame(e:Event)
		{
			if (this._bIsEnabled)
			{
				this._counter = this._counter % 30;
				if(this._counter == 0)
					this._state = this.checkState();
				this.Move(this._speed);
				
				if(this._target != null && this._character.ghostObject.position.subtract(this._target.position).length < 250)
				{
					this.targetTouchedSignal.dispatch();
				}
// ------------------------------------- broke during merge
				/*if ( distanceMP < 5000 && !done)
				{
					SoundAS.getSound("MonsterSounds").volume = (5000 - distanceMP) * .0002;
					
					if (SoundAS.getSound("MonsterSounds").isPaused)
						SoundAS.resume("MonsterSounds");
					else if (!SoundAS.getSound("MonsterSounds").isPlaying)
						SoundAS.playLoop("MonsterSounds");
						
					this._bSoundPlaying = true;
				}
				else
				{
					SoundAS.pause("MonsterSounds");
					this._bSoundPlaying = false;
				}*/
// -------------------------------------
			
			}
			//if (!SoundAS.getSound("MonsterSounds").isPlaying)
			//	SoundAS.playFx("MonsterSounds", .75);
		}
		
		/**
		 * Moves the object based on keyboard input
		 *
		 * @param	Number $speed	The speed to move the movie clip
		 */
		public function Move($speed:Number):void
		{
			/** KNOCKBACK CODE
			if(this._overrideVector.length > 0.1)
				this._overrideVector.scaleBy(0.95);		//dampen
			else
				this._overrideVector = new Vector3D();
			*/
			var vf:Vector3D = new Vector3D();	
			
			if(this._state == IDLE)
				vf = new Vector3D();
			else if(this._state == SEARCHING)
			{
				if(this._currentTarget == null)
					this._currentTarget = this._currentPath.pop().position;
					
				if(this._currentTarget.subtract(this._character.ghostObject.position).length < 100)
				{
					this._currentTarget = this._currentPath.pop().position;
				}
					
				vf = this._currentTarget.subtract(this._character.ghostObject.position);
				vf.normalize();
				if(vf.z > 0)
					this._character.ghostObject.rotation = new Vector3D(0,Math.atan(vf.x/vf.z)*57.2957795,0);
				else if(vf.z < 0)
					this._character.ghostObject.rotation = new Vector3D(0,Math.atan(vf.x/vf.z)*57.2957795 + 180,0);
				vf.scaleBy($speed);
				//if(this._currentPath != null && this._currentPath.length > 0)
					//trace("Current target: " + this._currentTarget);
			}
			else if(this._state == CHASING)
			{
				this._currentTarget = this._target.position;
				vf = this._currentTarget.subtract(this._character.ghostObject.position);
				vf.normalize();
				if(vf.z > 0)
					this._character.ghostObject.rotation = new Vector3D(0,Math.atan(vf.x/vf.z)*57.2957795,0);
				else if(vf.z < 0)
					this._character.ghostObject.rotation = new Vector3D(0,Math.atan(vf.x/vf.z)*57.2957795 + 180,0);
				vf.scaleBy($speed);
			}
			
			
			vf.y = 0;//we don't want y movement
			_character.setWalkDirection(vf.add(this._overrideVector));
		}
		
		/* ---------------------------------AI CONTROL-------------------------------------- */
		
		/**
		*	assigns the navgraph to the current navGraph
		*/
		public function set NavGraph(n:NavGraph)
		{
			this._navGraph = n;
		}
		/**
		*	Revaluates the monster's status and updates paths accordingly
		*/
		public function checkState()
		{
			//check if the target is null or if there is no path to follow
			//trace("current target " + this._currentTarget);
			if(this._target == null || this._navGraph == null)
			{
				//trace("Idle state - no target");
				return IDLE;
			}
			//get the path
			this._currentPath = this._navGraph.getPath(
								this._navGraph.getNearestWayPoint(this._character.ghostObject.position), 
								this._navGraph.getNearestWayPoint(this._target.position));
							
			if(this._currentPath == null)
			{
				//trace("Idle state - no path");
				return IDLE;
			}
			
			if(this._currentPath.length == 1)
			{
				//trace("Chasing state");
				return CHASING;
			}
			if(this._currentPath != null)
			{
				this._currentTarget = this._currentPath.pop().position;
				this._currentTarget = this._currentPath.pop().position;
				
				//trace("Searching state");
				return SEARCHING;
			}
			
			
		}
		
		public function setTarget($target:ObjectContainer3D)
		{
			this._target = $target;
// ------------------------------------- broke with merge
			//this._mainSound = new Sound3D(SoundAS.getSound("MonsterSounds").sound, this._target, null, 2.0, 2000);
			//this._character.ghostObject.skin.addChild(this._mainSound);
			
			//this._mainSound.addEventListener("soundComplete", this.playSound);
			//this._mainSound.play();
// -------------------------------------
		}
		
		
		private function playSound(e:Event)
		{
// ------------------------------------- broke with merge
			//this._mainSound.stop();
			//this._mainSound.play();
// -------------------------------------
		}
		
		
		/**--------------------------------GETTERS/SETTERS----------------------------------*/
		/**
		*	Adds the player to the world
		*/
		public function addToWorld($view:View3D, $physics:AWPDynamicsWorld)
		{
			$view.scene.addChild(this._character.ghostObject.skin);
			$physics.addCharacter(this._character);
		}
		
		/**
		*	gets the kinematic controller
		*/
		public function get controller():AWPKinematicCharacterController
		{
			return this._character;
		}
		
		/**
		*	Overrides the players movement by applying a vector 
		*/
		public function overrideMovement($e:MovementOverrideEvent)
		{
			
			this._overrideVector = $e.force;
		}
		
		/**
		*		Test method for showing path
		*/
		public function getPathMesh():ObjectContainer3D
		{
			if(this._currentPath == null)
				return null;
			
			var path:Vector.<PathNode> = new Vector.<PathNode>;
			
			
			
			for each(var p:PathNode in this._currentPath)
				path.push(p);
				
			path.push(new PathNode(this._currentTarget));
			path.push(new PathNode(this._character.ghostObject.position));
			var ret:ObjectContainer3D =  NavGraph.getPathMesh(path);
			var target: Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0xFF00FF));
			target.position = this._currentTarget;
			ret.addChild(target);
			
			return ret;
		}
		
		public function pauseSound():void
		{
			if (this._bSoundPlaying)
				SoundAS.pause("MonsterSounds");
				
			this._bIsEnabled = false;
		}
		
		public function resumeSound():void
		{
			if (this._bSoundPlaying)
				SoundAS.resume("MonsterSounds");
				
			this._bIsEnabled = true;
		}
	}
	
}
