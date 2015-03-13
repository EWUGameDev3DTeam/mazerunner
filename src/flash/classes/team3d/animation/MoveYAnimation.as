package team3d.animation
{
	import com.jakobwilson.Asset;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import team3d.screens.DebugScreen;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class MoveYAnimation extends Sprite
	{
		private var _asset				:Asset;
		private var _completed			:Function;
		private var _reverseCompleted	:Function;
		
		private var _paused				:Boolean;
		private var _reverse			:Boolean;
		
		private var _step				:Number;
		private var _stopY				:Number;
		private var _startY				:Number;
		
		public function MoveYAnimation($asset:Asset, $step:Number, $stopY:Number, $onComplete:Function = null, $onReverseComplete:Function = null)
		{
			_paused = false;
			_reverse = false;
			
			_asset = $asset;
			_step = $step;
			_stopY = $stopY;
			_startY = $asset.position.y;
			_completed = ($onComplete == null) ? donothing : $onComplete;
			_reverseCompleted = ($onReverseComplete == null) ? donothing : $onReverseComplete;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function Begin():void
		{
			if(!this.hasEventListener(Event.ENTER_FRAME))
				this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function Reverse():void
		{
			_reverse = !_reverse;
			Begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function Pause():void
		{
			_paused = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		public function Resume():void
		{
			_paused = false;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * This function is called automatically when the animation has completed but can be called sooner to interrupt the animation.
		 * If the desired affect is to pause the animation, use Pause().
		 */
		public function End():void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function enterFrame($e:Event):void
		{
			if (_paused) return;
			
			if (_reverse)
			{
				_asset.transformTo(new Vector3D(_asset.position.x, _asset.position.y + _step, _asset.position.z));
				if (_asset.position.y < _startY) return;
				_reverseCompleted.call();
				
			}
			else
			{
				_asset.transformTo(new Vector3D(_asset.position.x, _asset.position.y - _step, _asset.position.z));
				if (_asset.position.y > _stopY) return;
				_completed.call();
			}
			
			this.End();
		}
		
		private function donothing():void{}
	}
}