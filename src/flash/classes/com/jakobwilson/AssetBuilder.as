package com.jakobwilson
{	
	import flash.events.Event;
	import flash.net.URLRequest;
	import away3d.entities.Mesh;
	import away3d.events.LoaderEvent;
	import away3d.events.AssetEvent;
	import away3d.loaders.Loader3D;
	import away3d.materials.ColorMaterial;
	import away3d.library.assets.AssetType;
	import org.osflash.signals.Signal;
	import away3d.tools.utils.Bounds;
	import awayphysics.collision.shapes.AWPCollisionShape;
	import awayphysics.collision.shapes.AWPCompoundShape;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.geom.Vector3D;
	import away3d.loaders.parsers.Parsers;
	import awayphysics.collision.dispatch.AWPCollisionObject;
	
	public class AssetBuilder
	{
		private var _modelLoader:Loader3D;					/**< The model loader*/
		private var _model:Mesh;							/**< holds the loaded mesh*/
		private var _modelPath:String;						/**< The path to the model we want to load*/
		private var _colliderType:int;						/**< indicates the type of collider shape we are applying(box, sphere, etc)*/
		private var _physicsType:int;						/**< indicates the type of physics we want, static or dynamic*/
		
		public var assetReadySignal:Signal = new Signal(int, Object);	/**< A signal to tell the calling class that the model is loaded.int - assetType, Object - asset*/
		
		
		public static const MESH:int = 1;/**< A constant to represent a mesh was loaded.*/
		public static const RIGIDBODY:int = 2; /**< A constant to represent a complete rigidbody that was loaded*/
		
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
		
		/**
		*	The constructor
		*/
		public function AssetCreator()
		{
			//do nothing
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Starts starts loading model and rigidbody with specified physics params
		*	@param String - the relative path to the 3d file to load
		*/
		public function load(meshPath:String, colliderType:int = 0, physicsType:int = 0)
		{
			this._modelPath = meshPath;
			this._physicsType = physicsType;
			this._colliderType = colliderType;
			this.loadModel();
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Loads the mesh, on complete, calls onModelComplete
		*/
		private function loadModel()
		{
			Parsers.enableAllBundled();
			this._modelLoader = new Loader3D(false);
			this._modelLoader.addEventListener(AssetEvent.ASSET_COMPLETE, onModelComplete);
			this._modelLoader.load(new URLRequest(this._modelPath));
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Once a model is complete the rigidbodies can them be applied
		*/
		private function onModelComplete(ev : AssetEvent) : void
		{
			if (ev.asset.assetType == AssetType.MESH)
			{
				_model = Mesh(ev.asset);
				addRigidBody(_model, _physicsType, _colliderType);
			}
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Adds a rigidbody of the specified type to the model.
		* 	Note that this is public, so if the user already has a model, they can use this method to apply a rigidbody to it
		*/
		public function addRigidBody(model:Mesh ,physicsType:int, colliderType:int)
		{
			Bounds.getMeshBounds(model);//get _model bounds
			//trace("Bounds: " + Bounds.width + ", " + Bounds.depth + ", " + Bounds.height);
			var colliderShape:AWPCollisionShape;//create correct Collision shape with dimentions to encompass the model
			
			if(colliderType == NONE)// no collider
			{
				assetReadySignal.dispatch(MESH, this._model)
				return;
			}
			else if(colliderType == BOX)	//Bounding box
			{
				colliderShape = new AWPBoxShape( Bounds.width, Bounds.depth, Bounds.height);
				trace("w/h/d: " + Bounds.width + ", " + Bounds.height  + ", " + Bounds.depth);
			}
			else if(colliderType == SPHERE)	//bounding sphere
			{
				var radius = Math.sqrt(Math.pow(Bounds.width/2,2) + Math.sqrt(Math.pow(Bounds.depth/2, 2) + Math.pow(Bounds.height/2, 2)));
				colliderShape = new AWPSphereShape(radius);
			}
			
			var shapeContainer:AWPCompoundShape = new AWPCompoundShape();//A shape container to compensate for oggset origins
			var offset:Vector3D = new Vector3D((Bounds.maxX + Bounds.minX)/2, (Bounds.maxZ + Bounds.minZ)/2, (Bounds.maxY + Bounds.minY)/2);
			trace("Max : " + Bounds.maxX + ", " + Bounds.maxY + ", " + Bounds.maxZ);
			trace("Min : " + Bounds.minX + ", " + Bounds.minY + ", " + Bounds.minZ);
			trace("Offset: " + (Bounds.maxX + Bounds.minX)/2 + ", " +(Bounds.maxY + Bounds.minY)/2 + ", " + (Bounds.maxZ + Bounds.minZ)/2);
			shapeContainer.addChildShape(colliderShape, offset);
				
			var rigidBody:AWPRigidBody=new AWPRigidBody(shapeContainer,model,physicsType);
			rigidBody.friction = 1;
			rigidBody.forceActivationState(AWPCollisionObject.DISABLE_DEACTIVATION);
			assetReadySignal.dispatch(RIGIDBODY, rigidBody);
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Allows the user to grab the model and add it to their scene
		*	@return Mesh the loaded mesh
		*/
		public function get model():Mesh
		{
			return this._model;
		}
		
	}
}
