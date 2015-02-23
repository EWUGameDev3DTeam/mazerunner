package team3d.screens
{
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPRigidBody;
	import com.jakobwilson.AssetBuilder;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.builders.MazeBuilder;
	import team3d.objects.maze.Maze;
	import team3d.objects.players.HumanPlayer;
	import team3d.objects.World;

	
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
		
		private var _player		:HumanPlayer;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object. This screen is ALWAYS visible
		 */
		public function GameScreen()
		{
			super();
			
			//World.instance.stage.addEventListener(Event.RESIZE, windowResize);
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, toggleFullscreen);
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			//_view = new View3D();
			_fullscreen = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function Begin():void
		{
			//this.addChild(_view);
			this.addChild(World.instance.view);
			World.instance.Begin();
			
			//*
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, false), new ColorMaterial(0xFFFFFF));
			//World.instance.view.scene.addChild(this._floor);
			//Ugly Floor Physics
			var floorCol:AWPBoxShape = new AWPBoxShape(10000, 10000, 1);
			var floorRigidBody:AWPRigidBody = new AWPRigidBody(floorCol, _floor, 0);
			//World.instance.physics.addRigidBody(floorRigidBody);
			floorRigidBody.friction = 1;
			floorRigidBody.position = new Vector3D(0, 0, -50);
			// end ugly physics		
			this._floor.x = 0;
			this._floor.y = 0;
			this._floor.z = -50;
			this._floor.rotationX += 180;
			World.instance.addObject(floorRigidBody);
			//*/
			
			//Make a wall
			var wallBuilder:AssetBuilder = new AssetBuilder();	//create the assetBuilder
			wallBuilder.assetReadySignal.add(this.initWall);	// add the initwall signal
			wallBuilder.load("Models/Wall/WallSegment.awd", AssetBuilder.BOX, AssetBuilder.STATIC);	//load the wall with a box collider and Dynamic physics
			
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.background = true;
			tf.backgroundColor = 0xFFFFFF;
			tf.border = true;
			tf.borderColor = 0xCC0066;
			tf.visible = true;
			tf.alpha = 1;
			
			tf.x = tf.y = 125;
			tf.text = "This is in the game screen";
			this.addChild(tf);
			
			_player = new HumanPlayer(World.instance.view.camera);
			World.instance.addObject(_player.rigidbody);
			// start the player, this also starts the HumanController associated with it
			_player.Begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		/**
		*	adds the walls to the game
		*/
		public function initWall(assetType:int, asset:Object)
		{
			if(assetType == AssetBuilder.MESH)
			{
				Mesh(asset).scale(50);
				World.instance.view.scene.addChild(Mesh(asset));
				trace("Added non physics object");
			}
			
			if(assetType == AssetBuilder.RIGIDBODY)
			{
				
				//apply some scaling, move the wall up and rotate it a little to see the physics
				AWPRigidBody(asset).scale = new Vector3D(50,50,50);
				//AWPRigidBody(asset).position = new Vector3D(0,0,-50);
				AWPRigidBody(asset).rotation = new Vector3D(90,0,0);
				//AWPRigidBody(asset).applyTorque(new Vector3D(0, 8, 8));
				
				var rows:int = 7;
				var cols:int = rows + 3;
				
				Bounds.getMeshBounds(_floor);
				var boardwidth:Number = Bounds.width;
				var boardheight:Number = Bounds.height;
				var boarddepth:Number = Bounds.depth;
				var startx:Number = _floor.position.x - boardwidth * 0.5;
				var starty:Number = _floor.position.y - boardheight * 0.5;
				
				var maze:Maze = MazeBuilder.instance.Build(rows, cols, startx, starty, AWPRigidBody(asset));
				World.instance.addMaze(maze);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * toggles the full screen settings
		 */
		protected function toggleFullscreen():void
		{
			_fullscreen = !_fullscreen;
			if (_fullscreen)
			{
				trace("going full screen");
				World.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				World.instance.stage.mouseLock = true;
			}
			else
			{
				trace("leaving full screen");
				World.instance.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
		{
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