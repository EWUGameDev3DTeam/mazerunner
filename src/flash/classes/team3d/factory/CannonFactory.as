package team3d.factory
{
	import awayphysics.collision.dispatch.AWPGhostObject;
	import com.jakobwilson.AssetManager;
	import com.jakobwilson.Cannon.Cannon;
	import flash.geom.Vector3D;
	import team3d.objects.World;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class CannonFactory 
	{
		private static var _instance	:CannonFactory;
		
		public function CannonFactory($lock:Class)
		{
			if ($lock != singletonlock)
				throw new Error("Singleton.");
		}
		
		public function create($transform:Vector3D, $rotation:Vector3D, $player:AWPGhostObject):Cannon
		{
			var cannon:Cannon = new Cannon(AssetManager.instance.getCopy("Cannon"), AssetManager.instance.getCopy("CannonBall"));
			cannon.addObjectActivator($player);
			cannon.transformTo($transform);
			cannon.rotateTo($rotation);
			cannon.addToScene(World.instance.view, World.instance.physics);
			
			return cannon;
		}
		
		public static function get instance():CannonFactory
		{
			if (_instance == null)
				_instance = new CannonFactory(singletonlock);
			
			return _instance;
		}
	}
}
class singletonlock{}