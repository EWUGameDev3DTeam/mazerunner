package team3d.screens
{
	import adobe.utils.CustomActions;
	import away3d.events.MouseEvent3D;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
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
	public class PauseScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function PauseScreen()
		{
			super();
			
			DoneSignal = new Signal(int);
			_screenTitle = "Pause";
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			var queue:LoaderMax = new LoaderMax( { onComplete: show } );
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayPause", container:this } );
			var runningMan:ImageLoader = new ImageLoader("images/GUI/Man.png", { name: "runningMan", container:this } );
			
			queue.append(overlay);
			queue.append(runningMan);
			queue.load();
			
			World.instance.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullscreen);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * Shows the screen
		 */
		private function show($e:LoaderEvent = null):void
		{
			var offset:Number = 0.8;
			var overlay:Sprite = LoaderMax.getContent("overlayPause");
			overlay.width = this.stage.stageWidth * offset;
			overlay.height = this.stage.stageHeight * offset;
			overlay.x = (this.stage.stageWidth - overlay.width) * 0.5;
			overlay.y = (this.stage.stageHeight - overlay.height) * 0.5;
			
			var man:Sprite = LoaderMax.getContent("runningMan");
			man.width += 50;
			man.height += 75;
			man.x = overlay.x + 50;
			man.y = overlay.y + 75;
			
			var btnwidth:Number = 200;
			var btnheight:Number = 75;
			var format:TextFormat = new TextFormat();
			format.size = 40;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			
			var btnSettings:Button = new Button();
			btnSettings.text("Settings");
			btnSettings.width = btnwidth;
			btnSettings.height = btnheight;
			btnSettings.textFormat = format;
			btnSettings.x = man.x + man.width + 25;
			btnSettings.y = man.y + 20;
			this.addChild(btnSettings);
			
			var btnControls:Button = new Button();
			btnControls.text("Controls");
			btnControls.width = btnwidth;
			btnControls.height = btnheight;
			btnControls.textFormat = format;
			btnControls.x = btnSettings.x;
			btnControls.y = btnSettings.y + btnSettings.height + 20;
			this.addChild(btnControls);
			
			var btnQuit:Button = new Button();
			btnQuit.text("Quit");
			btnQuit.width = btnwidth;
			btnQuit.height = btnheight;
			btnQuit.textFormat = format;
			btnQuit.x = btnControls.x;
			btnQuit.y = btnControls.y + btnControls.height + 20;
			this.addChild(btnQuit);
			
			var btnContinue:Button = new Button();
			btnContinue.text("Continue");
			btnContinue.width = btnwidth;
			btnContinue.height = btnheight;
			btnContinue.textFormat = format;
			btnContinue.x = btnQuit.x + btnQuit.width + 20;
			btnContinue.y = btnQuit.y + btnQuit.height + 20;
			this.addChild(btnContinue);
			
			var btnFullscreen:Button = new Button();
			btnFullscreen.name = "btnFullScreen";
			btnFullscreen.text("Full Screen");
			btnFullscreen.width = btnwidth;
			btnFullscreen.height = btnheight;
			btnFullscreen.textFormat = format;
			btnFullscreen.x = btnQuit.x;
			btnFullscreen.y = btnQuit.y + btnQuit.height + 20;
			if (World.instance.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				btnFullscreen.visible = false;
			this.addChild(btnFullscreen);
			
			btnFullscreen.addEventListener(MouseEvent.CLICK, fullscreenClicked);
			btnSettings.addEventListener(MouseEvent.CLICK, settingsClicked);
			btnControls.addEventListener(MouseEvent.CLICK, controlsClicked);
			btnQuit.addEventListener(MouseEvent.CLICK, quitClicked);
			btnContinue.addEventListener(MouseEvent.CLICK, continueClicked);
			TweenMax.fromTo(this, 1, { autoAlpha: 0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function settingsClicked($e:MouseEvent):void 
		{
			this.DoneSignal.dispatch(0);
		}
		
		private function controlsClicked($e:MouseEvent):void
		{
			this.DoneSignal.dispatch(1);
		}
		
		private function quitClicked($e:MouseEvent):void
		{
			this.DoneSignal.dispatch(2);
		}
		
		private function continueClicked($e:MouseEvent):void
		{
			if(World.instance.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				this.DoneSignal.dispatch(3);
			else
			{
				TweenMax.to(this.getChildByName("btnFullScreen"), 0.2, { glowFilter: { alpha:1, color:0x91e600, blurX:30, blurY:30, strength:2, quality:2 }, yoyo:true, repeat:3} );
			}
		}
		
		private function fullscreenClicked($e:MouseEvent):void
		{
			World.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		
		private function fullscreen(e:FullScreenEvent):void 
		{
			var btn:Button = Button(this.getChildByName("btnFullScreen"));
			if (World.instance.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
				TweenMax.fromTo(btn, 0.5, { autoAlpha:1 }, { autoAlpha:0 } );
			else
				TweenMax.fromTo(btn, 0.5, { autoAlpha:0 }, { autoAlpha:1 } );
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			World.instance.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, fullscreen);
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
			//TweenMax.fromTo(this, 1, { autoAlpha:1 }, { autoAlpha:0, onComplete:destroy } );
			this.visible = false;
			this.alpha = 0;
			destroy();
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