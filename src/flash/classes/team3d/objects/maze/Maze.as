package team3d.objects.maze
{
	import awayphysics.dynamics.AWPRigidBody;
	import team3d.builders.MazePieces.MazeRoom;
	
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
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Creates a new maze
		 */
		public function Maze($rows:int, $cols:int)
		{
			_rooms = new Vector.<Vector.<MazeRoom>>($rows * $cols, true);
			_colWall = new Vector.<AWPRigidBody>($cols, true);
			_rowWall = new Vector.<AWPRigidBody>($rows, true);
		}
		
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
			return _rowWall.length;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Returns the number of columns the maze has
		 *
		 * @return		The number of columns
		 */
		public function get Columns():int
		{
			return _colWall.length;
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