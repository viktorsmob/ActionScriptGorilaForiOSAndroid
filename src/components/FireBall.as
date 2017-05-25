package components
{
	import core.RootClass;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class FireBall extends Sprite
	{
		public var dx:Number=0;
		public var dy:Number=0;
		public var speed:Number=0;
		public var dir:Number=0;
	//	public var hit_obj:Quad;
		public function FireBall()
		{
			super();
			init();
		}
		private function init():void{
			
			var ball:Image=new Image(RootClass.assets.getTexture("pie"));
			addChild(ball);	
			/*hit_obj=new Quad(10,10,0xFF00FF);
			hit_obj.x=ball.width/2;
			hit_obj.y=ball.height/2;
			addChild(hit_obj);*/
		}
	}
}