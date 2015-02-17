package team3d.builders
{
	import away3d.entities.Mesh;
	import away3d.tools.utils.Bounds;
	import awayphysics.dynamics.AWPRigidBody;
	import com.jakobwilson.AssetBuilder;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import team3d.builders.MazePieces.MazeRoom;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class MazeBuilder 
	{
		public static const	NOWALLS		:int = 0;
		public static const ROWWALLONLY	:int = 1;
		public static const COLWALLONLY	:int = 2;
		public static const BOTHWALLS	:int = 3;
		
		/* ---------------------------------------------------------------------------------------- */
		
		private static var _instance	:MazeBuilder;
		
		/* ---------------------------------------------------------------------------------------- */
		
		private var _wallRigidBody		:AWPRigidBody;
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function MazeBuilder($lock:Class)
		{
			if ($lock != Singleton)
				throw new Error("Cannot be instantiated.");
			
			
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Builds and returns a maze
		 *
		 * @param	$rows		The number of rows in the maze
		 * 			$cols		The number of cols in the maze
		 * 			$rigidBody	The rigidbody to be used if one is specified.
		 * 			$startx		The starting x location for the maze
		 * 			$starty		The starting y location for the maze
		 * @return				A vector containing all the rooms for the maze
		 */
		public function Build($rows:int, $cols:int, $startx:Number, $starty:Number, $rigidBody:AWPRigidBody = null):Vector.<MazeRoom>
		{
			var rb:AWPRigidBody = $rigidBody;
			// if there was no rb passed in, assign the predefined set one
			if (rb == null)
				rb = _wallRigidBody
			
			// if no wall rb is available at all, fail and throw an error
			if (rb == null)
				throw new Error("No wall rigid body was found. Maze cannot be generated. Either pass one in or set one via WallRigidBody");
			
			// create the new 2d vector that will house the maze's rooms.
			var mazeGuide:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
			
			var rooms:Vector.<int>;
			// create the rooms
			for (var row:int = 0; row < $rows; row++)
			{
				rooms = new Vector.<int>();
				for (var col:int = 0; col < $cols; col++)
					rooms[col] = MazeBuilder.BOTHWALLS;
					
				mazeGuide[row] = rooms;
			}
			
			return genMaze(mazeGuide, $startx, $starty, rb);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Generates the maze based off the 2d int array
		 * 
		 * @param	$mg		A 2d array of vectors containing ints to determine which walls go into each room
		 * 			$rb		The wall rigidbody to be used as the wall piece
		 * 			$startx	The starting x for the maze
		 * 			$starty	The starting y for the maze
		 * @return			A vector containing all the rooms for the maze
		 */
		protected function genMaze($mg:Vector.<Vector.<int>>, $startx:Number, $starty:Number, $rb:AWPRigidBody):Vector.<MazeRoom>
		{
			// create the maze
			var maze:Vector.<MazeRoom> = new Vector.<MazeRoom>();
			
			// get the bounds from the wall
			Bounds.getMeshBounds(Mesh($rb.skin));
			var walldepth:Number = Bounds.depth;
			var wallthickness:Number = Bounds.width;
			var wallheight:Number = Bounds.height;
			
			$startx += wallthickness * 0.5;
			$starty += wallthickness + wallheight * 0.5;
			
			var spacing:Number = wallheight + wallthickness; // it's weird but this is the length of the wall plus the wall thickness
			
			// declare some variables to help with the build process
			var rowwall:AWPRigidBody;
			var colwall:AWPRigidBody;
			var x:Number;
			var y:Number;
			var room:MazeRoom;
			
			// assign walls to each room
			for (var row:int = 0; row < $mg.length; row++)
			{
				// null the walls out each time through to prevent any walls from being messed up or carried over
				rowwall = null
				colwall = null;
				for (var col:int = 0; col < $mg[row].length; col++)
				{
					if($mg[row][col] == MazeBuilder.NOWALLS) // no walls
					{
						
					}
					else if ($mg[row][col] == MazeBuilder.ROWWALLONLY) // row wall only
					{
						x = $startx + wallheight * 0.5 - wallthickness * 0.5;
						y = $starty - wallheight * 0.5 - wallthickness * 0.5;
						rowwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX, AssetBuilder.STATIC);
						rowwall.rotationZ += 90;
						rowwall.position = new Vector3D(x + col * (spacing - wallthickness), y + row * spacing, 0);
					}
					else if ($mg[row][col] == MazeBuilder.COLWALLONLY) // col wall only
					{
						x = $startx;
						y = $starty;
						colwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX , AssetBuilder.STATIC);
						colwall.position = new Vector3D(x + row * spacing, y + col * spacing, 0);
					}
					else if($mg[row][col] == MazeBuilder.BOTHWALLS) // both walls
					{
						x = $startx;
						y = $starty;
						colwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX , AssetBuilder.STATIC);
						colwall.position = new Vector3D(x + row * spacing, y + col * spacing, 0);
						
						x = $startx + wallheight * 0.5 - wallthickness * 0.5;
						y = $starty - wallheight * 0.5 - wallthickness * 0.5;
						rowwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX, AssetBuilder.STATIC);
						rowwall.rotationZ += 90;
						rowwall.position = new Vector3D(x + col * (spacing - wallthickness), y + row * spacing, 0);
					}
					maze.push(new MazeRoom(rowwall, colwall));
				}
			}
			
			return maze;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the model used to build the maze
		 *
		 * @param	$rb		The rigidbody that stores the mesh
		 * @return			The rigidbody that stores the mesh
		 */
		public function get WallRigidBody():AWPRigidBody
		{
			return _wallRigidBody;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set WallRigidBody($rb:AWPRigidBody):void
		{
			_wallRigidBody = $rb;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the instance of this singleton
		 *
		 * @return			The instance of the MazeBuilder
		 */
		public static function get instance():MazeBuilder
		{
			if (_instance == null)
				_instance = new MazeBuilder(Singleton);
			
			return _instance;
		}
	}
	
}

class Singleton{}