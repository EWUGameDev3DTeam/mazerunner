package team3d.objects {
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.bases.BasePlayer;
	import team3d.objects.maze.Maze;
	import team3d.objects.players.HumanPlayer;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class World 
	{
		/* ---------------------------------------------------------------------------------------- */
		
		private static	var	_instance	:World;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public			var ScreenChange	:Signal;
		
		private			var	_stage		:Stage;
		private			var _view		:View3D;
		private			var _physics	:AWPDynamicsWorld;
		private			var _curScreen	:String;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function World($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("Cannot be initialized");
			
			ScreenChange = new Signal();
			_view = new View3D();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the currently shown screen
		 *
		 * @param	$screen	The screen being displayed
		 * @return			The screen being displayed
		 */
		public function get CurrentScreen():String
		{
			return _curScreen;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set CurrentScreen($screen:String):void
		{
			_curScreen = $screen;
			this.ScreenChange.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Starts the world
		 */
		public function Begin():void
		{
			_view = new View3D();
			//Set up the physics world
			if (_physics == null)
			{
				_physics = AWPDynamicsWorld.getInstance();
				_physics.initWithDbvtBroadphase();
			}
			_physics.gravity = new Vector3D(0, -4.6, 0);//move gravity to pull down on y axis
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the world
		 */
		public function End():void
		{
			_physics.cleanWorld(true);
			
			while (_view.scene.numChildren > 0)
				_view.scene.removeChildAt(0);
			
			_view.stage3DProxy.clear();
			_view.stage3DProxy.dispose();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Initializes the world object
		 *
		 * @param	$stage	The stage for the world
		 */
		public function init($stage:Stage):void
		{
			// if the stage is not full, meaning there was a previous stage
			if (_stage != null)
			{
				_stage.removeEventListener(Event.RESIZE, windowResize);
			}
			
			_stage = $stage;
			_stage.addEventListener(Event.RESIZE, windowResize);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds the given object to the world
		 *
		 * @param	$b	The associated rigid body to add to the world
		 */
		public function addObject($b:AWPRigidBody):void
		{
			// nothing to add
			if ($b == null)
				return;
			
			// add the mesh to the world
			_view.scene.addChild($b.skin);
			
			// add it to the physics world
			_physics.addRigidBody($b);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds the given maze to the world
		 *
		 * @param	$m	The maze to add
		 */
		public function addMaze($m:Maze):void
		{
			for each(var row in $m.Rooms)
			{
				for each(var r in row)
				{
					if (r.HasColumnWall)
						addObject(r.ColumnWall.rigidBody);
					
					if (r.HasRowWall)
						addObject(r.RowWall.rigidBody);
				}
			}
			
			for each(var rowBorder in $m.RowBorder)
				addObject(rowBorder.rigidBody);
				
			for each(var colBorder in $m.ColumnBorder)
				addObject(colBorder.rigidBody);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Updates the world
		 */
		public function update():void
		{
			lockMouse();
			_physics.step(1/30, 1, 1/30);
			_view.render();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Occurs when the stage is resized
		 *
		 * @param	$e	unused event object
		 */
		private function windowResize(e:Event = null):void 
		{
			_view.width = _stage.stageWidth;
			_view.height = _stage.stageHeight;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the current View3D for the world
		 *
		 * @return	The View3D for the world
		 * @author Jakob Wilson	
		 */
		public function get physics():AWPDynamicsWorld
		{
			return this._physics;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the current View3D for the world
		 *
		 * @return			The View3D for the world
		 */
		public function get view():View3D
		{
			return _view;
		}
		
		public function get displayState():String
		{
			return _stage.displayState;
		}
		
		public function get isFullScreen():Boolean
		{
			return _stage.displayState == StageDisplayState.FULL_SCREEN;
		}
		
		public function get isFullScreenInteractive():Boolean
		{
			return _stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		public function get isNormal():Boolean
		{
			return _stage.displayState == StageDisplayState.NORMAL;
		}
		
		public function get isMouseLocked():Boolean
		{
			return _stage.mouseLock;
		}
		
		/**
		 * Locks the mouse
		 *
		 * @return			False if mouse unlocking is not possible or failed. True if succeeded.
		 */
		public function lockMouse():Boolean
		{
			if (isNormal)
				return false;
			else if (_stage.mouseLock)
				return false;
			
			_stage.mouseLock = true;
			return true;
		}
		
		/**
		 * Unlocks the mouse
		 *
		 * @return			False if mouse unlocking is not possible or failed. True if succeeded.
		 */
		public function unlockMouse():Boolean
		{
			if (isNormal)
				return false;
			
			_stage.mouseLock = false;
			return true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the stage reference
		 * 
		 * @return	The stage for the world
		 */
		public function get	stage():Stage
		{
			return _stage;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public static function get instance():World
		{
			if (_instance == null)
				_instance = new World(SingletonLock);
			
			return _instance;
		}
	}
	
}

class SingletonLock{}