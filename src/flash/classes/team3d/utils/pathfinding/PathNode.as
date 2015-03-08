package team3d.utils.pathfinding
{
	import flash.geom.Vector3D;
	import away3d.containers.ObjectContainer3D;

	/**
	*	A simple pathnode for use in the NavGraph
	*	@author Jakob Wilson
	*/
	public class PathNode extends ObjectContainer3D
	{
		private var _adj:Vector.<PathNode> = new Vector.<PathNode>;
		
		public function PathNode($position:Vector3D = null)
		{
			if($position != null)
				this.position = $position;
			else
				this.position = new Vector3D();
		}
		
		/**
		*	Lists an pathNode as being adjacent(accessable)
		*/
		public function addAdjNode($a:PathNode)
		{
			if($a != null)
				this._adj.push($a);
				//this._adj.push(new adjacency($a, $a.position.subtract(this.position).length);//<If we need distance
		}	
		
		/**
		*	Removes a pathNode from being adjacent(accessable)
		*/
		public function removeAdjNode($a:PathNode)
		{
			if($a != null)
				this._adj.splice(this._adj.indexOf($a), 1);
		}
		
		public function get adjacency():Vector.<PathNode>
		{
			return this._adj;
		}
	}
	/**
	* For possible future use if we need non-uniform distance
	public class adjacency
	{
		public var target:PathNode;
		public var distance:Number;
		
		public function adjacency($targer:PathNode, $distance:Number)
		{
			this.target = $target;
			this.distance = $distance;
		}

	}*/
}
