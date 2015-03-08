package team3d.objects.players
{
	import awayphysics.dynamics.AWPRigidBody;
	import flash.events.Event;
	import team3d.bases.BasePlayer;
	import team3d.controllers.FlyController;
	
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