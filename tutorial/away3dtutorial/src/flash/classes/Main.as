package 
{
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	
	/**
	 * Drives the project.
	 * 
	 * @author	Nate Chatellier
	 */
	public class Main extends MovieClip
	{
		private var _view	:View3D;
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main object.
		 */
		public function Main()
		{
			KeyboardManager.init(this.stage);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			_view = new View3D();
			
			var plane:Mesh = new Mesh(new PlaneGeometry(10000, 10000, 1, 1), new ColorMaterial(0xFFFFFF));
			_view.scene.addChild(plane);
			
			_view.camera.y = 100;
			_view.camera.lookAt(new Vector3D());
			
			var redCube:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0xFF0000));
			redCube.x = 100;
			redCube.y = 200;
			redCube.z = 100;
			_view.scene.addChild(redCube);
			
			var greenCube:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0x00FF00));
			greenCube.x = -200;
			greenCube.y = 100;
			greenCube.z = -400;
			_view.scene.addChild(greenCube);
			
			this.addChild(_view);
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			this.stage.addEventListener(Event.RESIZE, stageResize);
			KeyboardManager.instance.addKeyUpListener(KeyCode.F, toggleFullScreen);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Changes the size of the view to the size of the stage.
		 *
		 * @param	$e	Unused event object
		 */
		private function stageResize($e:Event):void
		{
			_view.width = this.stage.stageWidth;
			_view.height = this.stage.stageHeight;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Toggles between Normal and FullScreenInteractive Modes
		 */
		private function toggleFullScreen():void
		{
			if (this.stage.displayState == StageDisplayState.NORMAL)
			{
				this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			else
			{
				this.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * This is main's enterFrame event handler
		 *
		 * @param	$e	unused event object
		 */
		private function enterFrame($e:Event):void
		{
			var speed:Number = 10;
			// move forward
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				_view.camera.moveForward(speed);
			}
			// move backward
			else if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				_view.camera.moveBackward(speed);
			}
			
			// strafe left
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
			{
				_view.camera.moveLeft(speed);
			}
			// strafe right
			else if (KeyboardManager.instance.isKeyDown(KeyCode.D))
			{
				_view.camera.moveRight(speed);
			}
			
			_view.render();
		}
	}
}