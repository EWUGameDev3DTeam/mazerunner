package team3d.bases
{
	import flash.events.Event;
	import team3d.controllers.HumanController;
	import team3d.controllers.StationaryController;
	import team3d.interfaces.IController;
	import team3d.interfaces.IPlayer;

	/**
	 * ...
	 * @author Dan Watt
	 */
	public class BasePlayer extends BaseObject implements IPlayer
	{	
		/* ---------------------------------------------------------------------------------------- */
		
		protected var _controller	:HumanController;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function BasePlayer()
		{
			//if(_controller == null)
				//_controller = new StationaryController();
		}
	}
}