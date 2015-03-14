package team3d.screens
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.tools.utils.Bounds;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import com.greensock.TweenMax;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import com.jakobwilson.Cannon.Cannon;
	import com.jakobwilson.Trigger3D;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.builders.MazeBuilder;
	import team3d.objects.maze.Maze;
	import team3d.objects.maze.MazeRoom;
	import team3d.objects.players.FlyPlayer;
	import team3d.objects.players.KinematicPlayer;
	import team3d.objects.World;
	import team3d.utils.CountDownTimer;
	import team3d.utils.pathfinding.NavGraph;
	import treefortress.sound.SoundAS;
	import team3d.objects.npc.MonsterPlayer;
	
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
		
		private var _graph				:NavGraph;
		
		private var _cube				:Mesh;		//for debug, remove before release
		private var _path				:ObjectContainer3D;
		private var _maze				:Maze;
		/** set to true for debug output*/
		private var _debug = false;
		
		public static const origin		:Vector3D = new Vector3D();
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
		private var _won				:Boolean;
		
		private var _wallHeight			:Number;
		
		private var _timerText			:TextField;
		private var _timer				:CountDownTimer;
		
		private var _cannons 			:Vector.<Cannon>	// a vector to hold cannons so they won't get garbage collected. 
															//This should be removed after cannons are refactored
		private var _monster:MonsterPlayer;
		private var _monsterPath:ObjectContainer3D;		//the monster's path mesh for debug
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
			
			var so:SharedObject = SharedObject.getLocal("dataTeam3D");
			so.data.gameScreen = this;
			_winTrigger = new Trigger3D(800);
			_winTrigger.TriggeredSignal.add(wonGame);
			
			_timer = new CountDownTimer();
			_timer.CompletedSignal.add(closeExit);
			
			var format:TextFormat = new TextFormat();
			format.size = 60;
			
			_timerText = new TextField();
			_timerText.autoSize = TextFieldAutoSize.LEFT;
			_timerText.defaultTextFormat = format;
			_timerText.textColor = 0xFFFFFF;
			
			this.addChild(_timerText);
		}
		
		private function openEntrance($a:Asset):void
		{
			_entranceOpening = true;
			
			SoundAS.playFx("DoorsOpening", .2);
		}
		
		private function closeEntrance($a:Asset):void
		{
			if (!_entranceClosing)
				_timer.start();
			
			_entranceClosing = true;
			if (_entranceOpening)
			{
				_entranceOpening = false;
				_entranceOpen.end();
			}
			
			SoundAS.pause("DoorsOpening");
			SoundAS.pause("Elevator");
		}
		
		private function closeExit($a:Asset = null):void
		{
			if (!_exitClosing)
				_timer.stop();
			
			_exitClosing = true;
			if (_exitOpening)
				_exitOpening = false;
		}
		
		private function timeUp():void
		{
			_exitClosing = true;
			
			SoundAS.playFx("TimeEnds");
			SoundAS.playFx("DoorClosing", 2);
			
			_won = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 *
		 */
		override public function Begin():void
		{
			super.Begin();
			World.instance.Begin();
			World.instance.physics.collisionCallbackOn = true;
			World.instance.lockMouse();
			this.addChild(World.instance.view);
			
			var rows:int = 10;
			var cols:int = 10;
			
			SoundAS.playLoop("GameMusic", .05);
			
			_timer.reset(5,5,0);
			_timerText.textColor = 0xFFFFFF;
			
			_cageMoving = true;
			_controlsEnabled = false;
			_paused = false;
			_entranceOpening = false;
			_entranceClosing = false;
			_exitClosing = false;
			_exitOpening = true;
			_won = false;
			
			//Create player
			/*
			_player = new KinematicPlayer(World.instance.view.camera, 300,100,0.4);
			_player.addToWorld(World.instance.view, World.instance.physics);
			_player.controller.warp(new Vector3D(0, 10000, 0));
			_player.Begin();
			*/
			//end player
			
			
			AssetManager.instance.getAsset("Ground").scaleTo(new Vector3D(100,100,100));
			AssetManager.instance.getAsset("Ground").transformTo(new Vector3D(0,-5,0));
			AssetManager.instance.getAsset("Ground").addToScene(World.instance.view, World.instance.physics);
			createPlayer();
			var maze:Maze = createMaze(rows, cols);
			createEntrance(maze);
			createExit(maze);
			wireTriggers(maze);
			
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			KeyboardManager.instance.addKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.G, wonGame);
			//			TEMPORARY KEY BINDINGS*/
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			//World.instance.view.camera = FlyController(_player.Controller).Camera;
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			
			//Create the skybox
			if(this._debug)
				AssetManager.instance.getAsset("DebugSky").addToScene(World.instance.view, World.instance.physics);
			else
				AssetManager.instance.getAsset("Sky").addToScene(World.instance.view, World.instance.physics);
			//end skybox
			
			//create navGraph
			this._graph = new NavGraph();
			this._graph.genFromMaze(this._maze.Rooms, new Vector3D(425, 300, 425));
			if(this._debug)
				World.instance.view.scene.addChild(this._graph.getWaypointMesh());
			//end navgraph			
			
			//Create a Monster
			_monster = new MonsterPlayer(AssetManager.instance.getAsset("Monster"),300, 100, 0.05);
			_monster.controller.ghostObject.position = new Vector3D(750,150, 750);
			_monster.NavGraph = this._graph;
			_monster.setTarget(this._player.controller.ghostObject.skin);
			_monster.addToWorld(World.instance.view, World.instance.physics);
			_monster.targetTouchedSignal.add(this.failedGame);
			_monster.Begin();
			
			var rectangle:Shape = new Shape;
			rectangle.name = "rectangleFade";
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, this.width, this.height);
			rectangle.graphics.endFill();
			this.addChild(rectangle);
			//toggleCamera();
			
			TweenMax.fromTo(rectangle, 2, {autoAlpha: 1}, {autoAlpha: 0, delay: 0.5});
			
			_player.canWalk = false;
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
			_exitClose.position = new Vector3D(_exitWall.position.x, _exitWall.position.y, _exitWall.position.z + 810);
			_exitClose.addObjectActivator(_player.controller.ghostObject);
			_exitClose.begin();
			
			_winTrigger.position = new Vector3D(_exitWall.position.x, _exitWall.position.y, _exitWall.position.z + 6000);
			_winTrigger.addObjectActivator(_player.controller.ghostObject);
			_winTrigger.begin();
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
			var xloc:Number = _exitWall.position.x; // floorLength * exitRoom;
			
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
			var wall:Asset = $maze.GetRoom(0, roomnum).RowWall;
			Bounds.getMeshBounds(wall.model);
			var wallLength:Number = Bounds.depth;
			
			_cage = AssetManager.instance.getCopy("Cage");
			Bounds.getMeshBounds(_cage.model);
			var cageLength:Number = Bounds.depth;
			
			Bounds.getMeshBounds(_cage.model);
			var x:Number = wall.position.x + (wallLength * 0.5);
			var z:Number = wall.position.z - (Bounds.depth * 0.5) - 50;
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
		
		public function createCannon($transform:Vector3D, $rotation:Vector3D)
		{
			var cannon:Cannon = new Cannon(AssetManager.instance.getCopy("Cannon"), AssetManager.instance.getCopy("CannonBall"));
			cannon.addObjectActivator(this._player.controller.ghostObject);
			cannon.transformTo($transform);
			cannon.rotateTo($rotation);
			cannon.addToScene(World.instance.view, World.instance.physics);
			this._cannons.push(cannon);
		}
		
		private function checkWin():void
		{
			if (_player.controller.ghostObject.position.z < _exitWall.position.z)
				failedGame();
		}
		
		private function failedGame():void
		{
			this._monster.targetTouchedSignal.remove(this.failedGame);
			this.DoneSignal.dispatch(false);
		}
		
		private function wonGame($a:Asset = null):void
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
			this._maze = maze;///Added for AI - Jake
			_cannons = new Vector.<Cannon>();
			for (var i:Number = 0; i < maze.Rooms.length; i++)
			{	
				var rooms = maze.Rooms[i];
				
				if (rooms != null)
				{
					for(var j:Number = 0; j < rooms.length; j++)
					{
						var room:MazeRoom = rooms[j];
						var transform1:Vector3D;
						var transform2:Vector3D;
						var transform3:Vector3D;
						
						var side:Number = Math.random();
						var chance:Number = Math.random();
						
						if (side < .5 && room.ColumnWall != null && chance < .5)
						{
							transform1 = room.ColumnWall.position.add(new Vector3D(50, 200, 200));
							transform2 = room.ColumnWall.position.add(new Vector3D(50, 200, -200));
							transform3 = room.ColumnWall.position.add(new Vector3D(50, 200, 0));
							
							this.createCannon(transform1, new Vector3D(0, 90));
							this.createCannon(transform2, new Vector3D(0, 90));
							this.createCannon(transform3, new Vector3D(0, 90));
						}
						else if (room.RowWall != null && chance < .5)
						{
							transform1 = room.RowWall.position.add(new Vector3D(200, 200, 50));
							transform2 = room.RowWall.position.add(new Vector3D( -200, 200, 50));
							transform3 = room.RowWall.position.add(new Vector3D(0, 200, 50));
							
							this.createCannon(transform1, origin);
							this.createCannon(transform2, origin);
							this.createCannon(transform3, origin);
						}
					}
				}
			}
			return maze;
		}
		
		public function Unpause()
		{
			_paused = false;
			if(_timer.HasBeenStarted)
				_timer.start();
				
			SoundAS.resume("GameMusic");
			
			this._monster.resumeSound();
		}
		
		public function Pause()
		{
			_paused = true;
			_timer.stop();
			
			SoundAS.pause("GameMusic");
			
			this._monster.pauseSound();
		}
		
		protected function pauseGame():void
		{
			if (_paused)
				return;
			
			this.PausedSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.removeKeyUpListener(KeyCode.T, toggleCamera);
			KeyboardManager.instance.removeKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.removeKeyUpListener(KeyCode.G, wonGame);
			//			TEMPORARY KEY BINDINGS*/
			
			KeyboardManager.instance.removeKeyUpListener(KeyCode.P, pauseGame);
			
			_player.End();
			_flyPlayer.End();
			_monster.End();
			
			_entranceClose.end();
			_entranceOpen.end();
			_exitClose.end();
			
			for each(var c:Cannon in this._cannons)
				c.End();
			this._cannons = null;
			
			SoundAS.pause("GameMusic");
			
			SoundAS.playFx("PlayerDeath");
			
			World.instance.unlockMouse();
			
			this.removeChild(World.instance.view);
			this.removeChild(this.getChildByName("rectangleFade"));
			
			World.instance.End();
			super.End();
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
		
		private function updateTimer():void
		{
			var seconds:String = _timer.Seconds.toString();
			
			if (_timer.Seconds < 10)
				seconds = "0" + seconds;
			
			_timerText.text = _timer.Minutes + ":" + seconds;
			
			
			if (_timer.Minutes < 1)
			{
				var millis:String = _timer.Milliseconds.toString();
				if (_timer.Milliseconds < 100 && _timer.Milliseconds > 10)
					millis = "0" + millis;
				else if (_timer.Milliseconds < 10)
					millis = "00" + millis;
				
				_timerText.appendText(":" + millis);
			}
			
			if (_timer.Minutes < 1 && _timer.Seconds > 30)
			{
				_timerText.textColor = 0xFFFF00;
			}
			else if (_timer.Minutes < 1 && _timer.Seconds < 30)
				_timerText.textColor = 0xFF0000;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
		{
			if (_paused)
				return;
				
			if(this._debug)
			{
				if(this._monsterPath != null && World.instance.view.scene.contains(this._monsterPath))
					World.instance.view.scene.removeChild(this._monsterPath);
				this._monsterPath = this._monster.getPathMesh();
				if(this._monsterPath != null)
					World.instance.view.scene.addChild(this._monsterPath);
			}
			
			if (World.instance.isNormal || !World.instance.isMouseLocked)
			{
				pauseGame();
				return;
			}
			
			updateTimer();
			
			if (_cageMoving)
			{
				_cage.transformTo(new Vector3D(_cage.position.x, _cage.position.y - 10, _cage.position.z));
				if (_cage.position.y <= 20)
				{
					_cageMoving = false;
					_player.Camera.lens.far = 5000;
					_player.canWalk = true;
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
					checkWin();
				}
			}
			else if (_exitOpening)
			{
				_exitWall.transformTo(new Vector3D(_exitWall.position.x, _exitWall.position.y - 1, _exitWall.position.z));
				if (_exitWall.position.y + _wallHeight <= 0)
					_exitOpening = false;
			}
			
			World.instance.update();
		}
		
		override protected function resize($e:Event = null):void 
		{
			//super.resize($e);
			// do nothing, VERY intentional
		}
	}
}