package team3d.builders
{
	import adobe.utils.CustomActions;
	import away3d.entities.Mesh;
	import away3d.tools.utils.Bounds;
	import awayphysics.dynamics.AWPRigidBody;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import team3d.objects.maze.MazeRoom;
	import team3d.objects.maze.Maze;
	import team3d.utils.Utils;
	
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
		
		private var _wall				:Asset;
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
		public function Build($rows:int, $cols:int, $startx:Number, $startz:Number, $wall:Asset = null):Maze
		{
			var wall:Asset = $wall;
			// if there was no rb passed in, assign the predefined set one
			if (wall == null)
				wall = _wall
			
			// if no wall rb is available at all, fail and throw an error
			if (wall == null)
				throw new Error("No wall asset was found. Maze cannot be generated. Either pass one in or set one via WallAsset");
			
			// create the new 2d vector that will house the maze's rooms.
			var maze:Maze = new Maze($rows, $cols);
			buildRooms(maze);
			
			var randRow:int;
			var randCol:int;
			var rooms:Vector.<MazeRoom>;
			var room:MazeRoom;
			var sets:int = $rows * $cols;
			_wallsRemoved = 0;
			
			//if(1==2)
			while (sets - _wallsRemoved > 1)
			{
				randCol = Utils.instance.Random(0, $cols - 1);
				randRow = Utils.instance.Random(0, $rows - 1);
				
				rooms = maze.GetRow(randRow);
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
				maze.SetRow(randRow,rooms);
			}
			
			genMaze(maze, $startx, $startz, wall);
			
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
		protected function combineSets($r:MazeRoom, $row:int, $col:int, $maze:Maze, $dropRow:Boolean):void
		{
			var nextRoom:MazeRoom = null;
			// grab the neighboring room
			if ($dropRow)
				nextRoom = $maze.GetRoom($row - 1,$col);
			else
				nextRoom = $maze.GetRoom($row, $col - 1);
			
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
			for (var row:int = 0; row < $maze.Rows; row++)
			{
				rowRoom = $maze.GetRow(row);
				for (var col:int = 0; col < $maze.Columns; col++)
				{
					if (rowRoom[col].Set == nextSet)
						rowRoom[col].Set = curSet;
				}
				$maze.SetRow(row, rowRoom);
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
		protected function buildRooms($maze:Maze):void
		{
			var rowRooms:Vector.<MazeRoom>;
			// create the rooms
			var sets:int = 0;
			for (var row:int = 0; row < $maze.Rows; row++)
			{
				rowRooms = new Vector.<MazeRoom>();
				for (var col:int = 0; col < $maze.Columns; col++)
				{
					rowRooms[col] = new MazeRoom(sets);
					sets++;
				}	
				$maze.SetRow(row, rowRooms);
			}
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
		protected function genMaze($maze:Maze, $startx:Number, $startz:Number, $wall:Asset):void
		{
			// get the bounds from the wall
			Bounds.getMeshBounds(Mesh($wall.model));
			var walldepth:Number = Bounds.depth;
			var wallwidth:Number = Bounds.width;
			var wallheight:Number = Bounds.height;
			
			$startx += walldepth * 0.5 + wallwidth * 0.5;
			$startz += walldepth * 0.5 + wallwidth * 0.5;
			
			var spacing:Number = walldepth;
			
			// declare some variables to help with the build process
			var rowwall:Asset;
			var colwall:Asset;
			var x:Number;
			var z:Number;
			var room:MazeRoom;
			var roomRow:Vector.<MazeRoom>;
			
			// assign walls to each room
			for (var row:int = 0; row < $maze.Rows; row++)
			{
				// null the walls out each time through to prevent any walls from being messed up or carried over
				rowwall = null
				colwall = null;
				for (var col:int = 0; col < $maze.Columns; col++)
				{
					roomRow = $maze.GetRow(row);
					if (roomRow[col].HasRowWall) // row wall only
					{
						x = $startx;
						z = $startz - walldepth * 0.5;
						rowwall = $wall.clone();
						rowwall.rotateTo(new Vector3D(0, 90, 0));
						rowwall.transformTo(new Vector3D(x + col * spacing, 0, z + row * spacing));
					}
					
					if (roomRow[col].HasColumnWall) // col wall only
					{
						
						x = $startx - walldepth * 0.5;
						z = $startz;
						colwall = $wall.clone();
						colwall.transformTo(new Vector3D(x + col * spacing, 0, z + row * spacing));
						//colwall = AssetBuilder.cloneRigidBody($rb, AssetBuilder.BOX , AssetBuilder.STATIC);
						//colwall.position = new Vector3D(x + col * spacing, 0, z + row * spacing);
					}
					
					roomRow[col].ColumnWall = colwall;
					roomRow[col].RowWall = rowwall;
					
					$maze.SetRow(row, roomRow);
				}
			}
			//*
			// The logic for border walls, although it can be integrated into the for loop above, is complicated and it's very easy
			// to get turned around. Therefore I've put it in it's own section to minimize confusion
			
			// We need column walls for the number of rows there are
			var colWallBorder:Vector.<Asset> = new Vector.<Asset>($maze.Rows, true);
			// Same for row walls but for the number of columns
			var rowWallBorder:Vector.<Asset> = new Vector.<Asset>($maze.Columns, true);
			// stupid flash and it's non-going-out-of-scopeness-confusion
			var i:int;
			// ===== add border walls =====
			// Using the starting x and y from the columns because even though it's a row wall, it needs to match up
			// to the starting of the columns.
			x = $startx;
			z = $startz - walldepth * 0.5;
			for (i = 0; i < $maze.Columns; i++)
			{
				rowWallBorder[i] = $wall.clone();
				rowWallBorder[i].rotateTo(new Vector3D(0, 90, 0));
				rowWallBorder[i].transformTo(new Vector3D(x + i * spacing, 0, z + $maze.Rows * spacing));
			}
			
			//*
			// same concept of using the starting x and y for the rows because they need to match up since this will
			// be covering the columns
			x = $startx - walldepth * 0.5;
			z = $startz;
			for (i = 0; i < $maze.Rows; i++)
			{
				colWallBorder[i] = $wall.clone();
				colWallBorder[i].transformTo(new Vector3D(x + $maze.Columns * spacing, 0, z + i * spacing));
			}
			//*/
			
			$maze.RowBorder = rowWallBorder;
			$maze.ColumnBorder = colWallBorder;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the model used to build the maze
		 *
		 * @param	$rb		The rigidbody that stores the mesh
		 * @return			The rigidbody that stores the mesh
		 */
		public function get WallAsset():Asset
		{
			return _wall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set WallAsset($wall:Asset):void
		{
			_wall = $wall;
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