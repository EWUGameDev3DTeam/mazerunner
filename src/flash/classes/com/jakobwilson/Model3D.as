package  com.jakobwilson
<<<<<<< HEAD
{
	import away3d.containers.View3D;
	import flash.events.Event;
	import flash.display.MovieClip;
	import away3d.containers.View3D;
	import flash.geom.Vector3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	import flash.display.Sprite;
=======
{	
>>>>>>> master
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import away3d.entities.Mesh;
<<<<<<< HEAD
	import away3d.containers.ObjectContainer3D;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.events.AssetEvent;
	import away3d.library.assets.AssetType;
	import org.osflash.signals.Signal;
	
	public class Model3D 
	{
		private var _model:Mesh;
		private var _texture:BitmapTexture;
		
		private var _modelPath:String;
		private var _texturePath:String;
		
		private var _modelLoader:Loader3D;
		private var _textureLoader:Loader;
		
		public var modelReadySignal:Signal = new Signal();
		
=======
	import away3d.events.LoaderEvent;
	import away3d.events.AssetEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;	
	import away3d.library.assets.AssetType;
	import org.osflash.signals.Signal;
	public class Model3D 
	{
		private var _texture:BitmapTexture;					/**< A bitmap texture to apply in place of the one that will fail to load in the awd parser*/
		private var _texturePath:String;					/**< The path to the texture we want to load*/
		private var _modelLoader:Loader3D;					/**< The model loader*/
		
		private var _model:Mesh;							/**< holds the loaded mesh*/
		private var _modelPath:String;						/**< The path to the model we want to load*/
		private var _textureLoader:Loader;					/**< The texture loader*/
		
		public var modelReadySignal:Signal = new Signal(int, Object);	/**< A signal to tell the calling class that the model is loaded.int - assetType, Object - asset*/
		
		// Constants to tell what typew of assets were loaded
		//@NOTE: right now Mesh is the only type this class loads, but this keeps the class open for extension*/
		public static const MESH:int = 1;/**< A constant to represent a mesh was loaded.*/
		
		/**
		*	The constructor
		*/
>>>>>>> master
		public function Model3D()
		{
			//do nothing
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Starts starts loading model and it's texture
<<<<<<< HEAD
=======
		*	@param String - the relative path to the 3d file to load
>>>>>>> master
		*/
		public function load(meshPath:String )
		{
			this._modelPath = meshPath;
			this.loadModel();
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Loads the mesh, on complete, it will check if the default texture was applied and if so, will load
		*	the texture specified by _texturePath
		*/
		public function loadModel()
		{
			Parsers.enableAllBundled();
			this._modelLoader = new Loader3D(false);
			this._modelLoader.addEventListener(AssetEvent.ASSET_COMPLETE, onModelComplete);
			this._modelLoader.load(new URLRequest(this._modelPath));
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	reloads the textures and applies them with a new material since the loader always fails to load textures
		* 	of you are going to export from away builder, uncheck "embed textures" to save space and place 
		*	textures in /textures as this is where the .awd expects them to be. 
		*/
		private function onModelComplete(ev : AssetEvent) : void
		{
<<<<<<< HEAD
			if (ev.asset.assetType == AssetType.MESH)
			{
				_model = Mesh(ev.asset);
				
				//trace("Normal: " + TextureMaterial(_model.material).specularMap.originalName);
				
				if (TextureMaterial(_model.material).texture != null)
					_texturePath = TextureMaterial(_model.material).texture.originalName;
					
				loadTexture();
				if (_model.material == null)
					_model.material = new ColorMaterial(Math.random() * 0xffffff);
			}
			//@NOTE could I add something like: if (ev.asset.assetType == AssetType.TEXTURE) to handle failed texture load?
		}
		
=======
			if (ev.asset.assetType == AssetType.MESH) 
			{
				_model = Mesh(ev.asset);
									
				if(TextureMaterial(_model.material).texture != null)
					_texturePath = TextureMaterial(_model.material).texture.originalName;
				
				loadTexture()

				if (_model.material == null)
					_model.material = new ColorMaterial(Math.random() * 0xffffff);
			}
		}

		/* -------------------------------------------------------------------------------------------------------- */

>>>>>>> master
		/**
		* Starts loading the texture
		*/
		private function loadTexture()
		{
			_textureLoader = new Loader();
			_textureLoader.load(new URLRequest(this._texturePath));
			_textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureComplete);
		}
<<<<<<< HEAD
		
=======

		/* -------------------------------------------------------------------------------------------------------- */

>>>>>>> master
		/**
		*	Once the texture is loaded create a new TextureMaterial and apply it to the model, once this is done, dispatch the model ready signal
		*/
		private function onTextureComplete(evt:Event)
		{
<<<<<<< HEAD
			var bmp:Bitmap = _textureLoader.content as Bitmap;
			this._texture = new BitmapTexture(bmp.bitmapData);
			//_model.material = new TextureMaterial(new BitmapTexture(bmp.bitmapData));
			TextureMaterial(_model.material).texture = new BitmapTexture(bmp.bitmapData);
			modelReadySignal.dispatch();
=======
			
			var bmp:Bitmap = _textureLoader.content as Bitmap;
			this._texture = new BitmapTexture(bmp.bitmapData);
			TextureMaterial(_model.material).texture = new BitmapTexture(bmp.bitmapData);
			modelReadySignal.dispatch(MESH, this._model);
>>>>>>> master
			this._textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTextureComplete);
			this._modelLoader.removeEventListener(AssetEvent.ASSET_COMPLETE, onModelComplete);
		}
		
		
<<<<<<< HEAD
		/**
		*	Allows the user to grab the model and add it to their scene
=======
		/* -------------------------------------------------------------------------------------------------------- */

		/**
		*	Allows the user to grab the model and add it to their scene
		*	@return Mesh the loaded mesh
>>>>>>> master
		*/
		public function get model():Mesh
		{
			return this._model;
		}
		
<<<<<<< HEAD
		
		

	}
	
=======
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Returns a copy of the mesh with the same geometry and material references as the original
		* 	for more info see the clone() method for meshes: http://away3d.com/livedocs/away3d/4.0/away3d/entities/Mesh.html#clone()
		*	@return Mesh - the copy of the Model3d mesh
		*/
		public function getCopy():Mesh
		{
			return Mesh(this._model.clone());
		}
	}
>>>>>>> master
}
