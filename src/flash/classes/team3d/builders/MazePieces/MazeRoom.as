package team3d.builders.MazePieces
{
	import awayphysics.dynamics.AWPRigidBody;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class MazeRoom 
	{
		private var _rowWall	:AWPRigidBody;
		private var _colWall	:AWPRigidBody;
		
		public function MazeRoom($rowWall:AWPRigidBody, $colWall:AWPRigidBody)
		{
			_rowWall = $rowWall;
			_colWall = $colWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the row wall
		 *
		 * @return		Returns the row wall that the room has
		 */
		public function get RowWall():AWPRigidBody
		{
			return _rowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets the column wall
		 *
		 * @return		Returns the column wall that the room has
		 */
		public function get ColumnWall():AWPRigidBody
		{
			return _colWall;
		}
	}
	
}