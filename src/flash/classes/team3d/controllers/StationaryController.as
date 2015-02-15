package team3d.controllers
{
	import away3d.controllers.ControllerBase;
	import flash.display.MovieClip;
	import team3d.bases.BaseController;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class StationaryController extends BaseController
	{
		public function StationaryController()
		{
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the object
		 *
		 * @param	$mc		The movieclip to be moved
		 * 			$speed	The speed to move the movie clip
		 */
		override public function Move($mc:MovieClip, $speed:Number):void
		{
			// do nothing
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the camera around
		 *
		 * @param	$camera	The camera to move around
		 */
		override public function MoveCamera($camera:ControllerBase):void 
		{
			// do nothing
		}
	}
	
}