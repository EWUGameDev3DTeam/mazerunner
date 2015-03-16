package team3d.screens
{
	import adobe.utils.CustomActions;
	import away3d.cameras.Camera3D;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import com.greensock.TweenMax;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import com.jakobwilson.Cannon.Cannon;
	import com.jakobwilson.Trigger3D;
	import com.natejc.input.KeyboardManager;
	import com.natejc.input.KeyCode;
	import flash.display.Shape;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.factory.CannonFactory;
	import team3d.objects.players.FlyPlayer;
	import team3d.objects.players.KinematicPlayer;
	import team3d.objects.World;
	import treefortress.sound.SoundAS;
	

	
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
		private var _goingDown			:Boolean;
		private var _cage				:Asset;
		private var _cannons			:Vector.<Cannon>;
		private var _tutorialText		:TextField;
		private var _mob				:Asset;
		
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
			
			_elevatorDown = new Trigger3D(400);
			_elevatorDown.TriggeredSignal.add(goDown);
			_cannons = new Vector.<Cannon>();
			
			var textFormat:TextFormat = new TextFormat(null, 30, 0x00FF00, true, true, null, null, null, TextFormatAlign.CENTER);
			_tutorialText = new TextField();
			_tutorialText.defaultTextFormat = textFormat;
			_tutorialText.autoSize = TextFieldAutoSize.CENTER;
			_tutorialText.text = "tutorial text";
			this.addChild(_tutorialText);
		}
		
		private function goDown($a:Asset):void
		{
			if(!SoundAS.getSound("Elevator").isPlaying)
				SoundAS.playFx("Elevator", .7);
			
			if (_goingDown) return;
			_goingDown = true;
			_player.canWalk = false;
			TweenMax.fromTo(this.getChildByName("rectangleFade"), 2, { autoAlpha:0 }, { autoAlpha:1, onComplete:DoneSignal.dispatch } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		override public function Begin():void
		{
			//trace(_screenTitle + " starting");
			super.Begin();
			World.instance.Begin();
			this.addChild(World.instance.view);
			
			_goingDown = false;
			_controlsEnabled = false;
			_paused = false;
			
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.addKeyUpListener(KeyCode.T, toggleCamera, true);
			//			TEMPORARY KEY BINDINGS*/
			
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			KeyboardManager.instance.addKeyUpListener(KeyCode.P, pauseGame);
			
			//Create player
			//if (_player == null)
			var cam:Camera3D = new Camera3D();
			_player = new KinematicPlayer(cam, 300, 100, 0.4);
			_player.addToWorld(World.instance.view, World.instance.physics);
			_player.controller.warp(new Vector3D(0, 500, 0));
			_player.Begin();
			
			_flyPlayer.Controller.Camera.position.x = _player.controller.ghostObject.position.x;
			_flyPlayer.Controller.Camera.position.y = _player.controller.ghostObject.position.y + 300;
			_flyPlayer.Controller.Camera.position.z = _player.controller.ghostObject.position.z;
			
			World.instance.view.camera = cam;
			//end player
			
			// elevator movement
			_elevatorDown.addObjectActivator(_player.controller.ghostObject);
			createTutorial();
			//toggleCamera();
			
			var rectangle:Shape = new Shape;
			rectangle.name = "rectangleFade";
			rectangle.graphics.beginFill(0x000000);
			rectangle.graphics.drawRect(0, 0, this.width, this.height);
			rectangle.graphics.endFill();
			rectangle.visible = false;
			this.addChild(rectangle);
		}
		
		private function createTutorial():void
		{
			var wall:Asset = AssetManager.instance.getAsset("Wall");
			var floor:Asset = AssetManager.instance.getAsset("Floor");
			var skyBox:Asset = AssetManager.instance.getAsset("Sky");
			
			skyBox.addToScene(World.instance.view, World.instance.physics);
			
			Bounds.getMeshBounds(floor.model);
			var floorWidth:Number = Bounds.width;
			var floorHeight:Number = Bounds.height;
			var floorDepth:Number = Bounds.depth;
			
			var startx:Number = _player.x + _player.width * 0.5 - floorWidth * 2;
			var startz:Number = _player.z + _player.width * 0.5 - floorWidth * 2;
			
			floorgen(floor, startx, startz, floorWidth);
			wallgen(wall, startx, startz, floorWidth);
			innerWalls(wall, startx, startz, floorWidth);
			addCannons(startx, startz, floorWidth);
			
			// load monster
			_mob = AssetManager.instance.getCopy("Monster");
			_mob.transformTo(new Vector3D(startx + floorWidth, 200, startz + floorWidth));
			World.instance.addObject(_mob);
			
			// create the cage
			_cage = AssetManager.instance.getCopy("Cage");
			_cage.transformTo(new Vector3D(startx, 0, startz));
			World.instance.addObject(_cage);
			
			_elevatorDown.position = _cage.model.position;
			_cage.model.addChild(_elevatorDown);
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
			/*
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width + $width * 0.5, 0, $startz + $width));
			World.instance.addObject(tile);
			*/
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width, 0, $startz + $width + $width * 0.5));
			tile.rotateTo(new Vector3D(0, 90, 0));
			World.instance.addObject(tile);
			
			tile = $wall.clone();
			tile.transformTo(new Vector3D($startx + $width, 0, $startz + $width - $width * 0.5));
			tile.rotateTo(new Vector3D(0, 90, 0));
			World.instance.addObject(tile);
		}
		
		private function addCannons($startx:Number, $startz:Number, $floorWidth:Number)
		{
			var ninety:Vector3D = new Vector3D(0, 90, 0);
			var ghost:AWPGhostObject = _player.controller.ghostObject;
			var xloc:Number = $startx + $floorWidth;
			var zloc:Number = $startz + $floorWidth * 1.5 + 50;
			for (var i:int = -1; i < 2; i++)
				_cannons.push(CannonFactory.instance.create(new Vector3D(xloc + 200 * i, 200, zloc), new Vector3D(), ghost));
		}
		
		public function Unpause():void
		{
			_paused = false;
			World.instance.Resume();
		}
		public function Pause():void
		{
			_paused = true;
			World.instance.Pause();
		}
		
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
			//*			TEMPORARY KEY BINDINGS
			KeyboardManager.instance.removeKeyUpListener(KeyCode.T, toggleCamera);
			//			TEMPORARY KEY BINDINGS*/
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
			KeyboardManager.instance.removeKeyUpListener(KeyCode.P, pauseGame);
			
			_player.End();
			_flyPlayer.End();
			_elevatorDown.end();
			while (_cannons.length > 0)
				_cannons.pop().End();
			
			SoundAS.pause("title");
			
			//this.removeChild(World.instance.view);
			this.removeChild(this.getChildByName("rectangleFade"));
			
			World.instance.End();
			super.End();
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
			
			if (_goingDown)
			{
				_cage.rigidBody.y -= 10;
			}
			
			checkDistance();
			
			World.instance.update();
		}
		
		private function checkDistance():void
		{
			var x:Number = _mob.position.x - _player.controller.ghostObject.x;
			var y:Number = _mob.position.y - _player.controller.ghostObject.y;
			var z:Number = _mob.position.z - _player.controller.ghostObject.z;
			var mobDist:Number = Math.sqrt(x * x + y * y + z * z);
			var cannonDist:Number = cannonDist();
			_tutorialText.visible = false;
			if (mobDist < 400)
			{
				_tutorialText.visible = true;
				_tutorialText.text = "This is the monster. Get too close in the maze and it will kill you.";
				_tutorialText.appendText("\nIt also chases you, this is your motivation.");
			}
			else if (cannonDist < 400)
			{
				_tutorialText.visible = true;
				_tutorialText.text = "These are cannons. Their shots will bounce you around.";
				_tutorialText.appendText("\nThey can help but can also hinder.");
			}
		}
		
		
		
		private function cannonDist():Number
		{
			var dist:Number = 0;
			var x:Number = _cannons[0].model.position.x - _player.controller.ghostObject.x;
			var y:Number = _cannons[0].model.position.y - _player.controller.ghostObject.y;
			var z:Number = _cannons[0].model.position.z - _player.controller.ghostObject.z;
			var closest:Number =  Math.sqrt(x * x + y * y + z * z);
			
			for (var i:int = 1; i < _cannons.length; i++)
			{
				x = _cannons[i].model.position.x - _player.controller.ghostObject.x
				y = _cannons[i].model.position.y - _player.controller.ghostObject.y;
				z = _cannons[i].model.position.z - _player.controller.ghostObject.z;
				dist = Math.sqrt(x * x + y * y + z * z);
				if (dist < closest)
					closest = dist;
			}
			
			return closest;
		}
		
		override protected function resize($e:Event = null):void 
		{
			_tutorialText.x = (World.instance.stage.stageWidth - _tutorialText.width) * 0.5;
			_tutorialText.y = 0;
		}
	}
}