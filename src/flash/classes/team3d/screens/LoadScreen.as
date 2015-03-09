package team3d.screens
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import com.jakobwilson.Asset;
	import com.jakobwilson.AssetManager;
	import flash.display.Sprite;
	import flash.events.Event;
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
		
		private var		_bChasing	:Boolean;
		private var 	_mob		:Sprite;
		
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
			
			_mob = LoaderMax.getContent("monstersmall");
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
			this.addEventListener(MouseEvent.MOUSE_MOVE, chaseMouse);
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
			
			loadAssets();
			_bChasing = true;
			
			position = new Vector3D(_mob.x, _mob.y);
			velocity = new Vector3D(-1, -2);
			target = new Vector3D(0, 0);
			desired = new Vector3D(0, 0);
			steering = new Vector3D(0, 0);
		}
		
		private function loadAssets()
		{
			AssetManager.instance.enqueue("Wall", "Models/Wall/WallSegment.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Floor", "Models/Floor/Floor.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Sky", "Models/Sky/NightSky.awd", Asset.SKYBOX);
			AssetManager.instance.enqueue("DebugSky", "Models/Sky/AxisSky.awd", Asset.SKYBOX);//remove for release
			AssetManager.instance.enqueue("Cage", "Models/Cage/Cage.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("Cannon", "Models/Cannon/Cannon.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.enqueue("CannonBall", "Models/CannonBall/CannonBall.awd", Asset.SPHERE, Asset.DYNAMIC);
			AssetManager.instance.enqueue("Monster", "Models/Monster/Monster.awd", Asset.BOX, Asset.STATIC);
			AssetManager.instance.load(this.onProgress, this.onComplete);
		}
		
		var prevPerc:Number;
		private function onProgress($e:Number)
		{
			var curPerc:Number = $e;
			var show:int = int(Math.round(_aArrows.length * (curPerc - prevPerc)));
			for (var i:int = 0; i < show; i++)
			{
				TweenMax.fromTo(_aArrows[show + i], 0.5, { autoAlpha:0 }, { autoAlpha:1 } );
			}
			
			prevPerc = curPerc;
		}
		
		private function onComplete()
		{
			var tf:TextField = TextField(this.getChildByName("loadingText"));
			TweenMax.fromTo(tf, 0.5, { autoAlpha:1 }, { autoAlpha:0, delay:1 } );
			for (var i:int = 0; i < _aArrows.length; i++)
				TweenMax.fromTo(_aArrows[i], 0.5, { autoAlpha:1 }, { autoAlpha:0, delay:1 } );
			
			TweenMax.fromTo(this.getChildByName("btnContinue"), 0.5, { autoAlpha:0 }, { autoAlpha:1, delay:1 } );
		}
		
		private function doneClick(e:MouseEvent):void 
		{
			SoundAS.playFx("Button");
			this.DoneSignal.dispatch();
		}
		
		//http://gamedevelopment.tutsplus.com/tutorials/understanding-steering-behaviors-seek--gamedev-849
		public static const MAX_FORCE 		:Number = 2.4;
		public static const MAX_VELOCITY 	:Number = 3;
		public static const SENSITIVITY		:Number = 0.5;
		
		public var position 	:Vector3D;
		public var velocity 	:Vector3D = new Vector3D(-1, -2);
		public var target 		:Vector3D = new Vector3D(0, 0);
		public var desired 		:Vector3D = new Vector3D(0, 0);
		public var steering 	:Vector3D = new Vector3D(0, 0);
		public var mass			:Number = 5;
		private function chaseMouse($e:MouseEvent):void
		{
			position = new Vector3D(_mob.x, _mob.y);
			target	 = new Vector3D(World.instance.stage.mouseX, World.instance.stage.mouseY);
			
			truncate(velocity, MAX_VELOCITY);
		}
		
		private function seek(target:Vector3D):Vector3D
		{
			var force :Vector3D;
			var distance:Number;
			desired = target.subtract(position);
			distance = desired.length;
			desired.normalize();
			
			desired.x *= MAX_VELOCITY;
			desired.y *= MAX_VELOCITY;
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		private function truncate(vector:Vector3D, max:Number):void
		{
			var i :Number;

			i = max / vector.length;
			i = i < 1.0 ? 1.0 : i;
			
			vector.scaleBy(i);
		}
		
		private function enterFrame($e:Event):void
		{
			if(Math.abs(_mob.x - World.instance.stage.mouseX) >= SENSITIVITY && Math.abs(_mob.y - World.instance.stage.mouseY) >= SENSITIVITY)
			{
				steering = seek(target);
				
				truncate(steering, MAX_FORCE);
				steering.scaleBy(1 / mass);
				
				velocity = velocity.add(steering);
				truncate(velocity, MAX_VELOCITY);
				
				position = position.add(velocity);
				
				_mob.x = position.x;
				_mob.y = position.y;
				
			}
			//_mob.rotationZ = (Math.atan2(World.instance.stage.mouseX - _mob.x, World.instance.stage.mouseY - _mob.y) * 180 / Math.PI)
		}
		
		/* ---------------------------------------------------------------------------------------- */
		
		/**
		 * Ends the screen
		 */
		override public function End():void
		{
			super.End();
			
			TweenMax.fromTo(this, _fadeTime, { autoAlpha: 1 }, { autoAlpha:0 } );
		}
	}
}

