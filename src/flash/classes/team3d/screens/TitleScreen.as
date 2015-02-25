package team3d.screens
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.utils.World;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class TitleScreen extends Sprite
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function TitleScreen()
		{
			super();
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		public function Begin():void
		{
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.background = true;
			tf.backgroundColor = 0xFFFFFF;
			tf.border = true;
			tf.borderColor = 0xCC0066;
			tf.visible = true;
			tf.alpha = 1;
			
			tf.x = tf.y = 100;
			tf.text = "This is in the title screen";
			//this.addChild(tf);
			Show();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Shows the screen
		 */
		public function Show():void
		{
			
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

