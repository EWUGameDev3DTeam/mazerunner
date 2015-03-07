package team3d.screens
{
	import adobe.utils.CustomActions;
	import away3d.core.math.Vector3DUtils;
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
	import com.jakobwilson.Trigger3D;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.builders.MazeBuilder;
	import team3d.objects.maze.Maze;
	import team3d.objects.players.FlyPlayer;
	import team3d.objects.players.KinematicPlayer;
	import team3d.objects.World;
	

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class TutorialScreen extends BaseScreen
	{
		/* ---------------------------------------------------------------------------------------- */
		
		public var PausedSignal			:Signal;
		
		private var _paused				:Boolean;
		
		private var _controlsEnabled	:Boolean;

		private var _player				:KinematicPlayer;
		
		private var _flyPlayer			:FlyPlayer;
		
		private var _elevatorDown		:Trigger3D;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the GameScreen object. This screen is ALWAYS visible
		 */
		public function TutorialScreen()
		{
			super();
			
			_screenTitle = "Tutorial";
			_flyPlayer = new FlyPlayer();
			
			DoneSignal = new Signal();
			PausedSignal = new Signal();
			
			_elevatorDown = new Trigger3D(1000, 20);
			_elevatorDown.TriggeredSignal.add(goDown);
		}
		
		private function goDown($a:Asset):void
		{
			trace("blah");
			DebugScreen.Text("near player");
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
			
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			//			TEMPORARY KEY BINDINGS*/
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			//World.instance.view.camera = FlyController(_player.Controller).Camera;
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			
			
			//Create player
			_player = new KinematicPlayer(World.instance.view.camera, 300,100,0.4);
			_player.addToWorld(World.instance.view, World.instance.physics);
			_player.controller.warp(new Vector3D(0, 10000, 0));
			_player.Begin();
			//end player
			
			// elevator movement
			_elevatorDown.addObjectActivator(_player.controller.ghostObject);
			
			var rectangle:Shape = new Shape;
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, this.width, this.height);
			rectangle.graphics.endFill();
			this.addChild(rectangle);
			
			createTutorial();
			//toggleCamera();
		}
		
		private function createTutorial():void
		{
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			var floor:Asset = AssetManager.instance.getAsset("Floor");
			
			Bounds.getMeshBounds(floor.model);
			var floorWidth:Number = Bounds.width;
			var floorHeight:Number = Bounds.height;
			var floorDepth:Number = Bounds.depth;
			
			var startx:Number = _player.x + _player.width * 0.5 - floorWidth * 2;
			var startz:Number = _player.z + _player.width * 0.5 - floorWidth * 2;
			
			floorgen(floor, startx, startz, floorWidth);
			wallgen(wall, startx, startz, floorWidth);
			innerWalls(wall, startx, startz, floorWidth);
			
			//create a cannon
			var cannon:Cannon = new Cannon(AssetManager.instance.getCopy("Cannon"), AssetManager.instance.getCopy("CannonBall"));
			cannon.addObjectActivator(this._player.controller.ghostObject);
			cannon.transformTo(new Vector3D(70,200,0));
			cannon.rotateTo(new Vector3D(0,110,0));
			cannon.addToScene(World.instance.view, World.instance.physics);
			//End cannon creation
			
			// load monster
			var monster:Asset = AssetManager.instance.getCopy("Monster");
			monster.transformTo(new Vector3D(startx + floorWidth, 200, startz + floorWidth));
			World.instance.addObject(monster);
			
			// create the cage
			var cage:Asset = AssetManager.instance.getCopy("Cage");
			cage.transformTo(new Vector3D(startx, 0, startz));
			World.instance.addObject(cage);
			_elevatorDown.position = cage.model.position;
			cage.model.addChild(_elevatorDown);
			_elevatorDown.begin();
		}
		
		private function floorgen($floor:Asset, $startx:Number, $startz:Number, $width:Number):void
		{
			var tile:Asset;
			for (var row:int = 0; row < 3; row++)
			{
				for (var col:int = 0; col < 3; col++)
				{
					if (row == 0 && col == 0) continue;
					
					tile = $floor.clone();
					tile.transformTo(new Vector3D($startx + row * $width, 0, $startz + col * $width));
					World.instance.addObject(tile);
				}
			}
		}
		
		private function wallgen($wall:Asset, $startx:Number, $startz:Number, $width:Number):void
		{
			var tile:Asset;
			for (var row:int = 0; row < 3; row++)
			{
				tile = $wall.clone();
				tile.transformTo(new Vector3D($startx + row * $width, 0, $startz - $width * 0.5 + 3 * $width));
				tile.rotateTo(new Vector3D(0, 90, 0));
				World.instance.addObject(tile);
				
				tile = $wall.clone();
				tile.transformTo(new Vector3D($startx + row * $width, 0, $startz - $width * 0.5));
				tile.rotateTo(new Vector3D(0, 90, 0));
				World.instance.addObject(tile);
				
				tile = $wall.clone();
				tile.transformTo(new Vector3D($startx - $width * 0.5 + 3 * $width, 0, $startz + row * $width));
				World.instance.addObject(tile);
				
				tile = $wall.clone();
				tile.transformTo(new Vector3D($startx - $width * 0.5, 0, $startz + row * $width));
				World.instance.addObject(tile);
			}
		}
		
		private function innerWalls($wall:Asset, $startx:Number, $startz:Number, $width:Number):void
		{
			var tile:Asset;
			
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width - $width * 0.5, 0, $startz + $width));
			World.instance.addObject(tile);
			
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width + $width * 0.5, 0, $startz + $width));
			World.instance.addObject(tile);
			
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width, 0, $startz + $width + $width * 0.5));
			tile.rotateTo(new Vector3D(0, 90, 0));
			World.instance.addObject(tile);
			
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width, 0, $startz + $width - $width * 0.5));
			tile.rotateTo(new Vector3D(0, 90, 0));
			World.instance.addObject(tile);
		}
		
		public function Unpause():void{_paused = false;}
		public function Pause():void{_paused = true;}
		
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
			_player.End();
			_flyPlayer.End();
			
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
			if (World.instance.view.camera == _player.Camera)
			{
				_player.End();
				_flyPlayer.Begin();
				World.instance.view.camera = _flyPlayer.Controller.Camera;
			}
			else
			{
				_flyPlayer.End();
				_player.Begin();
				World.instance.view.camera = _player.Camera;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 */
		protected function enterFrame($e:Event):void
		{
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