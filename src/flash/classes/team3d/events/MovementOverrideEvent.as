package  team3d.events
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class MovementOverrideEvent extends Event
	{
		public var force:Vector3D;
		public function MovementOverrideEvent($force:Vector3D) 
		{
			super("MovementOverride");
			this.force = $force;
		}

	}
	
}
