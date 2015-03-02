package team3d.bases
{
	import away3d.cameras.Camera3D;
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
		public static const TORADS		:Number = Math.PI / 180.0;
		/* ---------------------------------------------------------------------------------------- */
		
		protected var _baseController	:ControllerBase;
		
		/**
		 * Constructs the BaseController object.
		 */
		public function BaseController()
		{	
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function Begin():void
		{
			// do nothing
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * 
		 */
		public function End():void
		{
			// do nothing
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
		
		public function get Camera():Camera3D
		{
			return Camera3D(_baseController.targetObject);
		}
		
	}
}

