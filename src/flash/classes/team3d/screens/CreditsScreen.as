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
	public class CreditsScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function CreditsScreen()
		{
			super();
			
			DoneSignal = new Signal();
			_screenTitle = "Credits";
			
			initComps();
		}
		
		private function initComps():void
		{
			var overlay:Sprite = LoaderMax.getContent("overlayCredits");
			overlay.width = World.instance.stage.stageWidth;
			overlay.height = World.instance.stage.stageHeight;
			this.addChild(overlay);
			
			var man:Sprite = LoaderMax.getContent("manComputer");
			man.x = 50;
			man.y = 125;
			this.addChild(man);
			
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
			tf.text = "Credits";
			tf.x = this.width * 0.5 - tf.textWidth * 0.5;
			tf.y = 100;
			this.addChild(tf);
			
			tf = new TextField();
			tf.name = "creditsText";
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			format = new TextFormat();
			format.size = 15;
			format.bold = true;
			tf.defaultTextFormat = format;
			
			tf.text = "Lead Programmer - Dan Watt";
			tf.appendText("\ndanwatt24@gmail.com");
			tf.appendText("\n\nLead Artist & Programmer - Jake Wilson");
			tf.appendText("\njwshortcircuit@gmail.com");
			tf.appendText("\n\nLead Designer & Programmer - John McNutt");
			tf.appendText("\nmcnuttjohnathan@gmail.com");
			tf.appendText("\n\nAll Sound Effects and Game Screen Music - freesfx.co.uk");
			tf.appendText("\nTitle Screen Music - Youtube.com 'Sci Fi Music - Agoraphobia'");
			tf.appendText("\nAll Textures made using - CGTextures.com");
			tf.appendText("\nSkybox generator - Alex Peterson");
			tf.x = this.width * 0.5 - tf.width * 0.5;
			tf.y = this.getChildByName("titleText").y + this.getChildByName("titleText").height + 10;
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