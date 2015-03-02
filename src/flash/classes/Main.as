package 
{
	import away3d.controllers.ControllerBase;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
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
			
			_debugScreen = new DebugScreen();
			_debugScreen.Begin();
			this.addChild(_debugScreen);
		}
		
		private function endTitle($dest:int):void 
		{
			_titleScreen.End();
			
			if ($dest == BaseScreen.GAME)
				TweenMax.fromTo(_gameScreen, 1, { autoAlpha:1 }, { autoAlpha:0, onComplete:_gameScreen.Begin(), delay:1 } );
			else if ($dest == BaseScreen.CREDITS)
				_creditsScreen.Begin();
			else if ($dest == BaseScreen.SETTINGS)
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
			if ($dir == BaseScreen.SETTINGS)
				_settingsScreen.Begin();
			else if ($dir == BaseScreen.CONTROLS)
			{
				_controlScreen.Begin();
			}
			else if ($dir == BaseScreen.TITLE)
			{
				_gameScreen.End();
				_titleScreen.Begin();
			}
			else if ($dir == BaseScreen.GAME)
			{
				_gameScreen.Unpause();
			}
			
			_prevScreen = _pauseScreen;
		}
		
		private function endLost():void
		{
			_lostScreen.End();
			_creditsScreen.Begin();
			_prevScreen = _lostScreen;
		}
		
		private function endWon():void
		{
			_wonScreen.End();
			_creditsScreen.Begin();
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
			
			var queue:LoaderMax = new LoaderMax( { onProgress:progress, onComplete:compeleted } );
			loadLoading(queue);
			loadTitle(queue);
			loadCredits(queue);
			loadSettings(queue);
			loadPause(queue);
			loadControls(queue);
			loadWon(queue);
			loadLost(queue);
			queue.load();
		}
		
		private function loadLoading($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name:"overlayLoad", width:900, height:600, scaleMode:"strech" } );
			$q.append(overlay);
			
			for (var i:int = 0; i < 25; i++)
				$q.append(new ImageLoader("images/GUI/Arrow.png", { name:("loadingArrow" + i), width:50, height:60, alpha:0 } ));
		}
		
		private function loadTitle($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayTitle", scaleMode:"stretch" } );
			var runningMan:ImageLoader = new ImageLoader("images/GUI/Man.png", { name: "runningManTitle" } );
			
			$q.append(overlay);
			$q.append(runningMan);
			
			for (var i:int = 0; i < 3; i++)
				$q.append(new ImageLoader("images/GUI/Arrow.png", { name: ("titleArrow" + i), width:146, height:175 } ));
		}
		
		private function loadCredits($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayCredits", scaleMode:"stretch" } );
			var computerman:ImageLoader = new ImageLoader("images/GUI/Man_Computer.png", { name: "manComputer" } );
			
			$q.append(overlay);
			$q.append(computerman);
		}
		private function loadSettings($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlaySettings", scaleMode:"stretch" } );
			
			$q.append(overlay);
		}
		
		private function loadPause($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayPause" } );
			var runningMan:ImageLoader = new ImageLoader("images/GUI/Man.png", { name: "runningManPause" } );
			
			$q.append(overlay);
			$q.append(runningMan);
		}
		
		private function loadControls($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayControls", scaleMode:"stretch" } );
			var keys:ImageLoader = new ImageLoader("images/Controls/KeysDone.png", { name:"movekeys" } );
			var mouseMove:ImageLoader = new ImageLoader("images/Controls/Move.png", { name:"mouseMove" } );
			var shift:ImageLoader = new ImageLoader("images/Controls/ShiftKey.png", { name:"shiftMove" } );
			
			$q.append(overlay);
			$q.append(keys);
			$q.append(mouseMove);
			$q.append(shift);
		}
		
		private function loadWon($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayWon", scaleMode:"stretch" } );
			var runningMan:ImageLoader = new ImageLoader("images/GUI/Man.png", { name: "runningManWon" } );
			for (var i:int = 0; i < 4; i++)
				$q.append(new ImageLoader("images/GUI/Arrow.png", { name:"wonArrow" + i } ));
			
			$q.append(overlay);
			$q.append(runningMan);
		}
		
		private function loadLost($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name: "overlayLost", scaleMode:"stretch" } );
			var grave:ImageLoader = new ImageLoader("images/GUI/Man_Sad.png", { name: "grave0" } );
			var grave1:ImageLoader = new ImageLoader("images/GUI/Man_Sad.png", { name: "grave1" } );
			var grave2:ImageLoader = new ImageLoader("images/GUI/Man_Sad.png", { name: "grave2" } );
			var cross:ImageLoader = new ImageLoader("images/GUI/Cross.png", { name:"cross" } );
			
			$q.append(overlay);
			$q.append(grave);
			$q.append(grave1);
			$q.append(grave2);
			$q.append(cross);
		}
		
		private function progress($e:LoaderEvent):void
		{
			DebugScreen.Text(Math.round($e.target.progress * 100) + "%");
		}
		
		private function compeleted($e:LoaderEvent):void
		{
			_loadingScreen = new LoadScreen();
			_titleScreen = new TitleScreen();
			_creditsScreen = new CreditsScreen();
			_settingsScreen = new SettingsScreen();
			_gameScreen = new GameScreen();
			_pauseScreen = new PauseScreen();
			_controlScreen = new ControlsScreen();
			_wonScreen = new WonScreen();
			_lostScreen = new LostScreen();
			
			_loadingScreen.DoneSignal.add(endLoading);
			_titleScreen.DoneSignal.add(endTitle);
			_creditsScreen.DoneSignal.add(endCredits);
			_settingsScreen.DoneSignal.add(endSettings);
			_gameScreen.DoneSignal.add(endGame);
			_gameScreen.PausedSignal.add(gamePaused);
			_pauseScreen.DoneSignal.add(endPause);
			_controlScreen.DoneSignal.add(endControls);
			_wonScreen.DoneSignal.add(endWon);
			_lostScreen.DoneSignal.add(endLost);
			
			this.addChildAt(_loadingScreen, 0);
			this.addChildAt(_titleScreen, 0);
			this.addChildAt(_creditsScreen, 0);
			this.addChildAt(_settingsScreen, 0);
			this.addChildAt(_gameScreen, 0);
			this.addChildAt(_pauseScreen, 0);
			this.addChildAt(_controlScreen, 0);
			this.addChildAt(_wonScreen, 0);
			this.addChildAt(_lostScreen, 0);
			
			trace("loading done");
			_loadingScreen.Begin();
			//_titleScreen.Begin();
			//_settingsScreen.Begin();
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