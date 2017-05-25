package components
{
	import flash.media.Sound;
	
	import core.RootClass;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Gorilla extends Sprite
	{
		private var animation:String="";
		private var hurt_animation:String="";
		public var gorilla_mc:MovieClip;
		private var gorilla_hurt_mc:MovieClip;
		
		public function Gorilla(gorillaAnimation:String,hurtAnimation:String)
		{
			super();
			animation=gorillaAnimation;
			hurt_animation=hurtAnimation;
			create();
		}
		private function create():void{
			gorilla_mc=new MovieClip(RootClass.assets.getTextures(animation),60);
			addChild(gorilla_mc);
			gorilla_mc.loop=false;
			gorilla_mc.stop();
			Starling.juggler.add(gorilla_mc);
			
			gorilla_hurt_mc=new MovieClip(RootClass.assets.getTextures(hurt_animation),20);
			addChild(gorilla_hurt_mc);
			gorilla_hurt_mc.loop=false;
			gorilla_hurt_mc.stop();
			Starling.juggler.add(gorilla_hurt_mc);
			gorilla_hurt_mc.visible=false;
			gorilla_hurt_mc.addEventListener(Event.COMPLETE,hurtComplete);
		};
		public function pause():void{
			gorilla_mc.pause();
		}
		public function play():void{
			gorilla_mc.play();
		}
		public function stop():void{
			gorilla_mc.stop();
		}
		public function hurtPlay():void{
			var snd:Sound = RootClass.assets.getSound("hit"); 
				snd.play();
			gorilla_hurt_mc.play();
		}
		public function hurtStop():void{
			gorilla_hurt_mc.stop();
		}
		public function set hurtVisible(value:Boolean):void{
			gorilla_mc.visible = !value;
			gorilla_hurt_mc.visible = value;
		}
		private function hurtComplete():void{
			gorilla_mc.visible = true;
			gorilla_hurt_mc.visible=false;
		}
	}
}