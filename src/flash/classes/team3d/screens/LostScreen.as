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
	import team3d.ui.GameButton;
	import treefortress.sound.SoundAS;
	
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
			
			initComp();
		}
		
		private function initComp():void
		{
			var overlay:Sprite = LoaderMax.getContent("overlayLost");
			overlay.width = World.instance.stage.stageWidth;
			overlay.height = World.instance.stage.stageHeight;
			this.addChild(overlay);
			
			var man:Sprite = LoaderMax.getContent("grave0");
			man.x = this.width * 0.5 - man.width * 1.5;
			man.y = 125;
			this.addChild(man);
			
			man = LoaderMax.getContent("grave1");
			man.x = this.width * 0.5 - man.width;
			man.y = 120;
			this.addChild(man);
			
			man = LoaderMax.getContent("grave2");
			man.x = this.width * 0.5 + man.width;
			man.y = 125;
			man.scaleX = -1;
			this.addChild(man);
			
			var cross:Sprite = LoaderMax.getContent("cross");
			cross.scaleX = cross.scaleY = 0.75;
			cross.x = this.width * 0.5 - cross.width * 0.5;
			cross.y = 150;
			this.addChild(cross);
			
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
			
			var btnContinue:GameButton = new GameButton();
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
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function doneClick($e:MouseEvent):void 
		{
			SoundAS.playFx("Button");
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			super.End();
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha:1 }, { autoAlpha:0 } );
		}
	}
}