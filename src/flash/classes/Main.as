package 
{
	import away3d.controllers.ControllerBase;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.natejc.input.KeyboardManager;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.bases.BaseScreen;
	import team3d.interfaces.IScreen;
	import team3d.screens.ControlsScreen;
	import team3d.screens.CreditsScreen;
	import team3d.screens.DebugScreen;
	import team3d.screens.GameScreen;
	import team3d.screens.LoadScreen;
	import team3d.screens.LostScreen;
	import team3d.screens.PauseScreen;
	import team3d.screens.SettingsScreen;
	import team3d.screens.TitleScreen;
	import team3d.objects.World;
	import team3d.screens.WonScreen;
	
	/**
	 * drive class for Operation Silent Badger
	 *
	 * @author Johnathan McNutt
	 */
	[SWF(width = 900, height = 600, frameRate = 60)]
	public class Main extends Sprite
	{
		private var _prevScreen		:IScreen;
		private var	_titleScreen	:TitleScreen;
		private var _gameScreen		:GameScreen;
		private var _loadingScreen	:LoadScreen;
		private var _debugScreen	:DebugScreen;
		private var _creditsScreen	:CreditsScreen;
		private var _settingsScreen	:SettingsScreen;
		private var _pauseScreen	:PauseScreen;
		private var _lostScreen		:LostScreen;
		private var _wonScreen		:WonScreen;
		private var _controlScreen	:ControlsScreen;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main class.
		 */
		public function Main()
		{
			KeyboardManager.init(this.stage);
			World.instance.init(this.stage);
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
			_titleScreen = new TitleScreen();
			_gameScreen = new GameScreen();
			_loadingScreen = new LoadScreen();
			_debugScreen = new DebugScreen();
			_creditsScreen = new CreditsScreen();
			_settingsScreen = new SettingsScreen();
			_pauseScreen = new PauseScreen();
			_lostScreen = new LostScreen();
			_wonScreen = new WonScreen();
			_controlScreen = new ControlsScreen();
			
			_loadingScreen.DoneSignal.add(endLoading);
			_titleScreen.DoneSignal.add(endTitle);
			_creditsScreen.DoneSignal.add(endCredits);
			_settingsScreen.DoneSignal.add(endSettings);
			_gameScreen.DoneSignal.add(endGame);
			_gameScreen.PausedSignal.add(gamePaused);
			_pauseScreen.DoneSignal.add(endPause);
			_lostScreen.DoneSignal.add(endLost);
			_wonScreen.DoneSignal.add(endWon);
			_controlScreen.DoneSignal.add(endControls);
			
			this.addChild(_gameScreen);
			this.addChild(_titleScreen);
			this.addChild(_loadingScreen);
			this.addChild(_creditsScreen);
			this.addChild(_settingsScreen);
			this.addChild(_pauseScreen);
			this.addChild(_lostScreen);
			this.addChild(_wonScreen);
			this.addChild(_controlScreen);
			
			this.addChild(_debugScreen);
		}
		
		private function endTitle($dest:int):void 
		{
			_titleScreen.End();
			
			if ($dest == 0)
				_gameScreen.Begin();
			else if ($dest == 1)
				_creditsScreen.Begin();
			else if ($dest == 2)
				_settingsScreen.Begin();
			
			_prevScreen = _titleScreen;
		}
		
		private function endCredits():void
		{
			_creditsScreen.End();
			_titleScreen.Begin();
			_prevScreen = _creditsScreen;
		}
		
		private function endSettings():void
		{
			_settingsScreen.End();
			_prevScreen.Begin();
			_prevScreen = _settingsScreen;
		}
		
		private function endGame($won:Boolean):void
		{
			_gameScreen.End();
			if ($won)
			{
				_wonScreen.Begin();
			}
			else
			{
				_lostScreen.Begin();
			}
			_prevScreen = _gameScreen;
		}
		
		private function gamePaused():void
		{
			_gameScreen.Pause();
			_pauseScreen.Begin();
		}
		
		private function endPause($dir:int):void
		{
			_pauseScreen.End();
			if ($dir == 0)
				_settingsScreen.Begin();
			else if ($dir == 1)
			{
				_controlScreen.Begin();
			}
			else if ($dir == 2)
			{
				_gameScreen.End();
				_titleScreen.Begin();
			}
			else if ($dir == 3)
			{
				_gameScreen.Unpause();
			}
			
			_prevScreen = _pauseScreen;
		}
		
		private function endLost():void
		{
			_lostScreen.End();
			_titleScreen.Begin();
			_prevScreen = _lostScreen;
		}
		
		private function endWon():void
		{
			_wonScreen.End();
			_titleScreen.Begin();
			_prevScreen = _wonScreen;
		}
		
		private function endControls():void
		{
			_controlScreen.End();
			_prevScreen.Begin();
			_prevScreen = _controlScreen;
		}
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * @private
		 * when main is added to the stage
		 */
		protected function added($e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, added);
			
            World.instance.stage.scaleMode = StageScaleMode.NO_SCALE;
			World.instance.stage.align = StageAlign.TOP_LEFT;
			
			TweenPlugin.activate([GlowFilterPlugin]);
			_debugScreen.Begin();
			_loadingScreen.Begin();
			//_settingsScreen.Begin();
			//_titleScreen.Begin();
			//_creditsScreen.Begin();
			//_pauseScreen.Begin();
			//_lostScreen.Begin();
			//_wonScreen.Begin();
			//_controlScreen.Begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function endLoading():void 
		{
			_loadingScreen.End();
			_titleScreen.Begin();
			_prevScreen = _loadingScreen;
		}
		
		/* ---------------------------------------------------------------------------------------- */
	
		/**
		 * Relinquishes all memory used by this object.
		 */
		public function destroy():void
		{
			while (this.numChildren > 0)
				this.removeChildAt(0);
		}
		
		/* ---------------------------------------------------------------------------------------- */
	}
}