
/**
* queues up 3 assets and creates handlers for loading them, then loads
*/
public function TestAssetManager():void
{
	//Set up the physics world
	this._world = AWPDynamicsWorld.getInstance();
	this._world.initWithDbvtBroadphase();
	this._world.gravity = new Vector3D(0,-1,0);//move gravity to pull down on z axis

	//enqueue each item with the following params:(name, filename, collision type(Asset.[NONE, BOX, SPHERE]), physics type (Asset.[STATIC, DYNAMIC]))
	AssetManager.instance.enqueue("Wall", "Models/Wall/WallSegment.awd", Asset.BOX, Asset.STATIC);
	AssetManager.instance.enqueue("Floor", "Models/Floor/Floor.awd", Asset.BOX, Asset.STATIC);
	AssetManager.instance.enqueue("Cage", "Models/Cage/Cage.awd", Asset.BOX, Asset.DYNAMIC);
	
	AssetManager.instance.load(this.onProgress, this.onComplete);
}

/**
*	A handler for tracking load progress
*	@param Number x - the load progress as measured from 0 to 1
*/
public function onProgress(x:Number)
{
	//Later this will be used with the loading bar
	trace("Progress: " + x);
}

/**
* 	The complete handler. this is called when all items in the current load queue are loaded and ready to use
*/
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
