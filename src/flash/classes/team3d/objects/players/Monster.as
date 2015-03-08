package team3d.objects.players
{
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import awayphysics.collision.dispatch.AWPGhostObject;
	import com.jakobwilson.Asset;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	
	public class Monster extends AWPKinematicCharacterController
	{
		/**
		*	Creates a new monster ai
		*/
		public function Monster(a:Asset, height:Number, radius:Number) 
		{
			var shape:AWPCapsuleShape = new AWPCapsuleShape(radius, height);
			var ghostObject:AWPGhostObject = new AWPGhostObject(shape, a.model);
			super(ghostObject,1);
		}
		
	}
}
