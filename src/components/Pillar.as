package components
{
	import core.RootClass;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Pillar extends Sprite
	{
		public function Pillar()
		{
			super();
			create()
		}
		private function create():void{
			for(var i:int=0;i<6;i++){
				var mc:Image
				if(i==5){
				mc=new Image(RootClass.assets.getTexture("building_top"));
				mc.scaleX=mc.scaleY=0.88;
				}else{
				mc=new Image(RootClass.assets.getTexture("side_pillar_block"));
				}
					addChild(mc);
					mc.y=((mc.height*mc.scaleX)*i)*-1;			}
		
		}
	}
}