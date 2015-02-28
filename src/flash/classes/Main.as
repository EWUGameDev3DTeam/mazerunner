package 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.natejc.input.KeyboardManager;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import team3d.screens.DebugScreen;
	import team3d.screens.GameScreen;
	import team3d.screens.LoadScreen;
	import team3d.screens.TitleScreen;
	import team3d.objects.World;
	
	/**
	 * drive class for Operation Silent Badger
	 *
	 * @author Johnathan McNutt
	 */
	[SWF(width = 900, height = 600, frameRate = 60)]
	public class Main extends Sprite
	{
		private var	_titleScreen	:TitleScreen;
		private var _gameScreen		:GameScreen;
		private var _loadingScreen	:LoadScreen;
		private var _debugScreen	:DebugScreen;
		
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
			
			_loadingScreen.DoneSignal.add(endLoading);
			_titleScreen.DoneSignal.add(endTitle);
			
			this.addChild(_gameScreen);
			this.addChild(_titleScreen);
			this.addChild(_loadingScreen);
			
			this.addChild(_debugScreen);
		}
		
		private function endTitle($dest:int):void 
		{
			trace("dest: " + $dest);
			_titleScreen.End();
			if ($dest == 0)
				_gameScreen.Begin();
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
			
			_debugScreen.Begin();
			_loadingScreen.Begin();
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		private function endLoading():void 
		{
			trace("loading done");
			_loadingScreen.End();
			trace("loading ended");
			_titleScreen.Begin();
			trace("title begun");
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