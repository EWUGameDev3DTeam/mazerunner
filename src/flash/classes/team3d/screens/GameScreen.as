package team3d.screens
{
	import away3d.cameras.Camera3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPRigidBody;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.builders.MazeBuilder;
	import team3d.controllers.FirstPersonCameraController;
	import team3d.controllers.FlyController;
	import team3d.objects.maze.Maze;
	import team3d.objects.players.HumanPlayer;
	import team3d.objects.World;
	import com.jakobwilson.Cannon.Shot;
	import com.jakobwilson.Cannon.Cannon;
	import away3d.primitives.CubeGeometry;
	import away3d.tools.helpers.data.MeshDebug;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import org.flintparticles.threeD.renderers.Camera;
	import team3d.bases.BasePlayer;
	import team3d.objects.players.KinematicPlayer;
	

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class GameScreen extends Sprite
	{
		/* ---------------------------------------------------------------------------------------- */
		
		private var _floor		:Mesh;
		
		private var _fullscreen	:Boolean;
		
		private var _player		:KinematicPlayer;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object. This screen is ALWAYS visible
		 */
		public function GameScreen()
		{
			super();
			
			//_view = new View3D();
			_fullscreen = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function Begin():void
		{			
			
			World.instance.CurrentScreen = "Game";
			this.addChild(World.instance.view);
			World.instance.Begin();
			
			var rectangle:Shape = new Shape;
			rectangle.graphics.beginFill(0xFF00FF);
			rectangle.graphics.drawRect(0, 0, this.width,this.height); 
			rectangle.graphics.endFill();
			addChild(rectangle);
			
			TweenLite.to(rectangle, 2.0, {alpha:0.0});
			
			
			//*
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, true, true), new ColorMaterial(0xFFFFFF));
			//World.instance.view.scene.addChild(this._floor);
			//Ugly Floor Physics
			this._floor.x = 0;
			this._floor.y = -50;
			this._floor.z = 0;
			var floorCol:AWPBoxShape = new AWPBoxShape(10000, 1, 10000);
			var floorRigidBody:AWPRigidBody = new AWPRigidBody(floorCol, _floor, 0);
			//World.instance.physics.addRigidBody(floorRigidBody);
			floorRigidBody.friction = 1;
			floorRigidBody.position = new Vector3D(_floor.x, _floor.y, _floor.z);
			floorRigidBody.rotation = new Vector3D(_floor.rotationX, _floor.rotationY, _floor.rotationZ);
			World.instance.addObject(floorRigidBody);
			// end ugly physics	
			
			
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
		
			
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			//KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			//World.instance.view.camera = FlyController(_player.Controller).Camera;
			
			createMaze();
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
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		public function End():void
		{
			World.instance.End();
			_player.End();
			_floor = null;
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
			if (!World.instance.stage.mouseLock)
				World.instance.stage.mouseLock = true;
			World.instance.update();
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}