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
	public class LostScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function LostScreen()
		{
			super();
			
			DoneSignal = new Signal();
			_screenTitle = "Lost";
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			var queue:LoaderMax = new LoaderMax( { onComplete: show } );
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayLost", container:this, width:this.stage.stageWidth, height:this.stage.stageHeight, scaleMode:"stretch" } );
			var grave:ImageLoader = new ImageLoader("images/GUI/Man_Sad.png", { name: "grave0", container:this } );
			var grave1:ImageLoader = new ImageLoader("images/GUI/Man_Sad.png", { name: "grave1", container:this } );
			var grave2:ImageLoader = new ImageLoader("images/GUI/Man_Sad.png", { name: "grave2", container:this } );
			var cross:ImageLoader = new ImageLoader("images/GUI/Cross.png", { name:"cross", container:this } );
			
			queue.append(overlay);
			queue.append(grave);
			queue.append(grave1);
			queue.append(grave2);
			queue.append(cross);
			queue.load();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		private function show($e:LoaderEvent = null):void
		{
			var man:Sprite = LoaderMax.getContent("grave0");
			man.x = this.width * 0.5 - man.width * 1.5;
			man.y = 125;
			man = LoaderMax.getContent("grave1");
			man.x = this.width * 0.5 - man.width;
			man.y = 120;
			man = LoaderMax.getContent("grave2");
			man.x = this.width * 0.5 + man.width;
			man.y = 125;
			man.scaleX = -1;
			var cross:Sprite = LoaderMax.getContent("cross");
			cross.scaleX = cross.scaleY = 0.75;
			cross.x = this.width * 0.5 - cross.width * 0.5;
			cross.y = 150;
			
			var format:TextFormat = new TextFormat();
			format.size = 45;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.name = "titleText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "You failed to get to the exit in time.";
			tf.appendText("\nYou knew the penalty, you will die here.");
			tf.x = 50;
			tf.y = 360;
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