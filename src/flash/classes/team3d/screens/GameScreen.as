package team3d.screens
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import com.greensock.TweenMax;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
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
	import team3d.animation.MoveYAnimation;
	import team3d.bases.BaseScreen;
	import team3d.builders.MazeBuilder;
	import team3d.objects.maze.Maze;
	import team3d.objects.npc.MonsterPlayer;
	import team3d.objects.players.FlyPlayer;
	import team3d.objects.players.KinematicPlayer;
	import team3d.objects.World;
	import team3d.utils.CountDownTimer;
	import team3d.utils.pathfinding.NavGraph;
	import treefortress.sound.SoundAS;
	
	/**
	 *
	 *
	 * @author Nate Chatellier
	 */
	public class GameScreen extends BaseScreen
	{
		/* ---------------------------------------------------------------------------------------- */
		
		public var PausedSignal				:Signal;
		
		private var _paused					:Boolean;
		private var _controlsEnabled		:Boolean;
		
		private var _player					:KinematicPlayer;
		private var _flyPlayer				:FlyPlayer;
		
		private var _graph					:NavGraph;
		
		private var _cube					:Mesh;		//for debug, remove before release
		private var _path					:ObjectContainer3D;
		private var _maze					:Maze;
		/** set to true for debug output*/
		private var _debug = false;
		
		private var _cageAnimation			:MoveYAnimation;
		private var _cage					:Asset;
		
		private var _entranceAnimation		:MoveYAnimation;
		private var _entranceOpenTrigger	:Trigger3D;
		private var _entranceCloseTrigger	:Trigger3D;
		private var _timeStartTrigger		:Trigger3D;
		private var _entranceWall			:Asset;
		
		private var _exitAnimation			:MoveYAnimation;
		private var _exitCloseTrigger		:Trigger3D;
		private var _winTrigger				:Trigger3D;
		
		private var _wallHeight				:Number;
		
		private var _timerText				:TextField;
		private var _timer					:CountDownTimer;
		
		private var _monster				:MonsterPlayer;
		private var _monsterPath			:ObjectContainer3D;		//the monster's path mesh for debug
		
		private var _wonGame				:Boolean;
		private var _lostGame				:Boolean;
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
			_timer.CompletedSignal.add(timeUp);
			
			var format:TextFormat = new TextFormat();
			format.size = 60;
			
			_timerText = new TextField();
			_timerText.autoSize = TextFieldAutoSize.LEFT;
			_timerText.defaultTextFormat = format;
			_timerText.textColor = 0xFFFFFF;
			
			this.addChild(_timerText);
		}
		
		private function cageDone():void
		{
			_player.Camera.lens.far = 5000;
			_player.canWalk = true;
			_monster.Begin();
		}
		
		private function openEntrance($a:Asset):void
		{
			_entranceOpenTrigger.end();
			_entranceAnimation.Begin();
			
			SoundAS.playFx("DoorsOpening", .2);
		}
		
		private function closeEntrance($a:Asset):void
		{
			_entranceOpenTrigger.end();
			_entranceCloseTrigger.end();
			_entranceAnimation.Reverse();
			
			SoundAS.pause("DoorsOpening");
			SoundAS.pause("Elevator");
		}
		
		private function closeExit($a:Asset = null):void
		{
			_exitCloseTrigger.end();
			_timer.stop();
			_exitAnimation.Reverse();
		}
		
		private function timeUp():void
		{
			SoundAS.playFx("TimeEnds");
			SoundAS.playFx("DoorClosing", 2);
			closeExit();
		}
		
		private function startTimer($a:Asset):void
		{
			_timer.start();
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
			
			var rows:int = 10;
			var cols:int = 10;
			
			SoundAS.playLoop("GameMusic", .05);
			
			_timer.stop();
			_timer.reset(5,5,0);
			_timerText.textColor = 0xFFFFFF;
			
			_controlsEnabled = false;
			_paused = false;
			_wonGame = false;
			_lostGame = false;
			
			createPlayer();
			var maze:Maze = createMaze(rows, cols, _player.controller.ghostObject);
			createElevator(maze);
			createGround();
			createMonster();
			wireTriggers(maze);
			
			_cageAnimation = new MoveYAnimation(_cage, 10, 20, cageDone);
			_entranceAnimation = new MoveYAnimation(_maze.entranceWall, 1, -_wallHeight);
			_exitAnimation = new MoveYAnimation(_maze.exitWall, 1, -_wallHeight, null, checkWin);
			
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			KeyboardManager.instance.addKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.G, wonGame);
			//			TEMPORARY KEY BINDINGS*/
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			
			//Create the skybox
			if(this._debug)
				AssetManager.instance.getAsset("DebugSky").addToScene(World.instance.view, World.instance.physics);
			else
				AssetManager.instance.getAsset("Sky").addToScene(World.instance.view, World.instance.physics);
			//end skybox
			
			var rectangle:Shape = new Shape;
			rectangle.name = "rectangleFade";
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, this.width, this.height);
			rectangle.graphics.endFill();
			this.addChild(rectangle);
			//toggleCamera();
			
			TweenMax.fromTo(rectangle, 2, {autoAlpha: 1}, {autoAlpha: 0, delay: 0.5});
			_cageAnimation.Begin();
			_exitAnimation.Begin();
			
			_player.canWalk = false;
		}
		
		private function wireTriggers($maze:Maze):void
		{
			var entranceWall:Asset = $maze.entranceWall;
			var exitWall:Asset = $maze.exitWall;
			//_exitWall = $maze.RowBorder[pos];
			
			Bounds.getMeshBounds(entranceWall.model);
			_wallHeight = Bounds.height;
			_entranceOpenTrigger = new Trigger3D(2000);
			_entranceOpenTrigger.TriggeredSignal.add(openEntrance);
			_entranceOpenTrigger.position = entranceWall.model.position;
			_entranceOpenTrigger.addObjectActivator(_player.controller.ghostObject);
			_entranceOpenTrigger.begin();
			
			_entranceCloseTrigger = new Trigger3D(800);
			_entranceCloseTrigger.TriggeredSignal.add(closeEntrance);
			_entranceCloseTrigger.position = new Vector3D(entranceWall.position.x, entranceWall.position.y, entranceWall.position.z + 800);
			_entranceCloseTrigger.addObjectActivator(_monster.controller.ghostObject);
			_entranceCloseTrigger.begin();
			
			_timeStartTrigger = new Trigger3D(1000);
			_timeStartTrigger.TriggeredSignal.add(startTimer);
			_timeStartTrigger.position = new Vector3D(entranceWall.position.x, entranceWall.position.y, entranceWall.position.z + 800);
			_timeStartTrigger.addObjectActivator(_player.controller.ghostObject);
			_timeStartTrigger.begin();
			
			_exitCloseTrigger = new Trigger3D(800);
			_exitCloseTrigger.position = new Vector3D(exitWall.position.x, exitWall.position.y, exitWall.position.z + 810);
			_exitCloseTrigger.addObjectActivator(_player.controller.ghostObject);
			_exitCloseTrigger.begin();
			
			_winTrigger.position = new Vector3D(exitWall.position.x, exitWall.position.y, exitWall.position.z + 6000);
			_winTrigger.addObjectActivator(_player.controller.ghostObject);
			_winTrigger.begin();
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
		
		private function createGround():void
		{
			AssetManager.instance.getAsset("Ground").scaleTo(new Vector3D(100,100,100));
			AssetManager.instance.getAsset("Ground").transformTo(new Vector3D(0,-5,0));
			AssetManager.instance.getAsset("Ground").addToScene(World.instance.view, World.instance.physics);
		}
		
		private function createMonster():void
		{
			//create navGraph
			this._graph = new NavGraph();
			this._graph.genFromMaze(this._maze.Rooms, new Vector3D(425, 300, 425));
			if(this._debug)
				World.instance.view.scene.addChild(this._graph.getWaypointMesh());
			//end navgraph			
			
			//Create a Monster
			_monster = new MonsterPlayer(AssetManager.instance.getAsset("Monster"), 300, 100, 0.05);
			_monster.controller.ghostObject.position = new Vector3D(_player.controller.ghostObject.x, 150, _player.controller.ghostObject.z - 7000);
			_monster.NavGraph = this._graph;
			_monster.setTarget(this._player.controller.ghostObject.skin);
			_monster.addToWorld(World.instance.view, World.instance.physics);
			_monster.targetTouchedSignal.add(this.failedGame);
		}
		
		private function createMaze($rows:int, $cols:int, $ghost:AWPGhostObject):Maze
		{
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			var floor:Asset = AssetManager.instance.getAsset("Floor");
			
			var startx:Number = 0;
			var startz:Number = 0;
			
			var maze:Maze = MazeBuilder.instance.Build($rows, $cols, startx, startz, $ghost, wall, floor);
			World.instance.addMaze(maze);
			_maze = maze;///Added for AI - Jake
			
			return maze;
		}
		
		private function createElevator($maze:Maze):void
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
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function checkWin():void
		{
			if (_player.controller.ghostObject.position.z < _maze.exitWall.position.z)
				failedGame();
		}
		
		private function failedGame():void
		{
			if (_lostGame) return;
			_lostGame = true;
			this._monster.targetTouchedSignal.remove(this.failedGame);
			this.DoneSignal.dispatch(false);
		}
		
		private function wonGame($a:Asset = null):void
		{
			if (_wonGame) return;
			_wonGame = true;
			_winTrigger.end();
			this.DoneSignal.dispatch(true);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function Unpause()
		{
			_paused = false;
			if(_timer.HasBeenStarted)
				_timer.start();
			
			_exitAnimation.Resume();
			_entranceAnimation.Resume();
			_cageAnimation.Resume();
			
			World.instance.Resume();
			SoundAS.resumeAll();
		}
		
		public function Pause()
		{
			_paused = true;
			World.instance.Pause();
			_timer.stop();
			
			_exitAnimation.Pause();
			_entranceAnimation.Pause();
			_cageAnimation.Pause();
			
			SoundAS.pauseAll();
		}
		
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
			
			_entranceCloseTrigger.end();
			_entranceOpenTrigger.end();
			_exitCloseTrigger.end();
			_timeStartTrigger.end();
			
			endCannons();
			
			SoundAS.pause("GameMusic");
			SoundAS.playFx("PlayerDeath");
			
			World.instance.unlockMouse();
			
			//this.removeChild(World.instance.view);
			if(this.getChildByName("rectangleFade") != null)
				this.removeChild(this.getChildByName("rectangleFade"));
			
			World.instance.End();
			super.End();
		}
		
		private function endCannons():void
		{
			for (var row:int = 0; row < _maze.Rows; row++)
				for (var col:int = 0; col < _maze.Columns; col++)
					_maze.GetRoom(row, col).endCannons();
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
			_timerText.text = _timer.toString();
			
			if (_timer.Minutes < 1 && _timer.Seconds > 30)
				_timerText.textColor = 0xFFFF00;
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
			
			if (World.instance.isNormal || !World.instance.isMouseLocked)
			{
				pauseGame();
				return;
			}
			
			drawDebug();
			updateTimer();
			
			World.instance.update();
		}
		
		private function drawDebug():void
		{
			if(this._debug)
			{
				if(this._monsterPath != null && World.instance.view.scene.contains(this._monsterPath))
					World.instance.view.scene.removeChild(this._monsterPath);
				this._monsterPath = this._monster.getPathMesh();
				if(this._monsterPath != null)
					World.instance.view.scene.addChild(this._monsterPath);
			}
		}
		
		override protected function resize($e:Event = null):void 
		{
			//super.resize($e);
			// do nothing, VERY intentional
		}
	}
}