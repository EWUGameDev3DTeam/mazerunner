package team3d.objects.players
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import team3d.bases.BasePlayer;
	import team3d.controllers.FlyController;
	import team3d.controllers.HumanController;
	import team3d.interfaces.IController;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class HumanPlayer extends BasePlayer
	{
		private var _cam	:Camera3D;
		
		/** the fps camera controller */
		private var _fpc	:FirstPersonController;
		
		public var _model	:Mesh;
		
		public function HumanPlayer($cam:Camera3D, $model:Mesh)
		{
			super();
			
			_cam = $cam;
			_model = $model;
			_fpc = new FirstPersonController(_cam, 0, 90, 0, 180, 0, true);
			//_fpc.fly = true;
			//_controller = new HumanController(_model, _cam, _fpc);
			_controller = new FlyController(_cam, _fpc);
		}
		
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
			_controller.End();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the model that is assigned to this player
		 *
		 * @return	The model for the player
		 */
		public function get getModel():Mesh
		{
			return _model;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		override protected function enterFrame($e:Event):void 
		{
			_controller.Move(10);
		}
	}
	
}