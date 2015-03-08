package team3d.interfaces
{
	import away3d.cameras.Camera3D;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public interface IController
	{
		function Begin():void;
		function End():void;
		function Move($speed:Number):void;
		function get Camera():Camera3D;
		//function MoveCamera($dx:Number, $dy:Number):void;
	}
	
}