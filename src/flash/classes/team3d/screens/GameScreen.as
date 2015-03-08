package team3d.screens
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.tools.utils.Bounds;
	import com.greensock.TweenMax;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import com.jakobwilson.Trigger3D;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.builders.MazeBuilder;
	import team3d.objects.maze.Maze;
	import team3d.objects.maze.MazeRoom;
	import team3d.objects.players.FlyPlayer;
	import team3d.objects.players.KinematicPlayer;
	import team3d.objects.World;
	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class GameScreen extends BaseScreen
	{
		/* ---------------------------------------------------------------------------------------- */
		
		public var PausedSignal			:Signal;
		
		private var _paused				:Boolean;
		
		private var _controlsEnabled	:Boolean;

		private var _player				:KinematicPlayer;
		
		private var _flyPlayer			:FlyPlayer;
		
		private var _cage				:Asset;
		private var _cageMoving			:Boolean;
		
		private var _entranceOpen		:Trigger3D;
		private var _entranceClose		:Trigger3D;
		private var _entranceOpening	:Boolean;
		private var _entranceClosing	:Boolean;
		private var _entranceTriggered	:Boolean;
		private var _entranceWall		:Asset;
		
		private var _exitClose			:Trigger3D;
		private var _exitClosing		:Boolean;
		private var _exitOpening		:Boolean;
		private var _exitWall			:Asset;
		
		private var _winTrigger			:Trigger3D;
		
		private var _wallHeight			:Number;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object. This screen is ALWAYS visible
		 */
		public function GameScreen()
		{
			super();
			_screenTitle = "Game";
			_flyPlayer = new FlyPlayer();
			
			DoneSignal = new Signal(Boolean);
			PausedSignal = new Signal();
			
			_winTrigger = new Trigger3D(800);
			_winTrigger.TriggeredSignal.add(wonGame);
		}
		
		private function openEntrance($a:Asset):void
		{
			_entranceOpening = true;
		}
		
		private function closeEntrance($a:Asset):void
		{
			_entranceClosing = true;
			if (_entranceOpening)
			{
				_entranceOpening = false;
				_entranceOpen.end();
			}
		}
		
		private function closeExit($a:Asset):void
		{
			if (!_exitClosing)
				_winTrigger.begin();
			
			_exitClosing = true;
			
			if (_exitOpening)
			{
				_exitOpening = false;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		override public function Begin():void
		{
			super.Begin();
			World.instance.Begin();
			World.instance.lockMouse();
			this.addChild(World.instance.view);
			
			var rows:int = 5;
			var cols:int = 5;
			
			_cageMoving = true;
			_controlsEnabled = false;
			_paused = false;
			_entranceOpening = false;
			_entranceClosing = false;
			_exitClosing = false;
			_exitOpening = true;
			
			//*/
			var maze:Maze = createMaze(rows, cols);
			createPlayer();
			createEntrance(maze);
			createExit(maze);
			wireTriggers(maze);
			
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			KeyboardManager.instance.addKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.G, wonGame);
			//			TEMPORARY KEY BINDINGS*/
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			
			/*
			//create a cannon
			var cannon:Cannon = new Cannon(AssetManager.instance.getCopy("Cannon"), AssetManager.instance.getCopy("CannonBall"));
			cannon.addObjectActivator(this._player.controller.ghostObject);
			cannon.transformTo(new Vector3D(70,200,0));
			cannon.rotateTo(new Vector3D(0,0,0));
			cannon.addToScene(World.instance.view, World.instance.physics);
			//End cannon creation
			*/
			
			var rectangle:Shape = new Shape();
			rectangle.name = "rectangleFade";
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, this.width, this.height);
			rectangle.graphics.endFill();
			this.addChild(rectangle);
			//toggleCamera();
			
			TweenMax.fromTo(rectangle, 2, { autoAlpha:1}, { autoAlpha:0, delay:0.5 } );
		}
		
		private function wireTriggers($maze:Maze):void
		{
			var pos:int = int(Math.floor($maze.Columns * 0.5));
			_entranceWall = $maze.GetRoom(0, pos).RowWall;
			//_exitWall = $maze.RowBorder[pos];
			
			Bounds.getMeshBounds(_entranceWall.model);
			_wallHeight = Bounds.height;
			
			_entranceOpen = new Trigger3D(2000);
			_entranceOpen.TriggeredSignal.add(openEntrance);
			_entranceOpen.position = _entranceWall.model.position;
			_entranceOpen.addObjectActivator(_player.controller.ghostObject);
			_entranceOpen.begin();
			
			_entranceClose = new Trigger3D(800);
			_entranceClose.TriggeredSignal.add(closeEntrance);
			_entranceClose.position = new Vector3D(_entranceWall.position.x, _entranceWall.position.y, _entranceWall.position.z + 800);
			_entranceClose.addObjectActivator(_player.controller.ghostObject);
			_entranceClose.begin();
			
			_exitClose = new Trigger3D(800);
			_exitClose.TriggeredSignal.add(closeExit);
			_exitClose.position = new Vector3D(_exitWall.position.x, _exitWall.position.y, _exitWall.position.z + 2000);
			_exitClose.addObjectActivator(_player.controller.ghostObject);
			_exitClose.begin();
			
			_winTrigger.position = new Vector3D(_exitWall.position.x, _exitWall.position.y, _exitWall.position.z + 6000);
			_winTrigger.addObjectActivator(_player.controller.ghostObject);
		}
		
		private function createExit($maze:Maze):void
		{
			var floor:Asset = AssetManager.instance.getAsset("Floor");
			Bounds.getMeshBounds(floor.model);
			var floorLength:Number = Bounds.depth;
			
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			Bounds.getMeshBounds(wall.model);
			var wallWidth:Number = Bounds.width;
			
			var exitRoom:int = Math.random() * $maze.Columns;
			_exitWall = $maze.RowBorder[exitRoom];
			var xloc:Number = _exitWall.position.x;// floorLength * exitRoom;
			
			var zloc:Number;
			var halfWidth:Number = wallWidth * 0.5;
			var halfLength:Number = floorLength * 0.5;
			for (var i:int = 0; i < 10; i++)
			{
				zloc = floorLength * ($maze.Rows + i) + halfLength;
				floor = AssetManager.instance.getCopy("Floor");
				floor.transformTo(new Vector3D(xloc, 0, zloc + halfWidth));
				World.instance.addObject(floor);
				
				wall = AssetManager.instance.getCopy("Wall");
				wall.transformTo(new Vector3D(xloc - halfLength, 0, zloc + halfWidth));
				World.instance.addObject(wall);
				
				wall = AssetManager.instance.getCopy("Wall");
				wall.transformTo(new Vector3D(xloc + halfLength, 0, zloc + halfWidth));
				World.instance.addObject(wall);
			}
			
			wall = AssetManager.instance.getCopy("Wall");
			wall.transformTo(new Vector3D(xloc + halfWidth, 0, zloc + halfLength));
			wall.rotateTo(new Vector3D(0, 90, 0));
			World.instance.addObject(wall);
		}
		
		private function createEntrance($maze:Maze):void
		{
			var roomnum:int = int(Math.floor($maze.Columns * 0.5));
			DebugScreen.Text("room: " + roomnum);
			var wall:Asset = $maze.GetRoom(0, roomnum).RowWall;
			Bounds.getMeshBounds(wall.model);
			var wallLength:Number = Bounds.depth;
			
			_cage = AssetManager.instance.getCopy("Cage");
			Bounds.getMeshBounds(_cage.model);
			var cageLength:Number = Bounds.depth;
			
			Bounds.getMeshBounds(_cage.model);
			var x:Number = wall.position.x + (wallLength * 0.5);
			var z:Number = wall.position.z - (Bounds.depth * 0.5) - 50;
			DebugScreen.Text("x: " + x);
			DebugScreen.Text("z: " + z, true);
			_cage.transformTo(new Vector3D(x, 4000, z));
			World.instance.addObject(_cage);
			
			_player.controller.warp(new Vector3D(_cage.position.x, _cage.position.y + 500, _cage.position.z));
		}
		
		private function createPlayer():void
		{
			//Create player
			var cam:Camera3D = new Camera3D();
			cam.lens = new PerspectiveLens(75);
			cam.lens.far = 16000;
			World.instance.view.camera = cam;
			_player = new KinematicPlayer(cam, 300, 100, 0.4);
			_player.addToWorld(World.instance.view, World.instance.physics);
			_player.Begin();
		}
		
		private function failedGame():void
		{
			this.DoneSignal.dispatch(false);
		}
		
		private function wonGame($a:Asset):void
		{
			_winTrigger.end();
			this.DoneSignal.dispatch(true);
		}
		
		private function createMaze($rows:int, $cols:int):Maze
		{
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			var floor:Asset = AssetManager.instance.getAsset("Floor");
			
			var startx:Number = 0;
			var startz:Number = 0;
			
			
			var maze:Maze = MazeBuilder.instance.Build($rows, $cols, startx, startz, wall, floor);
			World.instance.addMaze(maze);
			return maze;
		}
		
		public function Unpause(){_paused = false;}
		public function Pause(){_paused = true;}
		
		protected function pauseGame():void
		{
			if (_paused) return;
			
			this.PausedSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.removeKeyUpListener(KeyCode.T, toggleCamera);
			KeyboardManager.instance.removeKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.removeKeyUpListener(KeyCode.G, wonGame);
			//			TEMPORARY KEY BINDINGS*/
			
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
			
			KeyboardManager.instance.removeKeyUpListener(KeyCode.P, pauseGame);
			
			_player.End();
			_flyPlayer.End();
			
			_entranceClose.end();
			_entranceOpen.end();
			_exitClose.end();
			
			World.instance.End();
			super.End();
			
			World.instance.unlockMouse();
			
			this.removeChild(World.instance.view);
			this.removeChild(this.getChildByName("rectangleFade"));
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Toggles the camera between first and fly cam
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		protected function toggleCamera():void
		{
			if (World.instance.view.camera == _player.Camera)
			{
				_player.End();
				_flyPlayer.Begin();
				World.instance.view.camera = _flyPlayer.Controller.Camera;
			}
			else
			{
				_flyPlayer.End();
				_player.Begin();
				World.instance.view.camera = _player.Camera;
			}
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
		{
			if (_paused) return;
			
			if (World.instance.isNormal || !World.instance.isMouseLocked)
			{
				pauseGame();
				return;
			}
			
			if (_cageMoving)
			{
				_cage.transformTo(new Vector3D(_cage.position.x, _cage.position.y - 10, _cage.position.z));
				if (_cage.position.y <= 20)
				{
					_cageMoving = false;
					_player.Camera.lens.far = 5000;
				}
			}
			
			if (_entranceOpening)
			{
				_entranceWall.transformTo(new Vector3D(_entranceWall.position.x, _entranceWall.position.y - 1, _entranceWall.position.z));
				if (_entranceWall.position.y + _wallHeight <= 0)
				{
					_entranceOpening = false;
					_entranceOpen.end();
				}
			}
			else if (_entranceClosing)
			{
				_entranceWall.transformTo(new Vector3D(_entranceWall.position.x, _entranceWall.position.y + 1, _entranceWall.position.z));
				if (_entranceWall.position.y >= 0)
				{
					_entranceClosing = false;
					_entranceClose.end();
				}
			}
			
			if (_exitClosing)
			{
				_exitWall.transformTo(new Vector3D(_exitWall.position.x, _exitWall.position.y + 1, _exitWall.position.z));
				if (_exitWall.position.y >= 0)
				{
					_exitClosing = false;
					_exitClose.end();
				}
			}
			else if (_exitOpening)
			{
				_exitWall.transformTo(new Vector3D(_exitWall.position.x, _exitWall.position.y - 1, _exitWall.position.z));
				if (_exitWall.position.y + _wallHeight <= 0)
					_exitOpening = false;
			}
			
			//DebugScreen.Text("entrance closing: " + _entranceClosing);
			//DebugScreen.Text("entrance opening: " + _entranceOpening, true);
			//DebugScreen.Text("exit closing: " + _exitClosing, true);
			//DebugScreen.Text("exit opening: " + _exitOpening, true);
			
			World.instance.update();
		}
	}
}