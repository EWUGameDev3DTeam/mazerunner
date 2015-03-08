package  com.jakobwilson
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.geom.Vector3D;
	
	import away3d.entities.Mesh;
	import away3d.events.LoaderEvent;
	import away3d.events.AssetEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.library.assets.AssetType
	import away3d.tools.utils.Bounds;
	import away3d.primitives.SkyBox;
	
	import org.osflash.signals.Signal;
	
	import awayphysics.collision.shapes.AWPCollisionShape;
	import awayphysics.collision.shapes.AWPCompoundShape;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.dynamics.AWPRigidBody;
	import away3d.containers.View3D;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import away3d.tools.helpers.data.MeshDebug;
	import away3d.animators.IAnimator;
	
	
	
	
	/**
	*	A class to represent a single game asset. It handles all of the distinctions between rigidbodies and meshes so the user doesn't have to.
	*	@author Jakob Wilson
	*/
	public class Asset
	{
		/*---------------------------------------CONSTANTS-------------------------------------------------*/
		//static and dynamic constants
		public static const STATIC = 0;
		public static const DYNAMIC = 1;
		
		//Rigidbody type defenitions
		public static const NONE = 0;
		public static const BOX = 1;
		public static const SPHERE = 2;
		public static const CAPSULE = 3;
		public static const CYLINDER = 4;
		public static const CONE = 5;
		
		public static const SKYBOX = 6;
		
		/*---------------------------------------VARIABLES-----------------------------------------------*/		
		
		private var _name:String;									/**< The name of the asset */
		
		private var _modelLoader:Loader3D;							/**< The loader for loading the mesh */
		private var _model:Mesh;									/**< The mesh for this asset */		
		
		private var _skybox:SkyBox;
		
		private var _collisionType:int;								/**< The collision type of the asset - Can be any of the collison type constants(Ex. Asset.BOX)*/
		private var _physicsType:int;								/**< The physics type(STATIC or DYNAMIC)*/
		private var _rigidBody:AWPRigidBody;						/**< The rigidbody(if applicable) for this asset */		
		
		public var assetReadySignal:Signal 	= new Signal(Asset);	/**< a signal to tell when the asset has been loaded */
					
	
		
		/*-------------------------------------CONSTRUCTOR---------------------------------------------*/
		
		
		/**
		*	Creates a new asset and gets its name, collision info, and can be passed a mesh if loading is not wanted
		*/
		public function Asset($name:String, $collisionType:int = NONE, $physicsType:int = STATIC, $model:Mesh = null) 
		{
			this._name = $name;
			this._collisionType = $collisionType;
			this._physicsType = $physicsType;
			this._model = $model;
			if($model != null)
				this.createRigidBody();
		}
		
		
		/*---------------------------------------MOVEMENT-----------------------------------------------*/		
		
		/**
		*	Performs absolute transformation to a point in 3d space
		*	@param Vector3D
		*/
		public function transformTo($t:Vector3D)
		{
			if(this._collisionType == NONE)	//if it is just a mesh
				this._model.position = $t;
			else							//if it is a rigidbody
				this._rigidBody.position = $t;
		}
		
		/**
		* performs an absolute rotation to a rotation in 3d space
		*	@param Vector3D
		*/
		public function rotateTo($t:Vector3D)
		{
			if(this._collisionType == NONE)	//if it is just a mesh
				this._model.rotateTo($t.x, $t.y, $t.z);
			else
				this._rigidBody.rotation = $t;
				
		}
		
		public function scale($t:Vector3D)
		{
			
		}
		
		/*------------------------------------CLONING------------------------------------------------*/		
		
		/**
		* 	creates a shallow copy of the mesh and adds a new rigidbody to it
		*	@return Asset - the clone of this asset
		*/
		public function clone():Asset
		{
			return new Asset(this._name, this._collisionType, this._physicsType, Mesh(this._model.clone()));
		}
		
		
		/*---------------------------------------LOADING----------------------------------------------*/
		/**
		*	Loads a mesh from a .awd file
		*	@param String The file we want to load
		*/
		public function load(fileName:String)
		{
			Parsers.enableAllBundled();
			this._modelLoader = new Loader3D(false);
			this._modelLoader.addEventListener(AssetEvent.ASSET_COMPLETE, onModelComplete);
			this._modelLoader.load(new URLRequest(fileName));
		}
		
		/**
		*	Once the mesh has been loaded, this is called to determine if we need to apply a rigidbody
		*/
		private function onModelComplete(e : AssetEvent)
		{
			if (e.asset.assetType == AssetType.MESH)
			{
				this._model = Mesh(e.asset);
				this.createRigidBody();
				this.assetReadySignal.dispatch(this);
			}
			else if(e.asset.assetType == AssetType.SKYBOX)
			{
				this._skybox = SkyBox(e.asset);
				this.assetReadySignal.dispatch(this);
			}
			//else if(e.asset.assetType == AssetType.ANIMATOR)
		//	{
		//		this._model.animator = IAnimator(e.asset);
			//}
		
		}
		/**
		*	Adds a rigidbody to the current mesh
		*/
		public function createRigidBody()
		{
			if(this._collisionType == NONE ||  this._collisionType == SKYBOX )// no collider
				return;
			
			Bounds.getMeshBounds(this._model);//get _model bounds

			var colliderShape:AWPCollisionShape;//create correct Collision shape with dimentions to encompass the model
		
			if(this._collisionType == BOX)	//Bounding box
				colliderShape = new AWPBoxShape(Bounds.maxX - Bounds.minX + 1, Bounds.maxY - Bounds.minY + 1, Bounds.maxZ - Bounds.minZ + 1);
			else if(this._collisionType == SPHERE)	//bounding sphere
			{
				var radius = Math.sqrt(Math.pow(Bounds.width/2,2) + Math.sqrt(Math.pow(Bounds.depth/2, 2) + Math.pow(Bounds.height/2, 2)));
				colliderShape = new AWPSphereShape(radius);
			}
			
			//create a shape container
			var shapeContainer:AWPCompoundShape = new AWPCompoundShape();//A shape container to compensate for oggset origins
			var offset:Vector3D = new Vector3D(((Bounds.maxX - Bounds.minX)/2) + Bounds.minX,((Bounds.maxY - Bounds.minY)/2) + Bounds.minY,((Bounds.maxZ - Bounds.minZ)/2) + Bounds.minZ);//the offset 
			shapeContainer.addChildShape(colliderShape, offset);

			//create the rigidbody
			var rigidBody:AWPRigidBody=new AWPRigidBody(shapeContainer,this._model,this._physicsType);
			rigidBody.friction = 1;
			this._rigidBody = rigidBody;
			rigidBody.forceActivationState(AWPCollisionObject.DISABLE_DEACTIVATION);//used to force rigidbodies to stay active
		}
		
		/*-----------------------------------SCENE INTERACTIONS--------------------------------------*/
		
		/**
		*	Adds the current asset to the view, and physics world if necessary
		*/
		public function addToScene($view:View3D, $world:AWPDynamicsWorld = null)
		{
			if(this._collisionType != SKYBOX)
				$view.scene.addChild(this._model);
			
			if(this._collisionType == SKYBOX)
				$view.scene.addChild(this._skybox);			
			
			if(($world != null) && (this._collisionType != NONE) && (this._collisionType != SKYBOX))
				$world.addRigidBody(this._rigidBody);
			
			
		}
		
		/*-----------------------------------GETTERS/SETTERS--------------------------------------*/
		/**
		*	Gets the name of the object
		*	@return String the name of the object
		*/
		public function get name():String
		{
			return this._name;
		}
		
		/**
		*	Gets the current position as a vector
		*	@return Vector3D - the current position
		*/
		public function get position():Vector3D
		{
			if(this._collisionType == NONE)		//mesh
				return this._model.position;
			else								//rigidbody
				return this._rigidBody.position;
		}
		
		
		/**
		*	Gets the current rotateion as a vector
		*	@return Vector3D - the current rotation
		*/
		public function get rotation():Vector3D
		{
			if(this._collisionType == NONE)		//mesh
				return new Vector3D(this._model.rotationX, this._model.rotationY, this._model.rotationZ);
			else								//rigidbody
				return this._rigidBody.rotation;
		}
		
		/**
		* 	returns the current object's rigidbody(if Asset.NONE, then null)
		*	@return AWPRigidBody - the current asset's rigidBody
		*/
		public function get rigidBody():AWPRigidBody
		{
			return this._rigidBody;
		}
		
		/**
		* 	returns the current object's mesh
		*	@return Mesh - the asset's mesh
		*/
		public function get model():Mesh
		{
			return this._model;
		}
	}
}
