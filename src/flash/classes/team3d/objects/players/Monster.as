package team3d.objects.players
{
	import awayphysics.collision.dispatch.AWPGhostObject;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	import awayphysics.dynamics.character.AWPKinematicCharacterController;
	import com.jakobwilson.Asset;
	
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
