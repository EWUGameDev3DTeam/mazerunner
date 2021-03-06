﻿package team3d.screens
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.osflash.signals.Signal;
	import team3d.bases.BaseScreen;
	import team3d.objects.World;
	import team3d.ui.GameButton;
	import team3d.ui.Monster2D;
	import treefortress.sound.SoundAS;
	
	/**
	 * Title Screen
	 * 
	 * @author Nate Chatellier
	 */
	public class LoadScreen extends BaseScreen
	{
		
		/* ---------------------------------------------------------------------------------------- */
		
		private var		_aArrows	:Vector.<Sprite>;
		private var 	_mob		:Monster2D;
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Constructs the TitleScreen object.
		 */
		public function LoadScreen()
		{
			super();
			
			this.DoneSignal = new Signal();
			_aArrows = new Vector.<Sprite>(25, true);
			_screenTitle = "Loading";
			
			initComps();
		}
		
		private function initComps()
		{
			var background:Sprite = Sprite(LoaderMax.getContent("overlayLoad"));
			this.addChild(background);
			
			var format:TextFormat = new TextFormat();
			format.size = 30;
			format.bold = true;
			
			var tf:TextField = new TextField();
			tf.name = "loadingText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Loading...";
			tf.x = 50;
			tf.y = 425;
			this.addChild(tf);
			
			format = new TextFormat();
			format.size = 48;
			format.bold = true;
			tf = new TextField();
			tf.name = "summaryText";
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			tf.selectable = false;
			tf.textColor = 0x000000;
			tf.visible = true;
			tf.alpha = 1;
			tf.text = "Sentenced to life you have chosen to take\n";
			tf.appendText("on the Doxen Empire's maze.\n");
			tf.appendText("This is your only chance for escape;\n");
			tf.appendText("however, those who fail die...\n");
			tf.appendText("        ... and there is no turning back.");
			tf.x = 45;
			tf.y = 100;
			this.addChild(tf);
			
			_aArrows[0] = LoaderMax.getContent("loadingArrow0");
			_aArrows[0].x = 50;
			_aArrows[0].y = 475;
			this.addChild(_aArrows[0]);
			for (var i:int = 1; i < _aArrows.length; i++)
			{
				_aArrows[i] = LoaderMax.getContent("loadingArrow" + i);
				_aArrows[i].x = _aArrows[i - 1].x + _aArrows[i].width * 0.5 + 5;
				_aArrows[i].y = _aArrows[i - 1].y;
				this.addChild(_aArrows[i]);
			}
			
			var btn:GameButton = new GameButton();
			btn.name = "btnContinue";
			btn.visible = false;
			btn.x = (this.width - btn.width) * 0.5;
			btn.y = 450 - btn.height * 0.5 + 20;
			btn.text("Proceed");
			format = new TextFormat();
			format.size = 60;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			btn.textFormat = format;
			btn.addEventListener(MouseEvent.CLICK, doneClick);
			this.addChild(btn);
			
			_mob = new Monster2D(LoaderMax.getContent("monstersmall"));
			_mob.name = "monstersmall";
			_mob.x = this.width * 0.5;
			_mob.y = this.height * 0.5;
			this.addChild(_mob);
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Does stuff to start the screen
		 */
		override public function Begin():void
		{
			super.Begin();
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha:0 }, { autoAlpha:1 } );
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			_mob.Begin();
			
			loadAssets();
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			_mob.Target = new Vector3D(World.instance.stage.mouseX, World.instance.stage.mouseY);
		}
		
		private function loadAssets()
		{
			AssetManager.instance.enqueue("Wall", "models/wall/wallsegment.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Floor", "models/floor/floor.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Sky", "models/sky/nightsky.awd", Asset.SKYBOX);
			AssetManager.instance.enqueue("DebugSky", "models/sky/axissky.awd", Asset.SKYBOX);//remove for release
			AssetManager.instance.enqueue("Cage", "models/cage/platform.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Cannon", "models/cannon/cannon.awd", Asset.NONE);
			AssetManager.instance.enqueue("CannonBall", "models/cannonball/cannonball.awd", Asset.SPHERE, Asset.DYNAMIC);
			AssetManager.instance.enqueue("Monster", "models/monster/monster.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Ground", "models/ground/ground.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.load(this.onProgress, this.onComplete);
		}
		
		var prevPerc:Number;
		var prevNum:int = 0;
		private function onProgress($e:Number)
		{
			var curPerc:Number = $e;
			var show:int = int(Math.round(_aArrows.length * (curPerc))) - 1;
			for (var i:int = prevNum; i < show; i++)
			{
				TweenMax.fromTo(_aArrows[i], 0.5, { autoAlpha:0 }, { autoAlpha:1 } );
			}
			prevNum = show;
			prevPerc = curPerc;
		}
		
		private function onComplete()
		{
			var tf:TextField = TextField(this.getChildByName("loadingText"));
			TweenMax.fromTo(tf, 0.5, { autoAlpha:1 }, { autoAlpha:0, delay:1 } );
			for (var i:int = 0; i < _aArrows.length; i++)
				TweenMax.fromTo(_aArrows[i], 0.5, { autoAlpha:1 }, { autoAlpha:0, delay:1 } );
			
			SoundAS.playFx("LoadingFinished");
				
			TweenMax.fromTo(this.getChildByName("btnContinue"), 0.5, { autoAlpha:0 }, { autoAlpha:1, delay:1 } );
		}
		
		private function doneClick(e:MouseEvent):void 
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
			_mob.End();
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 1 }, { autoAlpha:0 } );
		}
	}
}

