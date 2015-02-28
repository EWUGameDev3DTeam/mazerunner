package team3d.screens
{
	import com.greensock.loading.LoaderMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.objects.World;

	
	/**
	 * 
	 * 
	 * @author Nate Chatellier
	 */
	public class DebugScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		private static var _text:TextField = new TextField();
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the DebugScreen object.
		 */
		public function DebugScreen()
		{
			super();
			
			this.mouseEnabled	= false;
			this.mouseChildren	= false;
			World.instance.ScreenChange.add(clearText);
		}
		
		private function clearText():void 
		{
			DebugScreen.Text("");
		}
		
		public function Begin()
		{
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			_text.defaultTextFormat = format;
			_text.autoSize = TextFieldAutoSize.LEFT;
            _text.mouseEnabled = false;
            _text.selectable = false;
			_text.textColor = 0x000000;
			_text.background = true;
			_text.backgroundColor = 0xFFFFFF;
			_text.border = true;
			_text.borderColor = 0xCC0066;
			_text.visible = true;
			_text.alpha = 1;
			
			_text.x = _text.y = 0;
			this.addChild(_text);
		}
		
		public static function Text($s:String, $append:Boolean = false):void
		{
			if($append)
				_text.appendText($s);
			else
				_text.text = $s;
			
			if (_text.length < 1)
				_text.visible = false;
			else if(!_text.visible)
				_text.visible = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
	}
}

