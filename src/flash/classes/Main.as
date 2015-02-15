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
	import flash.display.Sprite;
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
	import team3d.screens.GameScreen;
	import team3d.screens.TitleScreen;
	import team3d.utils.World;
	
	import com.jakobwilson.Model3D;
	
	/**
	 * drive class for Operation Silent Badger
	 *
	 * @author Johnathan McNutt
	 */
	//[SWF(width = 640, height = 480, frameRate = 60)]
	public class Main extends Sprite
	{
		private var _textField:TextField = new TextField();
		
		private var	_titleScreen	:TitleScreen;
		private var _gameScreen		:GameScreen;
		
		/**
		 * Constructs the Main class.
		 */
		public function Main()
		{
			KeyboardManager.init(this.stage);
			World.instance.stage = this.stage;
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
			_titleScreen = new TitleScreen();
			_gameScreen = new GameScreen();
			
			this.addChild(_gameScreen);
			this.addChild(_titleScreen);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * when main is added to the stage
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
			this.addChild(_textField);
			
            World.instance.stage.scaleMode = StageScaleMode.NO_SCALE;
			World.instance.stage.align = StageAlign.TOP_LEFT;
			
			_gameScreen.Begin();
			_titleScreen.Begin();
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
			if (World.instance.stage.mouseLock)
			{
				this._textField.appendText("Movement( X:" + $e.movementX + "Y:" + $e.movementY + ")");
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