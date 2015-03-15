package team3d.objects.maze {
	import adobe.utils.CustomActions;
	import com.jakobwilson.Asset;
	import com.jakobwilson.Cannon.Cannon;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class MazeRoom
	{
		private var _cannons	:Vector.<Cannon>;
		private var _rowWall	:Asset;
		private var _colWall	:Asset;
		private var _floor		:Asset;
		private var _set		:int;
		private var _hasRowWall	:Boolean;
		private var _hasColWall	:Boolean;
		
		public function MazeRoom($set:int)
		{
			_set = $set;
			_hasColWall = _hasRowWall = true;
			_cannons = new Vector.<Cannon>();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Determines if the room has a row wall
		 *
		 * @param	$hasRowWall	
		 * @return				
		 */
		public function get HasRowWall():Boolean
		{
			return _hasRowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set HasRowWall($hasRowWall:Boolean):void
		{
			_hasRowWall = $hasRowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Determines if the room has a column wall
		 *
		 * @param	$hasColumnWall	
		 * @return					
		 */
		public function get HasColumnWall():Boolean
		{
			return _hasColWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set HasColumnWall($hasColumnWall:Boolean):void
		{
			_hasColWall = $hasColumnWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets which set the room is associated qith
		 *
		 * @param	$set	The set for the room
		 * @return			The set for the room
		 */
		public function get Set():int
		{
			return _set;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set Set($set:int):void
		{
			_set = $set;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the Row Wall rigid body
		 *
		 * @param	$rowWall	The rigid body of the row wall
		 * @return				The rigid body of the row wall
		 */
		public function get RowWall():Asset
		{
			return _rowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set RowWall($rowWall:Asset):void
		{
			_rowWall = $rowWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the Column Wall rigid body
		 *
		 * @param	$colWall	The rigid body of the col wall
		 * @return				The rigid body of the col wall
		 */
		public function get ColumnWall():Asset
		{
			return _colWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set ColumnWall($colWall:Asset):void
		{
			_colWall = $colWall;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function addCannon($cannon:Cannon):void
		{
			if (_cannons.indexOf($cannon) > -1)
				return;
			
			_cannons.push($cannon);
		}
		
		public function removeCannon($cannon:Cannon):void
		{
			var index:int = _cannons.indexOf($cannon);
			if (index < 0)
				return;
			
			_cannons.splice(index, 1);
		}
		
		public function endCannons():void
		{
			for each(var c:Cannon in _cannons)
				c.End();
			
			_cannons = null;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Gets or sets the rooms floor
		 *
		 * @param	$floor	The floor asset of the room
		 * @return			The floor asset of the room
		 */
		public function get Floor():Asset
		{
			return _floor;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function set Floor($floor:Asset):void
		{
			_floor = $floor;
		}
	}
	
}