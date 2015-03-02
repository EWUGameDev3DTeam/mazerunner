package team3d.objects.players
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.SphereGeometry;
	import awayphysics.collision.shapes.AWPSphereShape;
	import awayphysics.dynamics.AWPRigidBody;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import team3d.bases.BasePlayer;
	import team3d.controllers.FirstPersonCameraController;
	import team3d.controllers.FlyController;
	import team3d.interfaces.IController;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class FlyPlayer extends BasePlayer
	{
		private var _rb			:AWPRigidBody;
		
		public function FlyPlayer()
		{
			super();
			
			_controller = new FlyController();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Starts the player
		 *
		 * @param	$view	the view3d object for the game
		 */
		override public function Begin():void
		{
			super.Begin();
			
			_controller.Begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the player
		 * @param	$view	The view3d object for the game
		 */
		override public function End():void
		{
			super.End();
			_controller.End();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		override protected function enterFrame($e:Event):void 
		{
			_controller.Move(50);
		}
	}
	
}