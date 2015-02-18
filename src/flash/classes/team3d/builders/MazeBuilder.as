package team3d.builders
{
	import adobe.utils.CustomActions;
	import away3d.entities.Mesh;
	import away3d.tools.utils.Bounds;
	import awayphysics.dynamics.AWPRigidBody;
	import com.jakobwilson.AssetBuilder;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import team3d.builders.MazePieces.MazeRoom;
	import team3d.utils.World;
	
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
		private var _wallsRemoved		:int;
		
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
		public function Build($rows:int, $cols:int, $startx:Number, $starty:Number, $rigidBody:AWPRigidBody = null):Vector.<Vector.<MazeRoom>>
		{
			var rb:AWPRigidBody = $rigidBody;
			// if there was no rb passed in, assign the predefined set one
			if (rb == null)
				rb = _wallRigidBody
			
			// if no wall rb is available at all, fail and throw an error
			if (rb == null)
				throw new Error("No wall rigid body was found. Maze cannot be generated. Either pass one in or set one via WallRigidBody");
			
			// create the new 2d vector that will house the maze's rooms.
			var maze:Vector.<Vector.<MazeRoom>> = buildRooms($rows, $cols);
			
			var randRow:int;
			var randCol:int;
			var rooms:Vector.<MazeRoom>;
			var room:MazeRoom;
			var sets:int = $rows * $cols;
			_wallsRemoved = 0;
			
			while (sets - _wallsRemoved > 1)
			{
				randCol = World.instance.Random(0, $cols - 1);
				randRow = World.instance.Random(0, $rows - 1);
				
				rooms = maze[randRow];
				room = rooms[randCol];
				
				if (Math.random() > 0.5 && room.HasRowWall)
				{
					if (randRow > 0)
						combineSets(room, randRow, randCol, maze, true);
				}
				else if (room.HasColumnWall)
				{
					if (randCol > 0)
						combineSets(room, randRow, randCol, maze, false);
				}
				rooms[randCol] = room;
				maze[randRow] = rooms;
			}
			
			genMaze(maze, $startx, $starty, rb);
			
			return maze;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Combines the given sets of the room
		 *
		 * @param	$param1	Describe param1 here.
		 * @return			Describe the return value here.
		 */
		protected function combineSets($r:MazeRoom, $row:int, $col:int, $mg:Vector.<Vector.<MazeRoom>>, $dropRow:Boolean):void
		{
			var nextRoom:MazeRoom = null;
			// grab the neighboring room
			if ($dropRow)
				nextRoom = $mg[$row - 1][$col];
			else
				nextRoom = $mg[$row][$col - 1];
			
			// if they are already part of the same set, just return
			if (nextRoom.Set == $r.Set)
				return;
			
			// drop the appropriate wall
			if ($dropRow)
				$r.HasRowWall = false;
			else
				$r.HasColumnWall = false;
			
			var curSet:int = $r.Set;
			var nextSet:int = nextRoom.Set;
				
			var rowRoom:Vector.<MazeRoom>;
			for (var row:int = 0; row < $mg.length; row++)
			{
				rowRoom = $mg[row];
				for (var col:int = 0; col < rowRoom.length; col++)
				{
					if (rowRoom[col].Set == nextSet)
						rowRoom[col].Set = curSet;
				}
				$mg[row] = rowRoom;
			}
			
			_wallsRemoved++;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Builds a guide for genMaze
		 *
		 * @param	$rows	The number of rows in the maze
		 * 			$cols	The number of columns in the maze
		 * @return			The 2d vector array that represents the maze guide
		 */
		protected function buildRooms($rows:int, $cols:int):Vector.<Vector.<MazeRoom>>
		{
			var mr:Vector.<Vector.<MazeRoom>> = new Vector.<Vector.<MazeRoom>>();
			var rowRooms:Vector.<MazeRoom>;
			// create the rooms
			for (var row:int = 0; row < $rows; row++)
			{
				rowRooms = new Vector.<MazeRoom>();
				for (var col:int = 0; col < $cols; col++)
					rowRooms[col] = new MazeRoom(col + row * $rows);
					
				mr[row] = rowRooms;
			}
			
			return mr;
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
		protected function genMaze($mg:Vector.<Vector.<MazeRoom>>, $startx:Number, $starty:Number, $rb:AWPRigidBody):void
		{
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
					if ($mg[row][col].HasRowWall && $mg[row][col].HasColumnWall) // both walls
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
					else if ($mg[row][col].HasRowWall) // row wall only
					{
						x = $startx + wallheight * 0.5 - wallthickness * 0.5;
						y = $starty - wallheight * 0.5 - wallthickness * 0.5;
						rowwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX, AssetBuilder.STATIC);
						rowwall.rotationZ += 90;
						rowwall.position = new Vector3D(x + col * (spacing - wallthickness), y + row * spacing, 0);
					}
					else if ($mg[row][col].HasColumnWall) // col wall only
					{
						x = $startx;
						y = $starty;
						colwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX , AssetBuilder.STATIC);
						colwall.position = new Vector3D(x + row * spacing, y + col * spacing, 0);
					}
					
					$mg[row][col].ColumnWall = colwall;
					$mg[row][col].RowWall = rowwall;
				}
			}
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