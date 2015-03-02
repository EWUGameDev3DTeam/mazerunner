package team3d.screens
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPRigidBody;
	import com.greensock.events.LoaderEvent;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import com.jakobwilson.Cannon.Cannon;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.builders.MazeBuilder;
	import team3d.objects.maze.Maze;
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
		
		private var _floor				:Mesh;
		
		//private var _player			:HumanPlayer;
		
		private var _paused				:Boolean;
		
		private var _controlsEnabled	:Boolean;

		private var _player				:KinematicPlayer;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object. This screen is ALWAYS visible
		 */
		public function GameScreen()
		{
			super();
			
			_screenTitle = "Game";
			
			
			DoneSignal = new Signal(Boolean);
			PausedSignal = new Signal();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		override public function Begin():void
		{
			super.Begin();
			World.instance.Begin();
			this.addChild(World.instance.view);
			this.visible = true;
			this.alpha = 0;
			
			_controlsEnabled = false;
			_paused = false;
			
			/*
			var rectangle:Shape = new Shape;
			rectangle.graphics.beginFill(0xFF00FF);
			rectangle.graphics.drawRect(0, 0, this.width,this.height); 
			rectangle.graphics.endFill();
			addChild(rectangle);
			
			TweenLite.to(rectangle, 2.0, {alpha:0.0});
			*/
			
			//*
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, true, true), new ColorMaterial(0xFFFFFF));
			this._floor.x = 0;
			this._floor.y = -50;
			this._floor.z = 0;
			var floorCol:AWPBoxShape = new AWPBoxShape(10000, 1, 10000);
			var floorRigidBody:AWPRigidBody = new AWPRigidBody(floorCol, _floor, 0);
			floorRigidBody.friction = 1;
			floorRigidBody.position = new Vector3D(_floor.x, _floor.y, _floor.z);
			floorRigidBody.rotation = new Vector3D(_floor.rotationX, _floor.rotationY, _floor.rotationZ);
			World.instance.addObject(floorRigidBody);
			
			//_player = new HumanPlayer(World.instance.view.camera);
			//World.instance.addObject(_player.rigidbody);
			// start the player, this also starts the HumanController associated with it
			//_player.Begin();
			
			createMaze();
			
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			KeyboardManager.instance.addKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.G, wonGame);
			//			TEMPORARY KEY BINDINGS*/
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			//World.instance.view.camera = FlyController(_player.Controller).Camera;
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			
			
			//Create player
			_player = new KinematicPlayer(World.instance.view.camera, 300,100,0.5);
			_player.addToWorld(World.instance.view, World.instance.physics);
			_player.controller.warp(new Vector3D(0, 10000, 0));
			_player.Begin();
			//end player
			
			//create a cannon
			var cannon:Cannon = new Cannon(AssetManager.instance.getCopy("Cannon"), AssetManager.instance.getCopy("CannonBall"));
			cannon.addObjectActivator(this._player.controller.ghostObject);
			cannon.transformTo(new Vector3D(70,200,0));
			cannon.rotateTo(new Vector3D(0,0,0));
			cannon.addToScene(World.instance.view, World.instance.physics);
			//End cannon creation
			
			//_player = new HumanPlayer(World.instance.view.camera);
			//World.instance.addObject(_player.rigidbody);
			// start the player, this also starts the HumanController associated with it
			//_player.Begin();
			
			//KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			//World.instance.view.camera = FlyController(_player.Controller).Camera;
			
			var rectangle:Shape = new Shape;
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, this.width, this.height);
			rectangle.graphics.endFill();
			this.addChild(rectangle);
			
			//TweenMax.fromTo(rectangle, 2, { autoAlpha: 1 }, { autoAlpha:0, onComplete:enableControls, delay:1 } );
		}
		
		private function enableControls($e:LoaderEvent = null)
		{
			_player.Begin();
		}
		
		private function failedGame():void
		{
			this.DoneSignal.dispatch(false);
		}
		
		private function wonGame():void
		{
			this.DoneSignal.dispatch(true);
		}
		
		private function createMaze()
		{
			var rows:int = 10;
			var cols:int = 10;
				
			Bounds.getMeshBounds(_floor);
			var boardwidth:Number = Bounds.width;
			var boardheight:Number = Bounds.height;
			var boarddepth:Number = Bounds.depth;
			var startx:Number = _floor.position.x - boardwidth * 0.75;
			var startz:Number = _floor.position.z - boarddepth * 0.75;
				
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			var maze:Maze = MazeBuilder.instance.Build(rows, cols, startx, startz, wall);
			World.instance.addMaze(maze);
		}
		
		public function Unpause()
		{
			_paused = false;
			//World.instance.lockMouse();
		}
		
		public function Pause()
		{
			_paused = true;
			//World.instance.unlockMouse();
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
			KeyboardManager.instance.removeKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.removeKeyUpListener(KeyCode.G, wonGame);
			_player.End();
			_floor = null;
			
			World.instance.End();
			super.End();
			
			World.instance.unlockMouse();
			
			this.removeChild(World.instance.view);
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
			/*
			_player.Controller.End();
			
			if (_player.Controller is FirstPersonCameraController)
			{
				_player.Controller = HumanPlayer.FLYController;
				World.instance.view.camera = FlyController(_player.Controller).Camera
			}
			else
			{
				_player.Controller = HumanPlayer.FPCController;
				World.instance.view.camera = FirstPersonCameraController(HumanPlayer.FPCController).Camera;
			}
			
			_player.Controller.Begin();*/
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
		{
			DebugScreen.Text("pause: " + _paused);
			DebugScreen.Text("displayState: " + World.instance.displayState, true);
			DebugScreen.Text("mouseLock: " + World.instance.isMouseLocked, true);
			
			if (_paused) return;
			
			if (World.instance.isNormal || !World.instance.isMouseLocked)
			{
				pauseGame();
				return;
			}
			
			World.instance.update();
		}
	}
}