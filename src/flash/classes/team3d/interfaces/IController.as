package team3d.interfaces
{
	import away3d.controllers.ControllerBase;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public interface IController
	{
		function Move($speed:Number):void;
		//function MoveCamera($dx:Number, $dy:Number):void;
	}
	
}