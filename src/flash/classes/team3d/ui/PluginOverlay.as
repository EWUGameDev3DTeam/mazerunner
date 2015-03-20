package team3d.ui
{
	import com.greensock.easing.Cubic;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import team3d.objects.World;
	import team3d.screens.DebugScreen;
	
	/**
	 * ...
	 * @author Dan Watt
	 */
	public class PluginOverlay extends Sprite
	{
		
		//private var _rect			:Rectangle;
		private var _txtNotice			:TextField;
		private var _txtFormat			:TextFormat;
		
		private var _txtPlugin			:TextField;
		private var _txtPluginFormat	:TextFormat;
		
		private var _pluginLink			:TextField;
		private var _pluginFormat		:TextFormat;
		
		private var _dismissLink		:TextField;
		private var _dismissFormat		:TextFormat;
		
		private var _tween				:TweenMax;
		
		public function PluginOverlay()
		{
			_txtFormat = new TextFormat(null, 20, 0xFF0000, true, null, null, null, null, TextFormatAlign.CENTER);
			_txtNotice = new TextField();
			_txtNotice.defaultTextFormat = _txtFormat;
			_txtNotice.text = "Warning: You are using a browser plugin that has been known to cause issues.\nTo maximize your experience, we recommend downloading the flash player\nplugin provided at the link below and disabling your current one";
			_txtNotice.autoSize = TextFieldAutoSize.CENTER;
			_txtNotice.name = "txtNotice";
			this.addChild(_txtNotice);
			
			_txtPluginFormat = new TextFormat(null, 20, 0xFFFF00, true, null, true, null, null, TextFormatAlign.CENTER);
			_txtPlugin = new TextField();
			_txtPlugin.defaultTextFormat = _txtPluginFormat;
			_txtPlugin.text = "Detected Plugin: pepflashplayer";
			_txtPlugin.autoSize = TextFieldAutoSize.CENTER;
			this.addChild(_txtPlugin);
			
			_pluginFormat = new TextFormat(null, 20, 0x00FF00, true, null, null, null, null, TextFormatAlign.CENTER);
			_pluginLink = new TextField();
			_pluginLink.autoSize = TextFieldAutoSize.LEFT;
			_pluginLink.defaultTextFormat = _pluginFormat;
			_pluginLink.name = "lnkPlugin";
			_pluginLink.text = "http://get.adobe.com/flashplayer/?no_redirect";
			//_pluginLink.addEventListener(MouseEvent.ROLL_OUT, linkOut);
			//_pluginLink.addEventListener(MouseEvent.ROLL_OVER, linkOver);
			this.addChild(_pluginLink);
			
			_dismissFormat = new TextFormat(null, 20, 0x00FF00, true, null, true, "", null, TextFormatAlign.CENTER);
			_dismissLink = new TextField();
			_dismissLink.defaultTextFormat = _dismissFormat;
			_dismissLink.autoSize = TextFieldAutoSize.RIGHT;
			_dismissLink.name = "lnkDismiss";
			_dismissLink.text = "Dismiss Notice";
			_dismissLink.addEventListener(MouseEvent.CLICK, dismissClick);
			_dismissLink.addEventListener(MouseEvent.ROLL_OUT, linkOut);
			_dismissLink.addEventListener(MouseEvent.ROLL_OVER, linkOver);
			this.addChild(_dismissLink);
			
			this.visible = false;
		}
		private function showWarning():void
		{
			_txtNotice.text = "Warning: If the screen refuses to exit the pause menu, exit and re-enter full screen.\nThis is the bug with pepflashplayer.";
			_tween.play();
		}
		
		private function hideWarning():void
		{
			_tween.reverse();
		}
		
		private function screenChange():void
		{
			if (World.instance.CurrentScreen != "Loading" && !_tween.reversed())
			{
				_tween.reverse();
				World.instance.ScreenChange.remove(screenChange);
			}
		}
		
		private function linkOut($e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function linkOver($e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function dismissClick($e:MouseEvent):void
		{
			_tween.reverse();
		}
		
		public function check():void
		{
			var pluginTxt:String = root.loaderInfo.parameters.plugin;
			_txtPlugin.text = "Detected Plugin: " + pluginTxt;
			//if (pluginTxt == "pepflashplayer.dll" || pluginTxt == "PepperFlashPlayer.plugin")
			{
				World.instance.setSafe = false;
				_txtNotice.x = (World.instance.stage.stageWidth - _txtNotice.textWidth) * 0.5;
				_txtNotice.y = 10;
				
				_txtPlugin.x = (World.instance.stage.stageWidth - _txtPlugin.textWidth) * 0.5;
				_txtPlugin.y = _txtNotice.y + _txtNotice.height + 10;
				
				_pluginLink.x = _txtNotice.x;
				_pluginLink.y = _txtPlugin.y + _txtPlugin.height + 10;
				
				_dismissLink.x = _txtNotice.x + _txtNotice.width - _dismissLink.width;
				_dismissLink.y = _pluginLink.y;
				
				var rect:Shape = new Shape();
				rect.graphics.beginFill(0x000000);
				rect.graphics.drawRect(_txtNotice.x - 10, 0, _txtNotice.textWidth + 20, _pluginLink.y + _pluginLink.height);
				rect.graphics.endFill();
				this.addChildAt(rect, 0);
				
				_tween = TweenMax.fromTo(this, 0.5, { y: -rect.height }, { autoAlpha:1, y:0, ease:Cubic.easeOut } );
				this.addEventListener(Event.RESIZE, resize);
				World.instance.ScreenChange.add(screenChange);
			}
			
			//if (!World.instance.IsSafe)
			{
				World.instance.PauseSignal.add(showWarning);
				World.instance.ResumeSignal.add(hideWarning);
			}
		}
		
		private function resize($e:Event):void
		{
			this.x = (World.instance.stage.stageWidth - this.width) * 0.5;
			this.y = (World.instance.stage.stageHeight - this.height) * 0.5;
		}
	}
	
}