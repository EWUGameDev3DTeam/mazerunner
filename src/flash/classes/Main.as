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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	/**
	 * drive class for Operation Silent Badger
	 *
	 * @author Johnathan McNutt
	 */
	[SWF(width = 640, height = 480, frameRate = 60)]
	public class Main extends MovieClip
	{
		/** view object that holds the scene and camera */
		private var _view:View3D;
		/** a cube mesh model */
		private var _cube:Mesh;
		/** a plane mesh model */
		private var _floor:Mesh;
		/** the fps camera controller */
		private var _fpc:FirstPersonController;
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main class.
		 */
		public function Main()
		{
			KeyboardManager.init(this.stage);
			
			this.init();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * inits the Main class
		 */
		private function init():void
		{
			this._view = new View3D();
			this.addChild(_view);
			
			this._cube = new Mesh(new CubeGeometry(), new ColorMaterial(0xFF0000));
			this._view.scene.addChild(this._cube);
			this._cube.x = 0;
			this._cube.y = 0;
			this._cube.z = 0; 
			
			this._floor = new Mesh(new PlaneGeometry(10000, 10000, 1, 1, false), new ColorMaterial(0xFFFFFF));
			this._view.scene.addChild(this._floor);
			this._floor.x = 0;
			this._floor.y = 0;
			this._floor.z = -50;
			this._floor.rotationX += 180;
			
			this._view.camera.z = 0;
			this._view.camera.y = 1000;
			this._view.camera.z = 0;
			this._view.camera.lookAt(new Vector3D());
			
			this._fpc = new FirstPersonController(this._view.camera);
			
			this.addEventListener(Event.ENTER_FRAME, newFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function newFrame($event:Event):void
		{		
			if (KeyboardManager.instance.isKeyDown(KeyCode.W))
			{
				this._view.camera.x += 10 * Math.sin((this._view.camera.rotationZ * Math.PI) / 180);
				this._view.camera.y -= 10 * Math.cos((this._view.camera.rotationZ * Math.PI) / 180);
			}
			if (KeyboardManager.instance.isKeyDown(KeyCode.S))
			{
				this._view.camera.x -= 10 * Math.sin((this._view.camera.rotationZ * Math.PI) / 180);
				this._view.camera.y += 10 * Math.cos((this._view.camera.rotationZ * Math.PI) / 180);
			}
			if (KeyboardManager.instance.isKeyDown(KeyCode.A))
				this._view.camera.rotationZ -= 3;
			if (KeyboardManager.instance.isKeyDown(KeyCode.D))
				this._view.camera.rotationZ += 3;
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