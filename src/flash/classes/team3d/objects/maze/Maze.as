package team3d.objects.maze
{
	import awayphysics.dynamics.AWPRigidBody;
	import team3d.objects.maze.MazeRoom;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class Maze 
	{
		/* ---------------------------------------------------------------------------------------- */
		
		private var _rooms		:Vector.<Vector.<MazeRoom>>;
		private var _colWall	:Vector.<AWPRigidBody>;
		private var _rowWall	:Vector.<AWPRigidBody>;
		private var _rows		:int;
		private var _cols		:int;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Creates a new maze
		 */
		public function Maze($rows:int, $cols:int)
		{
			_rows = $rows;
			_cols = $cols;
			_rooms = new Vector.<Vector.<MazeRoom>>(_rows * _cols, true);
			_colWall = new Vector.<AWPRigidBody>(_rows, true);
			_rowWall = new Vector.<AWPRigidBody>(_cols, true);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the specified room
		 *
		 * @param	$row	The maze row associated with the room
		 * 			$col	The maze column associated with the room
		 * @return			The maze room requested
		 */
		public function GetRoom($row:int, $col:int):MazeRoom
		{
			return _rooms[$row][$col];
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the row border wall
		 *
		 * @param	$rowWall	The row border wall
		 * @return			The row border wall
		 */
		public function get RowBorder():Vector.<AWPRigidBody>
		{
			return _rowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set RowBorder($rowWall:Vector.<AWPRigidBody>):void
		{
			_rowWall = $rowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the column wall border
		 *
		 * @param	$colWall	The column wall border
		 * @return			The column wall border
		 */
		public function get ColumnBorder():Vector.<AWPRigidBody>
		{
			return _colWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set ColumnBorder($colWall:Vector.<AWPRigidBody>):void
		{
			_colWall = $colWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Adds the given mazeroom $room to the current maze at the location $x,$y
		 * @param	$room		The room to add
		 * @param	$row		The row to add the room to
		 * @param	$col		The col to add the room to
		 */
		public function AddRoom($room:MazeRoom, $row:int, $col:int):void
		{
			if (_rooms[$row][$col] == null)
			{
				var row:Vector.<MazeRoom> = _rooms[$row];
				row[$col] = $room;
				_rooms[$row] = row;
			}
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the number of rows the maze has
		 *
		 * @return		The number of rows
		 */
		public function get Rows():int
		{
			return _rows;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the number of columns the maze has
		 *
		 * @return		The number of columns
		 */
		public function get Columns():int
		{
			return _cols;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the row of rooms
		 *
		 * @return		The row of rooms
		 */
		public function GetRow($row:int):Vector.<MazeRoom>
		{
			return _rooms[$row];
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function SetRow($row:int, $rooms:Vector.<MazeRoom>):void
		{
			_rooms[$row] = $rooms;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the rooms for the maze
		 *
		 * @param	$rooms	The rooms
		 * @return			The rooms
		 */
		public function get Rooms():Vector.<Vector.<MazeRoom>>
		{
			return _rooms;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set Rooms($rooms:Vector.<Vector.<MazeRoom>>):void
		{
			_rooms = $rooms;
		}
	}
}