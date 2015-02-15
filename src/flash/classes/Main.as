package
{
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import flash.display.MovieClip;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import away3d.containers.View3D;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	import com.jakobwilson.AssetBuilder;
	//physics
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	/**
	 * drive class for Operation Silent Badger
	 *
	 * @author Johnathan McNutt
	 */
	//[SWF(width = 640, height = 480, frameRate = 60)]
	public class Main extends MovieClip
	{
		private var _textField:TextField = new TextField();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/** view object that holds the scene and camera */
		private var _view		:View3D;
		/** a green cube model */
		private var	_greenCube	:Mesh;
		/** a plane mesh model */
		private var _floor		:Mesh;
		/** the fps camera controller */
		private var _fpc		:FirstPersonController;;
		/* The physics world */
		private var _world:AWPDynamicsWorld;
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		private var _fullscreen	:Boolean;
		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main class.
		 */
		public function Main()
		{
			KeyboardManager.init(this.stage);
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
			//this.stage.allowsFullScreen = true;
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, toggleFullscreen);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreen);
			this.addEventListener(Event.ENTER_FRAME, newFrame);
			this.stage.addEventListener(Event.RESIZE, windowResize);
			//this.init();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * when main is added to the stage
		 *
		 * @param	$e	unused event object
		 */
		protected function added($e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, added);
			
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			_textField.defaultTextFormat = format;
			_textField.autoSize = TextFieldAutoSize.LEFT;
            _textField.mouseEnabled = false;
            _textField.selectable = false;
			_textField.textColor = 0x000000;
			_textField.background = true;
			_textField.backgroundColor = 0xFFFFFF;
			_textField.border = true;
			_textField.borderColor = 0xCC0066;
			_textField.visible = true;
			_textField.alpha = 1;
			
			_textField.x = _textField.y = 0;
            _textField.text = "why?!";
			
            this.init();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * inits the Main class
		 */
		private function init():void
		{
			_fullscreen = false;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this._view = new View3D();
			
			//Set up the physics world
			this._world = AWPDynamicsWorld.getInstance();
			this._world.initWithDbvtBroadphase();
			this._world.gravity = new Vector3D(0,0,-1);//move gravity to pull down on z axis

			
			this.addChild(_view);
			this.addChild(_textField);
			
			
						
			this._greenCube = new Mesh(new CubeGeometry(), new ColorMaterial(0x00FF00));
			this._greenCube.x = 200;
			this._greenCube.y = 300;
			this._greenCube.z = 10000;
			this._view.scene.addChild(this._greenCube);
			
			//ugly Cube hysics
			var cubeShape:AWPBoxShape=new AWPBoxShape(100,100,100);
			var cubeRigidBody:AWPRigidBody=new AWPRigidBody(cubeShape,this._greenCube,1);
			_world.addRigidBody(cubeRigidBody);
			cubeRigidBody.friction=1;
			cubeRigidBody.position=new Vector3D(this._greenCube.x,this._greenCube.y,this._greenCube.z);
			cubeRigidBody.applyTorque(new Vector3D(0, 1, 1));
			//end ugly physics			
			
			
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, false), new ColorMaterial(0xFFFFFF));
			this._view.scene.addChild(this._floor);
			//Ugly Floor Physics
			var floorCol:AWPBoxShape=new AWPBoxShape(10000,10000,1);
			var floorRigidBody:AWPRigidBody=new AWPRigidBody(floorCol,_floor,0);
			_world.addRigidBody(floorRigidBody);
			floorRigidBody.friction=1;
			floorRigidBody.position=new Vector3D(0,0,-50);
			// end ugly physics		
			this._floor.x = 0;
			this._floor.y = 0;
			this._floor.z = -50;
			this._floor.rotationX += 180;
			
			//Make a wall
			var wallBuilder:AssetBuilder = new AssetBuilder();	//create the assetBuilder
			wallBuilder.assetReadySignal.add(this.initWall);	// add the initwall signal
			wallBuilder.load("Models/Wall/WallSegment.awd", AssetBuilder.BOX, AssetBuilder.STATIC);	//load the wall with a box collider and Dynamic physics			
			
			//Camera setup
			this._view.camera.z = 0;
			this._view.camera.y = 1000;
			this._view.camera.z = 250;
			this._view.camera.lookAt(new Vector3D());
			
			//_view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
	
			this._fpc = new FirstPersonController(this._view.camera);
			_fpc.maxTiltAngle = 180;
			_fpc.minTiltAngle = 0;
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
		 * 
		 */
		public function newFrame($event:Event):void
		{
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				this._view.camera.x += 10 * Math.sin((this._view.camera.rotationZ * Math.PI) / 180);
				this._view.camera.y -= 10 * Math.cos((this._view.camera.rotationZ * Math.PI) / 180);
			}
			
			// move backward
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				this._view.camera.x -= 10 * Math.sin((this._view.camera.rotationZ * Math.PI) / 180);
				this._view.camera.y += 10 * Math.cos((this._view.camera.rotationZ * Math.PI) / 180);
			}
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				this._view.camera.y -= 10 * Math.sin((this._view.camera.rotationZ * Math.PI) / 180);
				this._view.camera.x -= 10 * Math.cos((this._view.camera.rotationZ * Math.PI) / 180);
			}
			// strafe right
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				this._view.camera.y += 10 * Math.sin((this._view.camera.rotationZ * Math.PI) / 180);
				this._view.camera.x += 10 * Math.cos((this._view.camera.rotationZ * Math.PI) / 180);
			}
			
			_world.step(1/30, 1, 1/30);
			_view.render();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * When the program goes into full screen
		 *
		 * @param	$e	The full screen event
		 */
		protected function fullScreen($e:FullScreenEvent = null):void
		{
			trace("full screen");
			if ($e.fullScreen)
			{
				// do stuff when the game goes full screen
				this.stage.mouseLock = true;
				trace("locking mouse");
			}
			else
			{
				// do stuff when the game leaves full screen
				trace("unlocking mouse");
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
				this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				this.stage.mouseLock = true;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
			else
			{
				trace("leaving full screen");
				this.stage.displayState = StageDisplayState.NORMAL;
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Occurs when the stage is resized
		 *
		 * @param	$e	unused event object
		 */
		private function windowResize(e:Event = null):void 
		{
			_view.width = this.stage.stageWidth;
			_view.height = this.stage.stageHeight;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Event for mouse movments
		 *
		 * @param	$e	Mouse movement event
		 */
		protected function mouseMove($e:MouseEvent):void
		{
			this._textField.text = "Mouse is moving\n";
			if (this.stage.mouseLock)
			{
				this._textField.appendText("Movement( X:" + $e.movementX + "Y:" + $e.movementY + ")");
				
				// move the camera up or down
				this._fpc.tiltAngle += $e.movementY * 0.07;
				// move the camera left or right
				this._view.camera.rotationZ += $e.movementX * 0.1;
			}
			else
				this._textField.appendText("Local( X:" + $e.stageX + "Y:" + $e.stageY + ")");
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