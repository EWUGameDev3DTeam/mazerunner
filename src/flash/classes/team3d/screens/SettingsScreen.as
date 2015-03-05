package team3d.screens
{
	import adobe.utils.CustomActions;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.events.ComponentEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
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
	import team3d.ui.Button;
	import treefortress.sound.SoundAS;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class SettingsScreen extends BaseScreen
	{
		private var _audioSlider:Slider = new Slider();
		private var _mouseYsensitivity:Slider = new Slider();
		private var _mouseXsensitivity:Slider = new Slider();
		private var _invertY:CheckBox = new CheckBox();
		public var so	:SharedObject = SharedObject.getLocal("dataTeam3D");;
		
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
			this.addChild(_audioSlider);
			
			if(this.so.data.audio == undefined){
				this._audioSlider.value = 100;
				this.so.data.audio = this._audioSlider.value;
			}
			else
				this._audioSlider.value = so.data.audio;
			
			SoundAS.masterVolume = this._audioSlider.value * .01;
			
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
			this.addChild(_mouseYsensitivity);
			
			if (this.so.data.mouseY == undefined){
				this._mouseYsensitivity.value = 62.5;
				this.so.data.mouseY = this._mouseYsensitivity.value;
			}
			else
				this._mouseYsensitivity.value = so.data.mouseY;
			
			
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
			this.addChild(_mouseXsensitivity);
			
			if (so.data.mouseX == undefined){
				this._mouseXsensitivity.value = 62.5;
				this.so.data.mouseX = this._mouseXsensitivity.value;
			}
			else
				this._mouseXsensitivity.value = so.data.mouseX;
			
			
			_invertY.label = "";
			_invertY.x = _mouseXsensitivity.x + _mouseXsensitivity.width * 0.5 - _invertY.width * 0.5;
			_invertY.y = _mouseXsensitivity.y + spacing;
			this.addChild(_invertY);
			
			if (this.so.data.invertY == undefined){
				this._invertY.selected = false;
				this.so.data.invertY = this._invertY.selected;
			}
			else
				this._invertY.selected = so.data.invertY;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			
			this.addEventListener(Event.ENTER_FRAME, newFrame);
			this._audioSlider.addEventListener(MouseEvent.MOUSE_UP, changeAudio);
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function cancelClicked($e:MouseEvent):void 
		{
			SoundAS.playFx("Button");
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function saveClicked($e:MouseEvent):void
		{
			SoundAS.playFx("Button");
			this.DoneSignal.dispatch();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function changeAudio($event:Event)
		{
			this.so.data.audio = this._audioSlider.value;
				SoundAS.masterVolume = this._audioSlider.value * .01;
				SoundAS.playFx("SoundLevelChange");
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function newFrame($event:Event):void 
		{
			/*
			if (this.so.data.audio != this._audioSlider.value)
			{
				this.so.data.audio = this._audioSlider.value;
				SoundAS.masterVolume = this._audioSlider.value * .01;
				SoundAS.playFx("SoundLevelChange");
			}	
			*/	
			
			if (this.so.data.mouseY != this._mouseYsensitivity.value)
				this.so.data.mouseY = this._mouseYsensitivity.value;
				
			if (this.so.data.mouseX != this._mouseXsensitivity.value)
				this.so.data.mouseX = this._mouseXsensitivity.value;
				
			if (this.so.data.invertY != this._invertY.selected)
				this.so.data.invertY = this._invertY.selected;
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			super.End();
			
			this.removeEventListener(Event.ENTER_FRAME, newFrame);
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha:1 }, { autoAlpha:0 } );
		}
	}
}