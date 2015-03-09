package team3d.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import team3d.objects.World;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	//http://www.emanueleferonato.com/2010/08/04/changing-a-movieclip-registration-point-on-the-fly-with-as3/
	public class Monster2D extends Sprite 
	{
		/* ---------------------------------------------------------------------------------------- */
		//http://gamedevelopment.tutsplus.com/tutorials/understanding-steering-behaviors-seek--gamedev-849
		public static const MAX_FORCE 		:Number = 2.4;
		public static const MAX_VELOCITY 	:Number = 3;
		public static const SENSITIVITY		:Number = 0.5;
		
		private var position 	:Vector3D;
		private var velocity 	:Vector3D;
		private var target 		:Vector3D;
		private var desired 	:Vector3D;
		private var steering 	:Vector3D;
		private var mass		:Number;
		/* ---------------------------------------------------------------------------------------- */
		
		private var new_reg_x, new_reg_y:int;
		
		public function Monster2D($m:Sprite)
		{
			this.addChild($m);
			new_reg_x = $m.width * 0.5;
			new_reg_y = $m.height * 0.5;
			this.addEventListener(Event.ADDED_TO_STAGE, on_added);
			
			/* ---------------------------------------------------------------------------------------- */
			//http://gamedevelopment.tutsplus.com/tutorials/understanding-steering-behaviors-seek--gamedev-849
			position = new Vector3D(World.instance.stage.stageWidth * 0.5, World.instance.stage.stageHeight * 0.5);
			velocity = new Vector3D( -1, -2);
			target = new Vector3D(0, 0);
			desired = new Vector3D(0, 0);
			steering = new Vector3D(0, 0);
			mass = 5;
			/* ---------------------------------------------------------------------------------------- */
		}
		
		private function on_added(e:Event)
		{
			var rect:Rectangle=getBounds(this);
			var x_offset=new_reg_x+rect.x;
			var y_offset=new_reg_y+rect.y
			// updating container position
			x+=x_offset;
			y+=y_offset;
			for (var i:uint = 0; i < numChildren; i++)
			{
				// updating children position
				getChildAt(i).x-=x_offset;
				getChildAt(i).y-=y_offset;
			}
		}
		
		public function Begin():void
		{
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		//http://gamedevelopment.tutsplus.com/tutorials/understanding-steering-behaviors-seek--gamedev-849
		public function set Target($t:Vector3D):void
		{
			position = new Vector3D(this.x, this.y);
			target	 = $t;
			
			truncate(velocity, MAX_VELOCITY);
		}
		
		private function seek(target:Vector3D):Vector3D
		{
			var force :Vector3D;
			desired = target.subtract(position);
			desired.normalize();
			
			desired.scaleBy(MAX_VELOCITY);
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		private function truncate(vector:Vector3D, max:Number):void
		{
			var i :Number;

			i = max / vector.length;
			i = i < 1.0 ? 1.0 : i;
			
			vector.scaleBy(i);
		}
		
		private function enterFrame($e:Event):void
		{
			if(Math.abs(this.x - target.x) >= SENSITIVITY && Math.abs(this.y - target.y) >= SENSITIVITY)
			{
				steering = seek(target);
				
				truncate(steering, MAX_FORCE);
				steering.scaleBy(1 / mass);
				
				velocity = velocity.add(steering);
				truncate(velocity, MAX_VELOCITY);
				
				position = position.add(velocity);
				
				this.x = position.x;
				this.y = position.y;
				
				//http://gamedev.stackexchange.com/questions/24322/rotating-sprite-to-face-cursor
				this.rotation = -(Math.atan2(this.x - target.x, this.y - target.y) * 180 / Math.PI) + 90;	
			}
		}
		/* ---------------------------------------------------------------------------------------- */
		
		public function End():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
	}
	
}