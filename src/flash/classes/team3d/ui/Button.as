package team3d.ui
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class Button extends Sprite
	{
		private static var ButtonCount:int = 0;
		
		private var _btnID:int;
		
		private var _idle:Sprite;
		private var _down:Sprite;
		private var _hover:Sprite;
		private var _text:TextField;
		
		public function Button()
		{
			super();
			_btnID = ButtonCount++;
			this.useHandCursor = true;
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseHover);
			this.addEventListener(MouseEvent.ROLL_OVER, mouseHover);
			
			var imgWidth:int = 300;
			var imgHeight:int = 150;
			
			_text = new TextField();
			_text.autoSize = TextFieldAutoSize.CENTER;
			_text.mouseEnabled = false;
			_text.width = imgWidth;
			_text.height = imgHeight;
			
			var queue:LoaderMax = new LoaderMax( { onComplete:completed } );
			var idle:ImageLoader = new ImageLoader("images/Button/ButtonStill.png", { name: ("idle" + _btnID), container:this, width:imgWidth, height:imgHeight, alpha:1 } );
			var down:ImageLoader = new ImageLoader("images/Button/ButtonDown.png", { name:("down" + _btnID), container:this, visible:false, width:imgWidth, height:imgHeight, alpha:1 } );
			var hover:ImageLoader = new ImageLoader("images/Button/ButtonHover.png", { name:("hover" + _btnID), container:this, visible:false, width:imgWidth, height:imgHeight, alpha:1 } );
			
			queue.append(idle);
			queue.append(down);
			queue.append(hover);
			queue.load();
		}
		
		private function completed($e:LoaderEvent):void 
		{
			this.addChild(_text);
		}
		
		public function text($s:String, $append:Boolean = false):void
		{
			if ($append)
				_text.appendText($s);
			else
				_text.text = $s;
			
			var idle:DisplayObject = this.getChildByName("idle" + _btnID);
				
			_text.x = idle.width * 0.5 - _text.width * 0.5;
			_text.y = idle.height * 0.5 - _text.textHeight * 0.5 - 5;
		}
		
		public function set textFormat($tf:TextFormat):void
		{
			_text.defaultTextFormat = $tf;
			
			if(_text.length > 0)
				text(_text.text, false);
		}
		
		public function get textFormat():TextFormat
		{
			return _text.defaultTextFormat;
		}
		
		private function mouseOut(e:MouseEvent):void 
		{
			this.getChildByName("down" + _btnID).visible = false;
			this.getChildByName("hover" + _btnID).visible = false;
			this.getChildByName("idle" + _btnID).visible = true;
		}
		
		private function mouseHover(e:MouseEvent):void 
		{
			this.getChildByName("idle" + _btnID).visible = false;
			this.getChildByName("down" + _btnID).visible = false;
			this.getChildByName("hover" + _btnID).visible = true;
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			this.getChildByName("idle" + _btnID).visible = false;
			this.getChildByName("hover" + _btnID).visible = false;
			this.getChildByName("down" + _btnID).visible = true;
		}
	}
}