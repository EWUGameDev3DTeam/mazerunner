package team3d.screens
{
	import adobe.utils.CustomActions;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
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
	public class SettingsScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function SettingsScreen()
		{
			super();
			
			DoneSignal = new Signal();
			_screenTitle = "Settings";
			
			initComps();
		}
		
		private function initComps()
		{
			var overlay:Sprite = LoaderMax.getContent("overlaySettings");
			overlay.width = World.instance.stage.stageWidth;
			overlay.height = World.instance.stage.stageHeight;
			this.addChild(overlay);
			
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
			tf.text = "Settings";
			tf.x = this.width * 0.5 - tf.textWidth * 0.5;
			tf.y = 100;
			this.addChild(tf);
			
			format = new TextFormat();
			format.size = 60;
			format.bold = true;
			
			tf = new TextField();
			tf.name = "settingsText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
            tf.mouseEnabled = false;
            tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Audio\nMouse X\nMouse Y\nInvert Y";
			tf.x = 50;
			tf.y = 200;
			this.addChild(tf);
			
			var btnCancel:Button = new Button();
			btnCancel.text("Cancel");
			btnCancel.width = 200;
			btnCancel.height = 100;
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnCancel.textFormat = format;
			btnCancel.x = this.width * 0.5 - btnCancel.width * 2;
			btnCancel.y = this.height - btnCancel.height - 20;
			this.addChild(btnCancel);
			
			var btnSave:Button = new Button();
			btnSave.text("Save");
			btnSave.width = 200;
			btnSave.height = 100;
			format = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btnSave.textFormat = format;
			btnSave.x = this.width * 0.5 + btnSave.width;
			btnSave.y = this.height - btnSave.height - 20;
			this.addChild(btnSave);
			
			btnCancel.addEventListener(MouseEvent.CLICK, cancelClicked);
			btnSave.addEventListener(MouseEvent.CLICK, saveClicked);
			
			var spacing:int = 65;
			var audioSlider:Slider = new Slider();
			audioSlider.width = 400;
			audioSlider.maximum = 100;
			audioSlider.minimum = 0;
			audioSlider.tickInterval = 0;
			audioSlider.getChildAt(0).height = 10;
			audioSlider.getChildAt(1).width = 20;
			audioSlider.getChildAt(1).height = 20;
			audioSlider.getChildAt(1).y -= 3;
			audioSlider.x = this.width - audioSlider.width - 100;
			audioSlider.y = tf.y + 35;
			this.addChild(audioSlider);
			
			var mouseYsensitivity:Slider = new Slider();
			mouseYsensitivity.width = 400;
			mouseYsensitivity.maximum = 100;
			mouseYsensitivity.minimum = 0;
			mouseYsensitivity.tickInterval = 0;
			mouseYsensitivity.getChildAt(0).height = 10;
			mouseYsensitivity.getChildAt(1).width = 20;
			mouseYsensitivity.getChildAt(1).height = 20;
			mouseYsensitivity.getChildAt(1).y -= 3;
			mouseYsensitivity.x = audioSlider.x;
			mouseYsensitivity.y = audioSlider.y + spacing;
			this.addChild(mouseYsensitivity);
			
			var mouseXsensitivity:Slider = new Slider();
			mouseXsensitivity.width = 400;
			mouseXsensitivity.maximum = 100;
			mouseXsensitivity.minimum = 0;
			mouseXsensitivity.tickInterval = 0;
			mouseXsensitivity.getChildAt(0).height = 10;
			mouseXsensitivity.getChildAt(1).width = 20;
			mouseXsensitivity.getChildAt(1).height = 20;
			mouseXsensitivity.getChildAt(1).y -= 3;
			mouseXsensitivity.x = mouseYsensitivity.x;
			mouseXsensitivity.y = mouseYsensitivity.y + spacing;
			this.addChild(mouseXsensitivity);
			
			var invertY:CheckBox = new CheckBox();
			invertY.label = "";
			invertY.x = mouseXsensitivity.x + mouseXsensitivity.width * 0.5 - invertY.width * 0.5;
			invertY.y = mouseXsensitivity.y + spacing;
			this.addChild(invertY);
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
		
		private function cancelClicked($e:MouseEvent):void 
		{
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function saveClicked($e:MouseEvent):void
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