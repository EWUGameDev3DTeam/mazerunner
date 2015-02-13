package  com.jakobwilson
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
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import away3d.entities.Mesh;
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
		
		public function Model3D()
		{
			//do nothing
		}
		
		/* -------------------------------------------------------------------------------------------------------- */
		
		/**
		*	Starts starts loading model and it's texture
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
			if (ev.asset.assetType == AssetType.MESH) 
				{
					_model = Mesh(ev.asset);
					
					//trace("Normal: " + TextureMaterial(_model.material).specularMap.originalName);
					
					if(TextureMaterial(_model.material).texture != null)
						_texturePath = TextureMaterial(_model.material).texture.originalName;
					
					loadTexture()

					if (_model.material == null)
						_model.material = new ColorMaterial(Math.random() * 0xffffff);
				}
				//@NOTE could I add something like: if (ev.asset.assetType == AssetType.TEXTURE) to handle failed texture load?
		}
		
		/**
		* Starts loading the texture
		*/
		private function loadTexture()
		{
			_textureLoader = new Loader();
			_textureLoader.load(new URLRequest(this._texturePath));
			_textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureComplete);
		}
		
		/**
		*	Once the texture is loaded create a new TextureMaterial and apply it to the model, once this is done, dispatch the model ready signal
		*/
		private function onTextureComplete(evt:Event)
		{
			
			var bmp:Bitmap = _textureLoader.content as Bitmap;
			this._texture = new BitmapTexture(bmp.bitmapData);
			//_model.material = new TextureMaterial(new BitmapTexture(bmp.bitmapData));
			TextureMaterial(_model.material).texture = new BitmapTexture(bmp.bitmapData);
			modelReadySignal.dispatch();
			this._textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTextureComplete);
			this._modelLoader.removeEventListener(AssetEvent.ASSET_COMPLETE, onModelComplete);
		}
		
		
		/**
		*	Allows the user to grab the model and add it to their scene
		*/
		public function get model():Mesh
		{
			return this._model;
		}
		
		
		

	}
	
}
