package team3d.utils.pathfinding
{
	import team3d.utils.pathfinding.PathNode;
	import team3d.objects.maze.MazeRoom;
	import team3d.utils.pathfinding.PathNode;
	
	import flash.geom.Vector3D;
	
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.primitives.CubeGeometry;
	import away3d.materials.ColorMaterial;
	import away3d.tools.helpers.data.MeshDebug;
	

	/**
	*	represents a set of pathnodes for naviagation
	*	@author Jakob Wilson
	*/
	public class NavGraph 
	{
		public static const INFINITY:Number = 10000000000000000000000000.0;
		
		private var waypoints:Vector.<PathNode> = new Vector.<PathNode>;
		
		public function NavGraph() 
		{
			
		}
		
		
		/**
		*	Generates a set of pathnodes based on a set of mazerooms
		*/
		public function genFromMaze(maze:Vector.<Vector.<MazeRoom>>, offset:Vector3D)
		{
			var wallLength = 850;//change to param
			
			
			//Generate a grid of pathnodes
			var points:Vector.<Vector.<PathNode>> = new Vector.<Vector.<PathNode>>;
			trace("Offset " + offset);
			for(var z:int = 0; z < (maze.length/maze[0].length);z++)
			{
				points.push(new Vector.<PathNode>);
				for (var x:int = 0; x < maze[0].length; x++)
				{
					points[z].push(new PathNode(new Vector3D(x * wallLength + offset.x, offset.y, z * wallLength + offset.z)));
				}
			}
			
			//connect the dots!
			//use the maze information to see if two pathnodes are connected
			for(z = 0; z < (maze.length/maze[0].length);z++)	//for each cow
			{
				for (x = 0; x < (maze[0].length); x++)				//for each col
				{
					if(!maze[z][x].HasColumnWall && x > 0)				//if the column wall does not exist
						connect(points[z][x],points[z][x - 1]);				//connect the pathnodes
					
					if(!maze[z][x].HasRowWall && z > 0)					//if the row wall does not exist
						connect(points[z][x],points[z - 1][x]);				//connect the pathnodes
				}
			}
			
			//add the finished grid to the waypoint list
			for each(var v:Vector.<PathNode> in points)
			{
				for each(var p:PathNode in v)
				{
					this.waypoints.push(p);
				}
			}
		}
		
		/**
		*	Helper that connects two nodes together
		*/
		private function connect(a:PathNode, b:PathNode)
		{
			a.addAdjNode(b);
			b.addAdjNode(a);
		}
		
		/**
		*	Given a point in 3d space(as a vector3d), this will find the nearest pathnode to that point
		*/
		public function getNearestWayPoint(v:Vector3D):PathNode
		{	
			var ret:PathNode = waypoints[0];
			 
			for each(var i:PathNode in waypoints)
			{
				if(i.position.subtract(v).length <  ret.position.subtract(v).length)
					ret = i;
			}
			return ret;
		}
		
		
		/**
		* Finds a path between two pathnodes using dijkstra's algorithm
		* @NOTE: WIP
		*/
		public function getPath(start:PathNode, end:PathNode):Vector.<PathNode>
		{
			var openList:Vector.<ListItem> = new Vector.<ListItem>; 	// a vector to hold the open list
			var current:ListItem = null; 								//the current item we are starting at
			var closedList:Vector.<ListItem> = new Vector.<ListItem>;	//the list of nodes we have visited
			
			var add:ListItem = null;
			//fill it with nodes that have distance of infinity
			for each(var p:PathNode in this.waypoints)	
			{
				add = new ListItem(p, INFINITY)
				openList.push(add);
				if(add.node == start)
					current = add;
			}
			
			//check that the starting node is legit
			if(current == null)
				throw new Error("Starting node not found in waypoints");
			
			//set the startinf waypoint's distance to 0
			current.distance = 0;

			var curAdj:ListItem;	//a var to hold the current adjacency
			var temp:Number;		//a temporary variavbe to hold the calculated distance
			
			while(current.node != end && openList.length > 0)//while we have not found the end
			{
				openList.splice(openList.indexOf(current), 1);//remove current from the open list
				
				//update the distance for each of the adjacent values
				for each(var n:PathNode in current.node.adjacency)
				{
					if(current == null)
						throw new Error("No possible paths between pathnodes");
					
					//get the correct list item
					curAdj = getListItem(n,openList);
					//if the current adjacency id not in the open list(it has already been checked), conntinue
					if(curAdj == null)
						continue;
					
					//calculate the distance between two points, and if it is saller than the existing assigned, distance, update it
					temp = current.distance + (curAdj.node.position.subtract(current.node.position).length);
					if(temp < curAdj.distance)	//assign if smaller
						curAdj.distance = temp;
					
				}
				//now that we have checked all the andjacencies of current, we can push it to the closed list
				closedList.push(current);
				
				//we now select the next closest node to check
				current = selectClosestNode(openList);
				
				//if the current node is the end node, we are done
				if(current.node == end)
					break;
			}
			
			//ensure that we remove the current(end) node from the open list and add it to the closed list
			openList.splice(openList.indexOf(current), 1);
			closedList.push(current);
			
			
			//Now that we have found the path, we backtrack from the end node, selecting all of the nodes with the shortest
			//distance from the start node, this is our finished path
			
			var finalPath:Vector.<PathNode> = new Vector.<PathNode>;	//A vector to hold the final path
			var shortestAdj:ListItem;									//an adjacency to hold the shortest adjacenct
			
			while(current.node != start)
			{

				finalPath.push(current.node);//push cur.node to final path
				
				shortestAdj = new ListItem(null, INFINITY);
				
				
				for each(var x:PathNode in current.node.adjacency)
				{
					curAdj = getListItem(x, closedList);
					if(curAdj == null)
						continue;
					
					if(curAdj.distance < shortestAdj.distance)
						shortestAdj = curAdj;
				}
				//closedList.splice(closedList.indexOf(current), 1);
				current = shortestAdj;
			}
			
			finalPath.push(current.node);

			return finalPath;
			
		}
		/**
		*	Grabs the smallest node from a list
		*/
		private function selectClosestNode(list:Vector.<ListItem>):ListItem
		{
			var smallest:ListItem = list[0];
			
			for each (var x:ListItem in list)
			{
				if(x.distance < smallest.distance)
				{
					smallest = x;
				}
			}
			return smallest;
		}
		
		/**
		*	gets the list item version of a path node
		*/
		private function getListItem(n:PathNode, list:Vector.<ListItem>):ListItem
		{
			for each(var i:ListItem in list)
			{
				if(i.node == n)
					return i;
			}
			return null;
			//throw new Error("Could not find pathNode " + n.position);
		}
		
		/**
		*	returns a copy of the current waypoiny array
		*/
		public function getWaypointsCopy():Vector.<PathNode>
		{
			var ret:Vector.<PathNode> = new Vector.<PathNode>;
			for each(var p:PathNode in this.waypoints)
				ret.push(p);
			return ret;
		}
		
		/**
		*	Creates a mesh using cubes and lines to visualize the waypoint graph(NOTE: very inefficent, should only be used for testing)
		*/
		public function getWaypointMesh():ObjectContainer3D
		{
			var ret:ObjectContainer3D = new ObjectContainer3D();
			
			var segments:SegmentSet = new SegmentSet();
			
			for each(var p:PathNode in this.waypoints)
			{
				for each(var a:PathNode in p.adjacency)
				{
					segments.addSegment(new LineSegment(a.position, p.position, 0x0000FF, 0x0000FF, 2));
				}
			}
			ret.addChild(segments);
			
			var point:Mesh;
			for each(var q:PathNode in this.waypoints)
			{
				point = new Mesh(new CubeGeometry(45,45,45), new ColorMaterial(0xFFFFFF));
				point.position = q.position;
				ret.addChild(point);
			}
			return ret;
		}
		
		/**
		* generates a mesh that shows the path parameter as a set of red lines
		*/
		public static function getPathMesh(path:Vector.<PathNode>):ObjectContainer3D
		{
			var ret:ObjectContainer3D = new ObjectContainer3D();
			var segments:SegmentSet = new SegmentSet();
			 
			for (var i:int = 1; i < path.length;i++)
			{
				segments.addSegment(new LineSegment(path[i].position, path[i-1].position, 0x00FF00, 0x00FF00, 5));
			}
			ret.addChild(segments);
			return ret;
		}
	}
	

}


import team3d.utils.pathfinding.PathNode;

/**
*	A class to hold a path node and is current distance from the start node
*/
class ListItem
{
	public var node:PathNode;
	public var distance:Number;
	
	public function ListItem($node:PathNode, $distance:Number)
	{
		this.node = $node;
		this.distance = $distance;
	}
	
}
