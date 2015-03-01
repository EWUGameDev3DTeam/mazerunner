package team3d.screens
{
	import adobe.utils.CustomActions;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.objects.World;
	import team3d.ui.Button;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class ControlsScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function ControlsScreen()
		{
			super();
			
			DoneSignal = new Signal();
			_screenTitle = "Controls";
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			var queue:LoaderMax = new LoaderMax( { onComplete: show } );
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayCredits", container:this, width:this.stage.stageWidth, height:this.stage.stageHeight, scaleMode:"stretch" } );
			var keys:ImageLoader = new ImageLoader("images/Controls/KeysDone.png", { name:"movekeys", container:this } );
			var mouseMove:ImageLoader = new ImageLoader("images/Controls/Move.png", { name:"mouseMove", container:this } );
			var shift:ImageLoader = new ImageLoader("images/Controls/ShiftKey.png", { name:"shiftMove", container:this } );
			
			queue.append(overlay);
			queue.append(keys);
			queue.append(mouseMove);
			queue.append(shift);
			queue.load();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		private function show($e:LoaderEvent = null):void
		{
			var keys:Sprite = LoaderMax.getContent("movekeys");
			keys.scaleX = 0.4;
			keys.scaleY = 0.4;
			keys.x = 175;
			keys.y = 50;
			
			var mouseMove:Sprite = LoaderMax.getContent("mouseMove");
			mouseMove.scaleX = 0.5;
			mouseMove.scaleY = 0.5;
			mouseMove.x = this.width - mouseMove.width - 125;
			mouseMove.y = 100;
			
			var shiftMove:Sprite = LoaderMax.getContent("shiftMove");
			shiftMove.scaleX = 0.4;
			shiftMove.scaleY = 0.4;
			shiftMove.x = 30;
			shiftMove.y = keys.y + keys.height * 0.4 + 10;
			
			var format:TextFormat = new TextFormat();
			format.size = 35;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.name = "controls";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "W - Move Forward";
			tf.appendText("\nA - Strafe Left");
			tf.appendText("\nS - Strafe Right");
			tf.appendText("\nD - Move Backward");
			tf.appendText("\nShift - Walk");
			tf.x = 50;
			tf.y = this.height - tf.height - 100;
			this.addChild(tf);
			
			tf = new TextField();
			tf.name = "mouseMoveText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Use the mouse to look around.";
			tf.x = mouseMove.x + (mouseMove.width - tf.width) * 0.5;
			tf.y = mouseMove.y + mouseMove.height + 20;
			this.addChild(tf);
			
			var btnContinue:Button = new Button();
			btnContinue.text("Continue");
			btnContinue.width = 200;
			btnContinue.height = 100;
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnContinue.textFormat = format;
			btnContinue.x = this.width * 0.5 - btnContinue.width * 0.5;
			btnContinue.y = this.height - btnContinue.height - 20;
			this.addChild(btnContinue);
			
			btnContinue.addEventListener(MouseEvent.CLICK, doneClick);
			TweenMax.fromTo(this, 1, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function doneClick($e:MouseEvent):void 
		{
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			super.End();
			
			hide();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Hides the screen
		 */
		protected function hide():void
		{
			TweenMax.fromTo(this, 1, { autoAlpha:1 }, { autoAlpha:0, onComplete:destroy } );
		}
		
		/* ---------------------------------------------------------------------------------------- */		
		
		/**
		 * Relinquishes all memory used by this object.
		 */
		override protected function destroy($e:LoaderEvent = null):void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
				
			super.destroy();
		}
	}
}