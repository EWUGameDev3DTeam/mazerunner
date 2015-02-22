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
	import flash.events.Event;
	import flash.geom.Vector3D;
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
		
		/** The stage for the world */
		private 		var _stage		:Stage;
		/** The physics for the world */
		private			var _physics	:AWPDynamicsWorld;
		/** view object that holds the scene and camera */
		private 		var _view		:View3D;
		private			var _meshes		:Object;
		private			var _started	:Boolean;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function World($lock:Class)
		{
			if ($lock != SingletonLock)
				throw new Error("Cannot be initialized");
			
			_view = new View3D();
			_meshes = new Object();
			
			initPhysics();
			createWorld();
			changeLens();
			_started = false
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Starts the world
		 */
		public function Begin():void
		{
			_started = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the world
		 */
		public function End():void
		{
			_started = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds a player to the world
		 *
		 * @param	$p		The player to add to the world
		 */
		public function AddPlayer($p:HumanPlayer):void
		{
			trace("z: " + $p.mesh.z);
			addMesh($p.mesh);
			_physics.addRigidBody($p.getRigidBody());
			$p.Begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Initializs the physics for the world
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		protected function initPhysics():void
		{
			_physics = AWPDynamicsWorld.getInstance();
			_physics.initWithDbvtBroadphase();
			_physics.gravity = new Vector3D(0,0,-1);//move gravity to pull down on z axis
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Creates the general world
		 */
		protected function createWorld():void
		{
			var floor:Mesh = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, false), new ColorMaterial(0xFFFFFF));
			floor.name = "floor";
			floor.x = 0;
			floor.y = 0;
			floor.z = -50;
			//floor.rotationY += ;
			
			//Ugly Floor Physics
			var floorCol:AWPBoxShape = new AWPBoxShape(10000, 10000, 1);
			var floorRigidBody:AWPRigidBody = new AWPRigidBody(floorCol, floor, 0);
			floorRigidBody.friction = 1;
			floorRigidBody.position = new Vector3D(0, 0, -50);
			// end ugly physics
			
			_physics.addRigidBody(floorRigidBody);
			addMesh(floor);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Stores a local version of the mesh
		 *
		 * @param	$m	The mesh to add
		 */
		protected function addMesh($m:Mesh):void
		{
			_meshes[$m.name] = $m;
			_view.scene.addChild($m);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds a maze to the world
		 *
		 * @param	$m		The maze to add
		 */
		public function AddMaze($m:Maze):void
		{
			for each(var row in $m.Rooms)
			{
				for each(var r in row)
				{
					if (r.HasColumnWall)
					{
						_view.scene.addChild(r.ColumnWall.skin);
						_physics.addRigidBody(r.ColumnWall);
					}
					
					if (r.HasRowWall)
					{
						_view.scene.addChild(r.RowWall.skin);
						_physics.addRigidBody(r.RowWall);
					}
				}
			}
			//*
			for each (var colWall in $m.ColumnBorder)
			{
				_view.scene.addChild(colWall.skin);
				_physics.addRigidBody(colWall);
			}
			//*
			for each(var rowWall in $m.RowBorder)
			{
				_view.scene.addChild(rowWall.skin);
				_physics.addRigidBody(rowWall);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the mesh object associated with the name
		 *
		 * @param	$s		The name of the mesh object
		 * @return			The mesh object
		 */
		public function GetMesh($s:String):Mesh
		{
			return _meshes[$s];
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Changes the lens of the camera
		 */
		private function changeLens():void
		{
			var lb:LensBase = new PerspectiveLens(75);
			lb.far = 20000;
			_view.camera.lens = lb;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the View3D of the world
		 *
		 * @return		The View3D
		 */
		public function get View():View3D
		{
			return _view;
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
		 * Occurs when the stage is resized
		 *
		 * @param	$e	unused event object
		 */
		private function windowResize(e:Event = null):void 
		{
			_view.width = World.instance.stage.stageWidth;
			_view.height = World.instance.stage.stageHeight;
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
		
		/**
		 * Updates the world - KEEP AS SMALL AND SIMPLE AS POSSIBLE
		 */
		public function Update():void
		{
			if (!_started) return;
			
			trace("z: " + ((Mesh)(_meshes["player"])).z);
			_physics.step(1/30, 1, 1/30);
			_view.render();
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