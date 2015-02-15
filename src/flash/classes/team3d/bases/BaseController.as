package team3d.bases
{
	import away3d.controllers.ControllerBase;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import team3d.interfaces.IController;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class BaseController implements IController
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the BaseController object.
		 */
		public function BaseController()
		{	
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Moves the object physically
		 *
		 * @param	$speed	The speed to move the movie clip
		 */
		public function Move($speed:Number):void
		{
			throw new Error("This method must be overridden and should not contain a super call.");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

