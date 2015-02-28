package  com.jakobwilson
{
	import com.jakobwilson.Asset;
	
	
	/**
	*	Manages the loading and accessing of assets
	*	@author Jakob Wilson
	*/
	public class AssetManager 
	{
		private static var _instance:AssetManager = null;						/**< The instant of the asset manager(to enforce singleton)*/
		private var _assets:Array = new Array();								/**< The array to hold the finished asset*/
		private var _loadQueue:Vector.<QueueItem> = new Vector.<QueueItem>();	/**< The queue for unloaded items*/
		private var _itemCount:int;												/**< The count of items at the beginning of load*/
		private var _progressHandler:Function = null;							/**< The progress handler function(should take a single number parameter)*/
		private var _completeHandler:Function = null;							/**< The compplete handler, called on loading completion*/
		
		/**
		*	The class constructor that should not ever be called
		*/ 
		public function AssetManager($lock) 
		{
			if ($lock != SingletonLock)
				throw new Error("SingletonExample is a singleton and should not be instantiated. Use SingletonExample.instance instead");
		}
		
		/**
		 * Returns an instance to this class.
		 * @return		An instance to this class.
		 */
		public static function get instance():AssetManager
		{
			if(_instance == null)
				_instance = new AssetManager(SingletonLock);
			return _instance;
		}
		
		/*--------------------------------LOADING--------------------------------------*/		
		
		/**
		*	Adds a new asset to the queue of assets to be loaded
		*	@param String name - the name we want to use for retreving the object later(must be unique)
		*	@param String fileName - the file that we want to load from(usually a .awd or .3ds file)
		*	@param int colliderType - the type fo collider we want to use. Can be Asset.NONE, Asset.BOX, or Asset.Sphere
		*	@param int physicsType - the type of physics we want the rigidbody to have. Can be Asset.STATIC or Asset.DYNAMIC(default is static)
		*/
		public function enqueue($name:String , $fileName:String , $colliderType:int , $physicsType:int = 0)
		{
			var newItem:QueueItem = new QueueItem($fileName, new Asset($name, $colliderType, $physicsType));
			this._loadQueue.push(newItem);
		}
		
		/**
		*	Loads up all items in the current queue, on complete, the assets are removed from the queue and are accessable by getAsset() and getCopy()
		*	@param Function progressHandler - a function that takes a single number parameter(that will be passed 0-1) that is called to update loading progress
		*	@param Function - a function that is called when loading is complete
		*/
		public function load($progressHandler:Function, $completeHandler:Function)
		{
			this._progressHandler = $progressHandler;
			this._completeHandler = $completeHandler;
			this._itemCount = this._loadQueue.length;
			
			for each(var o:QueueItem in this._loadQueue)
			{
				o.asset.assetReadySignal.add(this.updateProgress);
				o.asset.load(o.filename);
			}
		}
		
		/**
		*	Updates the loading progress by calling a user defined function and giving it a number between 0 and 1 representing the progress
		*	Also fires a completeHandler function when all loading is complete and adds the asset to the array of finished assets
		*	@param Asset a - the asset that just finished loading
		*/
		public function updateProgress($a:Asset)
		{
			this._loadQueue.splice(this._loadQueue.lastIndexOf($a), 1);
			this._assets[$a.name] = $a;
			
			if(this._progressHandler != null)
				this._progressHandler((this._itemCount - this._loadQueue.length)/this._itemCount);

			if(this._loadQueue.length <= 0 && this._completeHandler != null)
				this._completeHandler();
		}
		
		/*--------------------------------RETREVING--------------------------------------*/
		
		/**
		*	gets an asset by name and returns the original asse
		*	@param name - the name of the asset we want to retrieve
		*	@return Asset - the asset found at the given location(can be null)
		*/
		public function getAsset($name:String):Asset
		{
			return this._assets[$name];
		}
		
		/**
		*	Gets a copy of an asset by name using the clone() method.
		*	@param String name - the name of the asset we want to copy
		*	@return Asset - a copy of the asset found under the given name, if the asset could not be found, returne null
		*/
		public function getCopy($name:String):Asset
		{
			if(this._assets[$name] != null)
				return (this._assets[$name].clone());
			else
				return null;
		}
	}
}


/*---------------------------------QUEUE ITEM CLASS---------------------------------------------*/
/**
*	A lightweight class to represent a queue item(an item that has yet to be loaded)
*	@author Jakob Wilson
*/
import com.jakobwilson.Asset;
class QueueItem
{
	public var name:String;				/**< the name of the asset to be loaded */
	public var filename:String;			/**< the filename of the mesh we want to load */
	public var asset:Asset;				/**< the asset class in which to store the loaded mesh */
	
	/**
	* Creates a new queue item
	*/
	public function QueueItem($filename:String, $asset:Asset)
	{
		this.name = $asset.name;
		this.filename = $filename;
		this.asset = $asset;
	}
}

/**
*	An empty class to prevent external instantiation.
*/
class SingletonLock {} 

