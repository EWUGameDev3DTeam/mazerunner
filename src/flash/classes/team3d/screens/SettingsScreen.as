package team3d.screens
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.objects.World;
	import team3d.ui.GameButton;
	import team3d.utils.GameData;
	import team3d.utils.Utils;
	import treefortress.sound.SoundAS;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class SettingsScreen extends BaseScreen
	{
		private var _audioSlider		:Slider;
		private var _mouseYsensitivity	:Slider;
		private var _mouseXsensitivity	:Slider;
		private var _invertY			:CheckBox;
		private var _so					:SharedObject;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function SettingsScreen()
		{
			super();
			
			DoneSignal = new Signal();
			_screenTitle = "Settings";
			_so = SharedObject.getLocal(GameData.SHAREDNAME);
			
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
			
			var btnCancel:GameButton = new GameButton();
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
			
			var btnSave:GameButton = new GameButton();
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
			
			_audioSlider = new Slider();
			_audioSlider.width = 400;
			_audioSlider.maximum = 100;
			_audioSlider.minimum = 0;
			_audioSlider.tickInterval = 0;
			_audioSlider.getChildAt(0).height = 10;
			_audioSlider.getChildAt(1).width = 20;
			_audioSlider.getChildAt(1).height = 20;
			_audioSlider.getChildAt(1).y -= 3;
			_audioSlider.x = this.width - _audioSlider.width - 100;
			_audioSlider.y = tf.y + 35;
			_audioSlider.value = 100;
			this.addChild(_audioSlider);
			
			_mouseYsensitivity = new Slider();
			_mouseYsensitivity.width = 400;
			_mouseYsensitivity.maximum = 100;
			_mouseYsensitivity.minimum = 25;
			_mouseYsensitivity.tickInterval = 0;
			_mouseYsensitivity.getChildAt(0).height = 10;
			_mouseYsensitivity.getChildAt(1).width = 20;
			_mouseYsensitivity.getChildAt(1).height = 20;
			_mouseYsensitivity.getChildAt(1).y -= 3;
			_mouseYsensitivity.x = _audioSlider.x;
			_mouseYsensitivity.y = _audioSlider.y + spacing;
			_mouseYsensitivity.value = 62.5;
			this.addChild(_mouseYsensitivity);
			
			_mouseXsensitivity = new Slider();
			_mouseXsensitivity.width = 400;
			_mouseXsensitivity.maximum = 100;
			_mouseXsensitivity.minimum = 25;
			_mouseXsensitivity.tickInterval = 0;
			_mouseXsensitivity.getChildAt(0).height = 10;
			_mouseXsensitivity.getChildAt(1).width = 20;
			_mouseXsensitivity.getChildAt(1).height = 20;
			_mouseXsensitivity.getChildAt(1).y -= 3;
			_mouseXsensitivity.x = _mouseYsensitivity.x;
			_mouseXsensitivity.y = _mouseYsensitivity.y + spacing;
			_mouseXsensitivity.value = 62.5;
			this.addChild(_mouseXsensitivity);
			
			_invertY = new CheckBox();
			_invertY.label = "";
			_invertY.x = _mouseXsensitivity.x + _mouseXsensitivity.width * 0.5 - _invertY.width * 0.5;
			_invertY.y = _mouseXsensitivity.y + spacing;
			_invertY.selected = false;
			this.addChild(_invertY);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			
			loadSettings();
			_audioSlider.addEventListener(SliderEvent.CHANGE, changeAudio);
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		/**
		 * Loads the user defined values into the settings
		 */
		private function loadSettings():void
		{
			_audioSlider.value = _so.data[GameData.AUDIO] * 100;
			_mouseXsensitivity.value = _so.data[GameData.MOUSEX];
			_mouseYsensitivity.value = _so.data[GameData.MOUSEY];
			_invertY.selected = _so.data[GameData.INVERT];
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function cancelClicked($e:MouseEvent):void 
		{
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function saveClicked($e:MouseEvent):void
		{
			var audio:Number = _audioSlider.value * 0.01;
			_so.data[GameData.AUDIO] = audio;
			SoundAS.masterVolume = _so.data[GameData.AUDIO];
			
			_so.data[GameData.MOUSEX] = _mouseXsensitivity.value;
			_so.data[GameData.MOUSEY] = _mouseYsensitivity.value;
			_so.data[GameData.INVERT] = _invertY.selected;
			
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function changeAudio($event:Event)
		{
			trace(_audioSlider.value);
			var master:Number = SoundAS.masterVolume;
			var volume:Number = SoundAS.volume;
			SoundAS.masterVolume = 1;
			SoundAS.volume = 1;
			
			SoundAS.playFx("SoundLevelChange", _audioSlider.value * 0.01);
			
			SoundAS.masterVolume = master;
			SoundAS.volume = volume;
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