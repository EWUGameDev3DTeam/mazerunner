package team3d.bases
{
	import flash.events.Event;
	import team3d.interfaces.IController;
	import team3d.interfaces.IPlayer;

	/**
	 * ...
	 * @author Dan Watt
	 */
	public class BasePlayer extends BaseObject implements IPlayer
	{	
		/* ---------------------------------------------------------------------------------------- */
		
		protected var _controller	:IController;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function BasePlayer()
		{
			//if(_controller == null)
				//_controller = new StationaryController();
		}
	}
}