package team3d.screens
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
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
	public class WonScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function WonScreen()
		{
			super();
			
			DoneSignal = new Signal();
			_screenTitle = "Won";
			
			initComps();
		}
		
		private function initComps():void
		{
			var overlay:Sprite = LoaderMax.getContent("overlayWon");
			overlay.width = World.instance.stage.stageWidth;
			overlay.height = World.instance.stage.stageHeight;
			this.addChild(overlay);
			
			var man:Sprite = LoaderMax.getContent("runningManWon");
			man.x = this.width * 0.5 - man.width * 0.5;
			man.y = 150;
			this.addChild(man);
			
			var arrow:Sprite = LoaderMax.getContent("wonArrow0");
			arrow.height = man.height - 80;
			arrow.scaleX = 0.7;
			arrow.x = 50;
			arrow.y = man.y + (man.height - arrow.height) * 0.5;
			this.addChild(arrow);
			
			var arrow1:Sprite = LoaderMax.getContent("wonArrow1");
			arrow1.height = arrow.height;
			arrow1.width = arrow.width;
			arrow1.x = arrow.x + arrow.width * 0.5 + 20;
			arrow1.y = arrow.y;
			this.addChild(arrow1);
			
			arrow = LoaderMax.getContent("wonArrow2");
			arrow.height = arrow1.height;
			arrow.width = arrow1.width;
			arrow.x = this.width - arrow.width - 20;
			arrow.y = arrow1.y;
			this.addChild(arrow);
			
			arrow1 = LoaderMax.getContent("wonArrow3");
			arrow1.height = arrow.height;
			arrow1.width = arrow.width;
			arrow1.x = arrow.x - arrow.width * 0.5 - 20;
			arrow1.y = arrow.y;
			this.addChild(arrow1);
			
			var format:TextFormat = new TextFormat();
			format.size = 80;
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
			tf.text = "Freedom!";
			tf.x = this.width * 0.5 - tf.textWidth * 0.5;
			tf.y = 100;
			this.addChild(tf);
			
			tf = new TextField();
			tf.name = "wonText";
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			tf.defaultTextFormat = format;
			
			tf.text = "You escaped from the maze within the given time.";
			tf.appendText("\nAfter your ordeal, you have decided to live a");
			tf.appendText("\nbetter life. You earned your freedom.");
			tf.x = 50;
			tf.y = this.height - tf.textHeight - 100;
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
			btnContinue.x = this.width - btnContinue.width - 10;
			btnContinue.y = this.height - btnContinue.height - 10;
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
			
			SoundAS.playFx("VictorySound");
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 0 }, { autoAlpha:1 } );
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
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha:1 }, { autoAlpha:0 } );
		}
	}
}