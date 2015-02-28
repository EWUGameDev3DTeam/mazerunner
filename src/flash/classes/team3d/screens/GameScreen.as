package team3d.screens
{
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.data.AWPCollisionFlags;
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
	import com.jakobwilson.AssetBuilder;
	import com.jakobwilson.Asset;
	
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.OutlineMethod;
	import away3d.Away3D;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	import com.jakobwilson.AssetManager;
	import com.jakobwilson.AssetManager;

	
	
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
		
		private var ghostObject:AWPGhostObject;
		
		private var _character:AWPKinematicCharacterController ;
		
		private var ASM:AssetManager;
		
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
			this._world.gravity = new Vector3D(0,-1,0);//move gravity to pull down on z axis

			//enqueue each item with the following params:(name, filename, collision type(Asset.[NONE, BOX, SPHERE]), physics type (Asset.[STATIC, DYNAMIC]))
			AssetManager.instance.enqueue("Wall", "Models/Wall/WallSegment.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Floor", "Models/Floor/Floor.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Cage", "Models/Cage/Cage.awd", Asset.BOX, Asset.DYNAMIC);
			
			AssetManager.instance.load(this.onProgress, this.onComplete);
			
			
			// player shit
			// basic player model
			var p:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0x0000FF));
			//var pShape:AWPBoxShape = new AWPBoxShape(1,1,1);
			//var pRigidBody:AWPRigidBody = new AWPRigidBody(pShape, p, 1);
			//_world.addRigidBody(pRigidBody);
			//pRigidBody.friction = 1;
			//pRigidBody.position = new Vector3D(p.x, p.y, p.z);
			//pRigidBody.applyTorque(new Vector3D(0, 1, 1));
			// add the model to the scene
			//_view.scene.addChild(p);
			// create a new player and give it the camera and the model
			_player = new HumanPlayer(_view.camera, p);
			// start the player, this also starts the HumanController associated with it
			_player.Begin();
						
						
			//get the asset manager			
						
			
			//Make a character controller
			/*var shape:AWPCapsuleShape = new AWPCapsuleShape(150, 500);
			ghostObject = new AWPGhostObject(shape, _view.camera);
			ghostObject.collisionFlags = AWPCollisionFlags.CF_CHARACTER_OBJECT;

			 _character = new AWPKinematicCharacterController(ghostObject, 1);
			_character.setWalkDirection(new Vector3D(0,1,0));
			_character.ghostObject.position = new Vector3D(0, 5000, -500);
			this._world.addCharacter(_character);*/
			
		}
		
		public function onProgress(x:Number)
		{
			trace("Progress: " + x);
		}
		
		public function onComplete()
		{
			
			AssetManager.instance.getAsset("Cage").addToScene(this._view, this._world);			//NOTE: if you try to get and asset that hasn't been loaded, you will get a null
			AssetManager.instance.getAsset("Cage").transformTo(new Vector3D(0,5000,0));			//Note: we are translating the original asset since we used getAsset()
			AssetManager.instance.getAsset("Cage").rigidBody.applyTorque(new Vector3D(0,10,10));//gets the rigidbody from the asset(read only) and applies torque
			
			
			
			//Creates a simple grid with a floor and walls
			var cur:Asset;	//An asset reference
			for(var i:int = 0;i < 5; i++)		//if you don't know what this does, go get more coffee
			{
				for(var j:int = 0;j < 5; j++)
				{
					cur = AssetManager.instance.getCopy("Floor");					//getCopy() gets a clone of an asset by name
					cur.transformTo(new Vector3D(j*850 - 2550,0,i*850 - 2550));		//transformTo() moves that asset to a specific location
					cur.addToScene(this._view, this._world);						//addToScene() adds the asset to the view and the physics world(if applicable)
					
					//repeat process for length walls
					cur = AssetManager.instance.getCopy("Wall");	
					cur.transformTo(new Vector3D(j*850 - 2125,0,i*850 - 2550));
					cur.addToScene(this._view, this._world);
					
					//repeat for width walls and apply rotation
					cur = AssetManager.instance.getCopy("Wall");	
					cur.transformTo(new Vector3D(j*850 - 2550,0,i*850 - 2125));
					cur.rotateTo(new Vector3D(0,90,0));								//rotateTo() rotated the asset to a specific rotation
					cur.addToScene(this._view, this._world);
					
				}
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
			//this._character.ghostObject.rotationZ += 20;
			_view.width = World.instance.stage.stageWidth;
			_view.height = World.instance.stage.stageHeight;
		}
		
	/* ---------------------------------------------------------------------------------------- */
		/**
		*	adds the walls to the game
		*/
		public function initFloor(assetType:int, asset:Object)		
		{
			if(assetType == AssetBuilder.MESH)
			{
				Mesh(asset).z = -49;
				Mesh(asset).x = 0;
				Mesh(asset).roll(270);
				
				this._view.scene.addChild(Mesh(asset));
				trace("Added non physics object");
			}
		}
		
		
		
		/* ---------------------------------------------------------------------------------------- */
		/**
		*	adds the walls to the game
		*/
		public function initWall(assetType:int, asset:Object)
		{
			if(assetType == AssetBuilder.MESH)
			{
				Mesh(asset).z = 0;
				Mesh(asset).x = 0;
				Mesh(asset).roll(270);
				//the outline method
				var o:OutlineMethod = new OutlineMethod(0xFFFF00,0.01, false);
				//add it
				TextureMaterial(Mesh(asset).material).addMethod(o);
				//remove it
				TextureMaterial(Mesh(asset).material).removeMethod(o);
				
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
				for(var i:int = 0;i < 3;i++)
				{
					cpy = AssetBuilder.cloneRigidBody(AWPRigidBody(asset), AssetBuilder.BOX ,AssetBuilder.STATIC);
					cpy.position = new Vector3D( -425,i*850, -50);
					this._view.scene.addChild(cpy.skin);
					this._world.addRigidBody(cpy);
				}
				
				for(i = 0;i < 5;i++)
				{
					cpy = AssetBuilder.cloneRigidBody(AWPRigidBody(asset), AssetBuilder.BOX ,AssetBuilder.STATIC);
					cpy.rotation = new Vector3D(90,0,90);
					cpy.position = new Vector3D(0, (i*850)-425, -50);
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
		
			/*if(KeyboardManager.instance.isKeyDown(KeyCode.UP))
			{
				this._character.ghostObject.position = new Vector3D
					(this._character.ghostObject.x + Math.sin(this._character.ghostObject.rotationY)*20,
					this._character.ghostObject.y,
					this._character.ghostObject.z + Math.cos(this._character.ghostObject.rotationY)*20);			}
			if(KeyboardManager.instance.isKeyDown(KeyCode.DOWN))
			{
				this._character.ghostObject.position = new Vector3D
					(this._character.ghostObject.x - Math.sin(this._character.ghostObject.rotationY)*20,
					this._character.ghostObject.y,
					this._character.ghostObject.z - Math.cos(this._character.ghostObject.rotationY)*20);
			}
			if(KeyboardManager.instance.isKeyDown(KeyCode.LEFT))
			{
				this._character.ghostObject.rotationY = ((this._character.ghostObject.rotationY - 1) % 359);
				trace(this._character.ghostObject.rotationY)
			}
			if(KeyboardManager.instance.isKeyDown(KeyCode.RIGHT))
			{
				this._character.ghostObject.rotationY = ((this._character.ghostObject.rotationY + 1) % 359);
				trace(this._character.ghostObject.rotationY)
			}
			if(KeyboardManager.instance.isKeyDown(KeyCode.SPACEBAR))
				this._character.jump();*/
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

