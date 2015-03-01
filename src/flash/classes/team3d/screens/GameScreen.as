package team3d.screens
{
	import adobe.utils.CustomActions;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPRigidBody;
	import com.greensock.events.LoaderEvent;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.builders.MazeBuilder;
	import team3d.controllers.FirstPersonCameraController;
	import team3d.controllers.FlyController;
	import team3d.objects.maze.Maze;
	import team3d.objects.players.HumanPlayer;
	import team3d.objects.World;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class GameScreen extends BaseScreen
	{
		/* ---------------------------------------------------------------------------------------- */
		
		public var PausedSignal		:Signal;
		
		private var _floor			:Mesh;
		
		private var _player			:HumanPlayer;
		
		private var _paused			:Boolean;
		
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
			_paused = false;
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
			
			_player = new HumanPlayer(World.instance.view.camera);
			World.instance.addObject(_player.rigidbody);
			// start the player, this also starts the HumanController associated with it
			_player.Begin();
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			World.instance.view.camera = FlyController(_player.Controller).Camera;
			
			createMaze();
			
			if (World.instance.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				World.instance.stage.mouseLock = true;
			
			KeyboardManager.instance.addKeyUpListener(KeyCode.F, failedGame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.G, wonGame);
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
			var startx:Number = _floor.position.x - boardwidth * 0.5;
			var startz:Number = _floor.position.z - boarddepth * 0.5;
				
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			var maze:Maze = MazeBuilder.instance.Build(rows, cols, startx, startz, wall);
			World.instance.addMaze(maze);
		}
		
		public function Unpause()
		{
			lockMouse(true);
			_paused = false;
		}
		
		public function Pause()
		{
			_paused = true;
		}
		
		protected function pauseGame():void
		{
			if (_paused) return;
			
			this.PausedSignal.dispatch();
			lockMouse(false);
		}
		
		private function lockMouse($state:Boolean):void
		{
			if(World.instance.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				World.instance.stage.mouseLock = $state;
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
			
			lockMouse(false);
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
			
			_player.Controller.Begin();
		}
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
		{
			if (_paused) return;
			
			if (World.instance.stage.displayState == StageDisplayState.NORMAL)
			{
				pauseGame();
				return;
			}
			
			World.instance.update();
		}
		

		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		override protected function destroy($e:LoaderEvent = null):void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
				
			super.destroy();
		}
		
	}
}