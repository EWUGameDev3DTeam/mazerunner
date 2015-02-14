package team3d.screens
{
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
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
		/** the fps camera controller */
		private var _fpc		:FirstPersonController;
		
		private var _fullscreen	:Boolean;
		
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
			
			//this._cube = new Mesh(new CubeGeometry(), new ColorMaterial(0xFF0000));
			//this._view.scene.addChild(this._cube);
			//this._cube.x = 0;
			//this._cube.y = 0;
			//this._cube.z = 0;
			
			this._greenCube = new Mesh(new CubeGeometry(), new ColorMaterial(0x00FF00));
			this._greenCube.x = 200;
			this._greenCube.y = 300;
			this._greenCube.z = 50;
			this._view.scene.addChild(this._greenCube);
			
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, false), new ColorMaterial(0xFFFFFF));
			this._view.scene.addChild(this._floor);
			this._floor.x = 0;
			this._floor.y = 0;
			this._floor.z = -50;
			this._floor.rotationX += 180;
			
			this._view.camera.z = 0;
			this._view.camera.y = 1000;
			this._view.camera.z = 50;
			this._view.camera.lookAt(new Vector3D());
			
			this._fpc = new FirstPersonController(this._view.camera);
			_fpc.maxTiltAngle = 180;
			_fpc.minTiltAngle = 0;
			
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
				//World.instance.stage.mouseLock = true;
				//World.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
			else
			{
				trace("leaving full screen");
				World.instance.stage.displayState = StageDisplayState.NORMAL;
				//World.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
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

