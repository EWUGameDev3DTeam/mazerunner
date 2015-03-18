package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.natejc.input.KeyboardManager;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.SharedObject;
	import team3d.bases.BaseScreen;
	import team3d.interfaces.IScreen;
	import team3d.objects.World;
	import team3d.screens.ControlsScreen;
	import team3d.screens.CreditsScreen;
	import team3d.screens.DebugScreen;
	import team3d.screens.GameScreen;
	import team3d.screens.LoadScreen;
	import team3d.screens.LostScreen;
	import team3d.screens.PauseScreen;
	import team3d.screens.SettingsScreen;
	import team3d.screens.TitleScreen;
	import team3d.screens.TutorialScreen;
	import team3d.screens.WonScreen;
	import team3d.ui.PluginOverlay;
	import team3d.utils.GameData;
	import team3d.utils.Utils;
	import treefortress.sound.SoundAS;
	import treefortress.sound.SoundInstance;
	
	/**
	 * drive class for Operation Silent Badger
	 *
	 * @author Johnathan McNutt
	 */
	[SWF(width = 900, height = 600, frameRate = 60)]
	public class Main extends Sprite
	{
		private var _prevScreens	:Vector.<IScreen>;
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
		private var _tutorialScreen	:TutorialScreen;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the Main class.
		 */
		public function Main()
		{
			KeyboardManager.init(this.stage);
			World.instance.init(this.stage);
			
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
			_prevScreens = new Vector.<IScreen>();
			_debugScreen = new DebugScreen();
			_debugScreen.Begin();
			this.addChild(_debugScreen);
			
			initData();
			loadSounds();
		}
		
		/**
		 * Initializes all in game user defined variables to defaults if they don't exist
		 */
		private function initData():void
		{
			var so:SharedObject = SharedObject.getLocal(GameData.SHAREDNAME);
			if (so.data[GameData.MOUSEX] == undefined)
				so.data[GameData.MOUSEX] = 62.5;
			
			if (so.data[GameData.MOUSEY] == undefined)
				so.data[GameData.MOUSEY] = 62.5;
				
			if (so.data[GameData.INVERT] == undefined)
				so.data[GameData.INVERT] = false;
				
			if (so.data[GameData.AUDIO] == undefined)
				so.data[GameData.AUDIO] = 1;
				
			SoundAS.masterVolume = so.data[GameData.AUDIO];
		}
		
		private function loadSounds():void
		{
			SoundAS.loadCompleted.add(soundCompleted);
			SoundAS.loadSound("./audio/sfx/Button.mp3", "Button");
			SoundAS.loadSound("./audio/sfx/SoundLevelChange.mp3", "SoundLevelChange");
			SoundAS.loadSound("./audio/sfx/CannonFiring.mp3", "CannonFiring");
			SoundAS.loadSound("./audio/sfx/DefeatSound.mp3", "DefeatSound");
			SoundAS.loadSound("./audio/sfx/DoorClosing.mp3", "DoorClosing");
			SoundAS.loadSound("./audio/sfx/DoorsOpening.mp3", "DoorsOpening");
			SoundAS.loadSound("./audio/sfx/Elevator.mp3", "Elevator");
			SoundAS.loadSound("./audio/sfx/LoadingFinished.mp3", "LoadingFinished");
			SoundAS.loadSound("./audio/sfx/MonsterSounds.mp3", "MonsterSounds");
			SoundAS.loadSound("./audio/sfx/OrbHitPlayer.mp3", "OrbHitPlayer");
			SoundAS.loadSound("./audio/sfx/PlayerDeath.mp3", "PlayerDeath");
			SoundAS.loadSound("./audio/sfx/PlayerFootstep.mp3", "PlayerFootstep");
			SoundAS.loadSound("./audio/sfx/TimeEnds.mp3", "TimeEnds");
			SoundAS.loadSound("./audio/sfx/VictorySound.mp3", "VictorySound");
			
			SoundAS.loadSound("./audio/music/title.mp3", "title");
			SoundAS.loadSound("./audio/music/GameMusic.mp3", "GameMusic");
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
			
			//var pluginCheck:PluginOverlay = new PluginOverlay();
			//this.addChildAt(pluginCheck, 0);
			//pluginCheck.check();
			if (root.loaderInfo.parameters.plugin == "pepflashplayer.dll")
				World.instance.setSafe = false;
			
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
		
		private function soundCompleted($s:SoundInstance):void
		{
			if ($s.type == "title")
				SoundAS.playLoop("title");
		}
		
		private function loadLoading($q:LoaderMax):void
		{
			var overlay:ImageLoader = new ImageLoader("images/GUI/Overlay.png", { name:"overlayLoad", width:900, height:600, scaleMode:"strech" } );
			var mob:ImageLoader = new ImageLoader("images/MonsterSmall.png", { name:"monstersmall" } );
			
			$q.append(overlay);
			$q.append(mob);
			
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
			_tutorialScreen = new TutorialScreen();
			
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
			_tutorialScreen.DoneSignal.add(endTutorial);
			_tutorialScreen.PausedSignal.add(tutorialPaused);
			
			this.addChildAt(_loadingScreen, 0);
			this.addChildAt(_titleScreen, 0);
			this.addChildAt(_creditsScreen, 0);
			this.addChildAt(_settingsScreen, 0);
			this.addChildAt(_pauseScreen, 0);
			this.addChildAt(_controlScreen, 0);
			this.addChildAt(_wonScreen, 0);
			this.addChildAt(_lostScreen, 0);
			
			// to prevent invisible screen stacking, add any 3d worlds at the bottom of the list
			// adding them at 0 like this guarantees all other screens are above them.
			this.addChildAt(_gameScreen, 0);
			this.addChildAt(_tutorialScreen, 0);
			
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
			
			_prevScreens.push(_loadingScreen)
		}
		
		private function endTitle($dest:int):void 
		{
			// empty the previous pages each time title ends
			while (_prevScreens.length > 0)
				_prevScreens.pop();
			
			_titleScreen.End();
			
			if ($dest == BaseScreen.TUTORIAL)
				_tutorialScreen.Begin();
			else if ($dest == BaseScreen.CREDITS)
				_creditsScreen.Begin();
			else if ($dest == BaseScreen.SETTINGS)
				_settingsScreen.Begin();
			else if ($dest == BaseScreen.GAME)
				_gameScreen.Begin();
			
			_prevScreens.push(_titleScreen);
		}
		
		private function endCredits():void
		{
			_creditsScreen.End();
			_titleScreen.Begin();
			_prevScreens.push(_creditsScreen);
		}
		
		private function endSettings():void
		{
			_settingsScreen.End();
			_prevScreens.pop().Begin();
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
			_prevScreens.push(_gameScreen);
		}
		
		private function gamePaused():void
		{
			_gameScreen.Pause();
			_pauseScreen.Begin();
			_prevScreens.push(_gameScreen);
		}
		
		private function endPause($dir:int):void
		{
			var screen:IScreen;
			_pauseScreen.End();
			
			if ($dir == BaseScreen.SETTINGS)
				_settingsScreen.Begin();
			else if ($dir == BaseScreen.CONTROLS)
			{
				_controlScreen.Begin();
			}
			else if ($dir == BaseScreen.TITLE)
			{
				_prevScreens.pop().End();
				_titleScreen.Begin();
			}
			else if ($dir == BaseScreen.GAME)
			{
				screen = _prevScreens.pop();
				if (screen == _gameScreen)
				{
					_gameScreen.Unpause();
				}
				else
				{
					_tutorialScreen.Unpause();
				}
			}
			
			_prevScreens.push(_pauseScreen);
		}
		
		private function endLost():void
		{
			_lostScreen.End();
			_creditsScreen.Begin();
			_prevScreens.push(_lostScreen);
		}
		
		private function endWon():void
		{
			_wonScreen.End();
			_creditsScreen.Begin();
			_prevScreens.push(_wonScreen);
		}
		
		private function endControls():void
		{
			_controlScreen.End();
			_prevScreens.pop().Begin();
		}
		
		private function endTutorial():void
		{
			_tutorialScreen.End();
			_gameScreen.Begin();
			_prevScreens.push(_tutorialScreen);
		}
		
		private function tutorialPaused():void
		{
			_tutorialScreen.Pause();
			_pauseScreen.Begin();
			_prevScreens.push(_tutorialScreen);
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