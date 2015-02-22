package team3d.objects.players
{
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPRigidBody;
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
		
		private var _mesh	:Mesh;
		private var _rb		:AWPRigidBody;
		
		public function HumanPlayer($cam:Camera3D)
		{
			super();
			
			_cam = $cam;
			_fpc = new FirstPersonController(_cam, 0, 90, 0, 180, 0, true);
			//_fpc.fly = true;
			//_controller = new HumanController(_model, _cam, _fpc);
			_controller = new FlyController(_cam, _fpc);
			
			
			_mesh = new Mesh(new CubeGeometry(), new ColorMaterial(0x0000FF));
			_mesh.x = 300;
			_mesh.y = 300;
			_mesh.z = 3000;
			var pShape:AWPBoxShape = new AWPBoxShape(100,100,100);
			_rb = new AWPRigidBody(pShape, _mesh, 1);
			//World.instance.physics.addRigidBody(pRigidBody);
			_rb.friction = 1;
			_rb.position = new Vector3D(_mesh.x, _mesh.y, _mesh.z);
			_rb.applyTorque(new Vector3D(0, 1, 1));
			
			//_mesh = $m;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the mesh for the human player
		 *
		 * @param	$mesh	The player's mesh
		 * @return			The player's mesh
		 */
		public function get mesh():Mesh
		{
			return _mesh;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set mesh($mesh:Mesh):void
		{
			_mesh = $mesh;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the rigid body of the player
		 * @return			The rigid body
		 */
		public function get rigidbody():AWPRigidBody
		{
			return _rb;
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
			_controller.End();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the model that is assigned to this player
		 *
		 * @return	The model for the player
		 */
		public function get getMesh():Mesh
		{
			return _mesh;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		override protected function enterFrame($e:Event):void 
		{
			_controller.Move(10);
		}
	}
	
}