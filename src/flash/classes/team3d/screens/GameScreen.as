package team3d.screens
{
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
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
	import team3d.objects.players.HumanPlayer;
	import team3d.utils.World;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class GameScreen extends Sprite
	{
		/* ---------------------------------------------------------------------------------------- */
		
		/** view object that holds the scene and camera */
		private var _view		:View3D;
		/** a cube mesh model */
		private var _cube		:Mesh;
		/** a green cube model */
		private var	_greenCube	:Mesh;
		/** a plane mesh model */
		private var _floor		:Mesh;
		
		private var _fullscreen	:Boolean;
		
		private var _player		:HumanPlayer;
		/* The physics world */
		private var _world		:AWPDynamicsWorld;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object. This screen is ALWAYS visible
		 */
		public function GameScreen()
		{
			super();
			
			World.instance.stage.addEventListener(Event.RESIZE, windowResize);
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, toggleFullscreen);
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			_view = new View3D();
			_fullscreen = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function Begin():void
		{
			this.addChild(_view);
			
			//Set up the physics world
			this._world = AWPDynamicsWorld.getInstance();
			this._world.initWithDbvtBroadphase();
			this._world.gravity = new Vector3D(0,0,-1);//move gravity to pull down on z axis
			
			this._greenCube = new Mesh(new CubeGeometry(), new ColorMaterial(0x00FF00));
			this._greenCube.x = 200;
			this._greenCube.y = 300;
			this._greenCube.z = 50;
			this._view.scene.addChild(this._greenCube);
			
			//ugly Cube hysics
			var cubeShape:AWPBoxShape = new AWPBoxShape(100,100,100);
			var cubeRigidBody:AWPRigidBody = new AWPRigidBody(cubeShape,this._greenCube,1);
			_world.addRigidBody(cubeRigidBody);
			cubeRigidBody.friction = 1;
			cubeRigidBody.position = new Vector3D(this._greenCube.x,this._greenCube.y,this._greenCube.z);
			cubeRigidBody.applyTorque(new Vector3D(0, 1, 1));
			//end ugly physics			
			
			
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, false), new ColorMaterial(0xFFFFFF));
			this._view.scene.addChild(this._floor);
			//Ugly Floor Physics
			var floorCol:AWPBoxShape = new AWPBoxShape(10000,10000,1);
			var floorRigidBody:AWPRigidBody = new AWPRigidBody(floorCol,_floor,0);
			_world.addRigidBody(floorRigidBody);
			floorRigidBody.friction = 1;
			floorRigidBody.position = new Vector3D(0,0,-50);
			// end ugly physics		
			this._floor.x = 0;
			this._floor.y = 0;
			this._floor.z = -50;
			this._floor.rotationX += 180;
			
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
			
			// player shit
			// basic player model
			var p:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0x0000FF));
			var pShape:AWPBoxShape = new AWPBoxShape(100,100,100);
			var pRigidBody:AWPRigidBody = new AWPRigidBody(pShape, p, 1);
			_world.addRigidBody(cubeRigidBody);
			pRigidBody.friction = 1;
			pRigidBody.position = new Vector3D(p.x, p.y, p.z);
			pRigidBody.applyTorque(new Vector3D(0, 1, 1));
			
			// add the model to the scene
			_view.scene.addChild(p);
			// create a new player and give it the camera and the model
			_player = new HumanPlayer(_view.camera, p);
			// start the player, this also starts the HumanController associated with it
			_player.Begin();
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
		*	adds the walls to the game
		*/
		public function initWall(assetType:int, asset:Object)
		{
			if(assetType == AssetBuilder.MESH)
			{
				Mesh(asset).scale(50);
				this._view.scene.addChild(Mesh(asset));
				trace("Added non physics object");
			}
			if(assetType == AssetBuilder.RIGIDBODY)
			{
				
				//apply some scaling, move the wall up and rotate it a little to see the physics
				AWPRigidBody(asset).scale = new Vector3D(50,50,50);
				//AWPRigidBody(asset).position = new Vector3D(0,0,-50);
				AWPRigidBody(asset).rotation = new Vector3D(90,0,0);
				//AWPRigidBody(asset).applyTorque(new Vector3D(0, 8, 8));
				
				
				var cpy:AWPRigidBody;
				for(var i:int = 0;i < 10;i++)
				{
					cpy = AssetBuilder.cloneRigidBody(AWPRigidBody(asset), AssetBuilder.BOX ,AssetBuilder.STATIC);
					cpy.position = new Vector3D(i*260, 0, 0);
					this._view.scene.addChild(cpy.skin);
					this._world.addRigidBody(cpy);
				}
				
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
			_world.step(1/30, 1, 1/30);
			_view.render();
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

