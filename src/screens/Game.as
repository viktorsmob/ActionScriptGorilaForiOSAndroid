package screens
{		
	
	
	import flash.desktop.NativeApplication;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	import ads.AmazonAds;
	
	import caurina.transitions.Tweener;
	
	import components.FireBall;
	import components.Gorilla;
	import components.Pillar;
	
	import core.RootClass;
	
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.brinkbit.fullscreenscreenextension.FullScreenExtension;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.SystemUtil;
	import starling.utils.VAlign;
//	
	
	
	
	
	public class Game extends Screen
	{
		private var bg:Sprite=new Sprite();
		private var menu:Image;
		private var container:Sprite=new Sprite();
		private var gorilla1_mc:Gorilla;
		private var gorilla2_mc:Gorilla;
		private var gorilla1_hurt_mc:MovieClip;
		private var gorilla2_hurt_mc:MovieClip;
		private var gun:MovieClip;
		private var fireBall:FireBall;
		private var gorilla1:Boolean,gorilla2:Boolean;
		private var dx:Number,dy:Number;
		private var GRAVITY:Number = 0.8;
		private var isShoot:Boolean;
		//private var container:MovieClip = new MovieClip();
		private var b:MovieClip;
		private var count:int,pcCount:int,pullCount:int=0;
		private var noOfPoo:int,score:int,enScore:int;
		private var startX:Number,startY:Number,endX:Number,endY:Number;
		private var multiPlayer:Boolean;
		private var dir:Number=0;
		//private var charge:Number=2;
		private var starling_quad:Quad=new Quad(300,200,0xFF00FF);
		private var gun_speed:Number=0;
		private var ground_hit:Quad;
		private var gbuilding_mc:Sprite=new Sprite();
		private var bullet_visible:Boolean=false;
		private var obj_hit:Boolean=false;
		private var bg_end_pos:Number=0;
		private var bg_start_pos:Number=0;
		private var player1Turn:Boolean=true;
		private var player2Turn:Boolean=false;
		private var scaleing:Boolean=false;
		private var gbuilding_hit:Quad;
		private var g1ScoreText:TextField;
		private var g2ScoreText:TextField;
		private var g1poopText:TextField;
		private var g1hit:Quad;
		private var g2hit:Quad;
		private var endScreen:Sprite;
		private var gameOverB:Boolean=false;
		private var mouseUp:Boolean=false;
		private var shootReady:Boolean=false;
		private var gBuildingHeight:int=0;
		private var build_hit_arr:Array=new Array();
		private var buldingVisible:Boolean=true;
		private var gbuild_arr:Array=new Array();
		private var iOS:Boolean;
		//private var fireBall_speed:Number = 0;
		//private var fireBall_dir:Number=0;
		// ----------------- public API --------------------- //
		
		public function Game()
		{
			
			super();	
		}	
		
		// ----------------- protected API --------------------- //
		
		override protected function initialize():void {
			super.initialize();
			iOS = SystemUtil.platform == "IOS";
			FullScreenExtension.stageColor = 0xffffff;
			FullScreenExtension.addEventListener(starling.events.Event.RESIZE, onResize);
			var bottomColor:uint = 0x2E3A49; // blue
			var topColor:uint    = 0x05459C; // red
			var quad:Quad=new Quad(FullScreenExtension.screenWidth,FullScreenExtension.screenHeight);
			quad.setVertexColor(0, topColor);
			quad.setVertexColor(1, topColor);
			quad.setVertexColor(2, bottomColor);
			quad.setVertexColor(3, bottomColor);
			addChild(quad);
			quad.x=FullScreenExtension.screenLeft;
			quad.y=FullScreenExtension.screenTop;
			
			addChild(container);
			
			var bg1:Image=new Image(RootClass.assets.getTexture("bg"));
			bg.addChild(bg1);
			var bg2:Image=new Image(RootClass.assets.getTexture("bg"));
			bg2.x=(bg1.x+bg1.width+bg2.width/2)-1;
			bg2.pivotX=bg2.width/2;
			//bg2.pivotY=bg2.height/2;
			bg2.scaleX=-1;
			bg.addChild(bg2);
			container.pivotX=bg1.width/2;
			container.pivotY=bg1.height/2;
			container.addChild(bg);	
			
			bg_start_pos=bg.x;
			bg_end_pos=(bg1.x+bg1.width+bg2.width*0.62)-FullScreenExtension.stageWidth;
			
			ground_hit=new Quad(bg1.width*2,25,0xFF00FF);
			ground_hit.alpha=0;
			bg.addChild(ground_hit);			
			
			gameAssetsAdding();
			positionImages();
			
			
		}
		
		// ----------------- private API --------------------- //
		
		private function positionImages():void {
						
			container.x=(FullScreenExtension.stage.stageWidth)/2;//FullScreenExtension.screenLeft;
			container.y=(FullScreenExtension.stage.stageHeight)/2;//FullScreenExtension.screenTop;
			container.scaleX=0.8;//Starling.contentScaleFactor;
			container.scaleY=0.8;//Starling.contentScaleFactor;
		}
		private function gameAssetsAdding():void{		
			
			var pillar1_mc:Pillar=new Pillar();
			pillar1_mc.x=bg.width*0.01;
			bg.addChild(pillar1_mc);
			
			var pillar2_mc:Pillar=new Pillar();
				pillar2_mc.x=bg.width*0.95;
			bg.addChild(pillar2_mc);
			pillar1_mc.y=pillar2_mc.y=bg.height*0.52;
			
			var g1ScoreBg:Image=new Image(RootClass.assets.getTexture("score"));
			bg.addChild(g1ScoreBg);
			
			var g2ScoreBg:Image=new Image(RootClass.assets.getTexture("score"));
			bg.addChild(g2ScoreBg);
			
			var g1PoopBg:Image=new Image(RootClass.assets.getTexture("pie left"));
			bg.addChild(g1PoopBg);
			
			g1ScoreBg.x=bg.width*0.4;
			g2ScoreBg.x=bg.width*0.6;
			g1PoopBg.x=bg.width*0.3;
			g1ScoreBg.y =g2ScoreBg.y = g1PoopBg.y= FullScreenExtension.screenTop+g1ScoreBg.height/1.5;//bg.height*0.05;//bg.height*0.09;
			
				
			g1ScoreText = new TextField(200, 50, "1", "verdana_20", 25, 0xFFFFFF);
			bg.addChild(g1ScoreText);
			g1ScoreText.x=g1ScoreBg.x+35;
			g1ScoreText.y=g1ScoreBg.y+31;
			//g1ScoreText.border=true;
			g1ScoreText.hAlign = HAlign.CENTER;
			
			g2ScoreText = new TextField(200, 50, "1", "verdana_20", 25, 0xFFFFFF);
			bg.addChild(g2ScoreText);
			g2ScoreText.x=g2ScoreBg.x+35;
			g2ScoreText.y=g2ScoreBg.y+31;
			g2ScoreText.hAlign = HAlign.CENTER;
			
			g1poopText = new TextField(200, 50, "0", "verdana_20", 25, 0xFFFFFF);
			bg.addChild(g1poopText);
			g1poopText.x=g1PoopBg.x+35;
			g1poopText.y=g1PoopBg.y+31;
			g1poopText.hAlign = HAlign.CENTER;
			
			gbuilding_mc.x=(bg.width*0.5)-gbuilding_mc.width/2;
			gbuilding_mc.y=bg.height*0.85;//0.35,465;
			bg.addChild(gbuilding_mc);
						
			ground_hit.y=gbuilding_mc.y+60;
			
			/*gorilla1_mc=new MovieClip(RootClass.assets.getTextures("gorilla1_"),60);
			bg.addChild(gorilla1_mc);
			gorilla1_mc.loop=false;
			gorilla1_mc.stop();
			Starling.juggler.add(gorilla1_mc);
						
			gorilla2_mc=new MovieClip(RootClass.assets.getTextures("gorilla2_"),60);
			bg.addChild(gorilla2_mc);
			gorilla2_mc.loop=false;
			gorilla2_mc.stop();
			Starling.juggler.add(gorilla2_mc);*/
			
			gorilla1_mc = new Gorilla("gorilla1_","gorilla1hurt_");
			gorilla1_mc.scaleX=1.5;
			gorilla1_mc.scaleY=1.5;			
			bg.addChild(gorilla1_mc);
			
			gorilla2_mc = new Gorilla("gorilla2_","gorilla2hurt_");
			gorilla2_mc.scaleX=1.5;
			gorilla2_mc.scaleY=1.5;	
			bg.addChild(gorilla2_mc);
			
			
			gorilla1_mc.x=bg.width*0.02;
			gorilla2_mc.x=bg.width*0.8;
			gorilla1_mc.y=gorilla2_mc.y= bg.height*0.45;//0.58;
			
			g1hit= new Quad(100,360,0xFFFFFF);
			g1hit.x=gorilla1_mc.x+280;
			g1hit.y=gorilla1_mc.y+100;
			g1hit.alpha=0;
			bg.addChild(g1hit);
			
			g2hit= new Quad(100,370,0xFFFFFF);
			g2hit.x=gorilla2_mc.x+260;
			g2hit.y=gorilla2_mc.y+100;
			g2hit.alpha=0;
			bg.addChild(g2hit);
						
			/*gorilla1_hurt_mc=new MovieClip(RootClass.assets.getTextures("gorilla1hurt_"),20);
			bg.addChild(gorilla1_hurt_mc);
			gorilla1_hurt_mc.loop=false;
			gorilla1_hurt_mc.stop();
			Starling.juggler.add(gorilla1_hurt_mc);
			gorilla1_hurt_mc.visible=false;
			gorilla1_hurt_mc.x=gorilla1_mc.x;
			gorilla1_hurt_mc.y=gorilla1_mc.y;
			
			gorilla2_hurt_mc=new MovieClip(RootClass.assets.getTextures("gorilla2hurt_"),20);
			bg.addChild(gorilla2_hurt_mc);
			gorilla2_hurt_mc.loop=false;
			gorilla2_hurt_mc.stop();
			Starling.juggler.add(gorilla2_hurt_mc);
			gorilla2_hurt_mc.visible=false;
			gorilla2_hurt_mc.x=gorilla2_mc.x;
			gorilla2_hurt_mc.y=gorilla2_mc.y;*/
			
			gun = new MovieClip(RootClass.assets.getTextures("gun00"),24);
			gun.stop();			
			gun.x=bg.width*0.16;
			gun.y=bg.height*0.65;
			gun.pivotX=gun.width/2;
			gun.pivotY=gun.height/2;			
			Starling.juggler.add(gun);
			bg.addChild(gun);	
			
			var bg_snd:Sound= RootClass.assets.getSound("Busy_Corner") as Sound;
			bg_snd.play(0,10000);
			gameStart();
		}
		
		private function gameStart():void{
			if(endScreen!=null){
				bg.removeChild(endScreen);
			}
			//AmazonAds.createInterstitialAd();
			AmazonAds.createBannerAd();
			gbuildingCreating();
			gbuilding_mc.visible=true;
			enScore=0;
			score=0;
			noOfPoo = 10;
			count=0;
			dir = 0;0
			player2Turn=false;
			buldingVisible=true;
			gbuilding_mc.alpha=1;
			g1ScoreText.text=""+score;
			g2ScoreText.text=""+enScore;
			g1poopText.text=""+noOfPoo;
			gameOverB=false;
			p1Turn();					
		}
		private function p1Turn():void{
			gorilla1=true;
			gorilla2=false;
			obj_hit=false;
			bullet_visible=false;
			scaleing=false;
			gorilla1_mc.stop();
			gun.visible=true;
			bg.addEventListener(TouchEvent.TOUCH, rotate);
		}
		private function rotate(evt:TouchEvent):void{
			if(!gameOverB){
			var touch:Touch = evt.getTouch(bg, TouchPhase.MOVED);
			var touch_began:Touch = evt.getTouch(bg, TouchPhase.BEGAN);
			var touch_end:Touch = evt.getTouch(bg, TouchPhase.ENDED);
			if(touch_began){				
				bullet_visible=false;
				dir = 0;
				gorilla1_mc.play();
				fireBall = new FireBall();
				bg.addEventListener(Event.ENTER_FRAME, loop);
			}else if(touch_end){
				mouseUp=true;				
			}else if (touch)
			{
				if(pullCount<=30){
					pullCount++;
				}
				var localPos:Point = touch.getLocation(bg);
				
				var dx:Number =localPos.x-gun.x; 
				var dy:Number =localPos.y-gun.y; 
				var gun_rotation:Number= Math.atan2(dy,dx);//*(180/Math.PI);
				var dist:int=Math.sqrt(dx*dx+dy*dy)/5;
				
				if(dist < gun.numFrames){
					gun.currentFrame=dist;				
				}else{
					gun.currentFrame=gun.numFrames-1;
				}
				if(gun_rotation<0 && gun_rotation>-1){
					dir=gun_rotation;
				}else if(gun_rotation>2&&gun_rotation<3.5){
					var mc_dir:Number=180-(gun_rotation*(180/Math.PI));
					dir=(mc_dir/(180/Math.PI))*-1;//gun_rotation;
				};
				
					gun.rotation = dir;			
			}
			}
		}
		
		private function loop(evt:Event):void{			
			if(gorilla1_mc.gorilla_mc.currentFrame>=30 && bullet_visible==false){
				shootReady=true;
				gorilla1_mc.pause();
				bullet_visible=true;
				fireBall.x = gorilla1_mc.x+75;
				fireBall.y = gorilla1_mc.y;
			}
			if(shootReady && mouseUp){		
				var snd:Sound=RootClass.assets.getSound("Swoosh");
					snd.play();
				bg.removeEventListener(Event.ENTER_FRAME, loop);
				bg.removeEventListener(TouchEvent.TOUCH, rotate);
				shootReady=false;
				mouseUp=false;
				noOfPoo--;
				gun_speed=gun.currentFrame;
				gun.stop();	
				gun.visible=false;
				fireBall.speed = gun_speed;					
				fireBall.dir = gun.rotation;
				angle(fireBall);
				fireBall.addEventListener(Event.ENTER_FRAME,updateballpos);
				bg.addChild(fireBall);
				
				gorilla1_mc.play();				
				g1poopText.text = ""+noOfPoo;
			}
			
		}
		private function updateballpos():void{
			onMove(fireBall);			
		}
		private function angle(mc):void{			
			var degrees:Number =mc.dir;//(180/Math.PI);//2;
			mc.dx = Math.cos(degrees)*mc.speed;
			mc.dy = Math.sin(degrees)*mc.speed;
			if(player2Turn){
				mc.dx*=-1;
			}
		}
		private function onMove(mc):void{	
		mc.x+=mc.dx;
			mc.y+=mc.dy;
			mc.dy += GRAVITY;
		if((gorilla1 && mc.x>=(FullScreenExtension.stage.stageWidth) && bg.x>bg_end_pos*-1 )||(gorilla2 && mc.x<=(bg.width-FullScreenExtension.stage.stageWidth/1.5) && bg.x<bg_start_pos)){
			bg.x-=mc.dx;
			}
			if(bg.x<bg_start_pos && mc.y <0 && container.scaleX>0.7 && !scaleing){
				
				container.scaleX-=0.01;
				container.scaleY-=0.01;
				if(container.scaleX == 0.7)
					scaleing=true;
			}
//			if(container.scaleX<0.8 && bg.x <= (bg.width/3)*-1 && scaleing){
			if(container.scaleX<0.8 && mc.y >= 0 && scaleing){
				container.scaleX+=0.01;
				container.scaleY+=0.01;
			};
			if(mc.x > (bg.width-100) || mc.x < 0){
				mc.removeEventListener(Event.ENTER_FRAME,updateballpos);
				bg.removeChild(mc);
				bgMovingComplete();
			}
			var snd:Sound;
			var bounds1:Rectangle = mc.bounds;
			var bounds2:Rectangle = ground_hit.bounds;
			var g1bounds:Rectangle = g1hit.bounds;
			var g2bounds:Rectangle = g2hit.bounds;
			if (bounds1.intersects(bounds2) ){
				mc.removeEventListener(Event.ENTER_FRAME,updateballpos);
				createblast();
			}else if(bounds1.intersects(g1bounds)&& gorilla2==true){
				snd=RootClass.assets.getSound("punch1");
				snd.play();
				gorilla1_mc.hurtVisible=true;
//				gorilla1_hurt_mc.visible=true;
				gorilla1_mc.hurtStop();
				gorilla1_mc.hurtPlay();
				//gorilla1_hurt_mc.addEventListener(Event.COMPLETE,animationCange);
				enScore+=20;
				g2ScoreText.text=""+enScore;
				createblast()
			}else if(bounds1.intersects(g2bounds) && gorilla1==true){	
				snd=RootClass.assets.getSound("punch1");
				snd.play();
				gorilla2_mc.hurtVisible=true;
			//	gorilla2_hurt_mc.visible=true;
				gorilla2_mc.hurtStop();
				gorilla2_mc.hurtPlay();
				//gorilla2_hurt_mc.addEventListener(Event.COMPLETE,animationCange);
				score += 20;
				g1ScoreText.text=""+score;
				createblast();
			}else {
				for(var j:int=0;j<build_hit_arr.length;j++){
					var bound:Rectangle = build_hit_arr[j].bounds;
					if(bounds1.intersects(bound) && build_hit_arr[j].visible==true){
						obj_hit=true;
						build_hit_arr[j].visible=false;
						bg.removeChild(build_hit_arr[j]);
						createblast(build_hit_arr[j].x);
						if(gorilla1){
							score+=10;
							g1ScoreText.text=""+score;
						}else if(gorilla2){
							enScore+=10;
							g2ScoreText.text=""+enScore;
						}
						gbuild_arr[j].play();
						gbuild_arr[j].addEventListener(Event.COMPLETE,hideBlock);
						resetrBlocks(j);//gbuild_arr[j]
						mc.removeEventListener(Event.ENTER_FRAME,updateballpos);
						break;
					}
				}
			
			}
		}
		private function resetrBlocks(num:int):void{
			
			if(num<7){
				for(var i:int=0;i<7;i++){
					if(i>num){
						Tweener.addTween(gbuild_arr[i],{y:gbuild_arr[i].y+120,time:0.8,delay:0.8});
						Tweener.addTween(build_hit_arr[i],{y:build_hit_arr[i].y+120,time:0.8,delay:0.8});
					}
				}
			}else {
				for(var j:int=7;j<14;j++){
					if(j>num){
						Tweener.addTween(gbuild_arr[j],{y:gbuild_arr[j].y+120,time:0.8,delay:0.8});
						Tweener.addTween(build_hit_arr[j],{y:build_hit_arr[j].y+120,time:0.8,delay:0.8});
					}
				}
			}
			
		}
		private function hideBlock(evt:Event):void{
			MovieClip(evt.currentTarget).visible=false;
		}
		/*private function animationCange():void{
			if(gorilla1){
				gorilla2_mc.visible=true;
				gorilla2_hurt_mc.visible=false;
			}else{
				gorilla1_mc.visible=true;
				gorilla1_hurt_mc.visible=false;
			}
		}*/
		private function createblast(posx=null):void{
			var blast:MovieClip=new MovieClip(RootClass.assets.getTextures("blast"),75);
				blast.loop=false;
				Starling.juggler.add(blast);
				if(obj_hit){
					var Snd:Sound=RootClass.assets.getSound("building_blast");
					Snd.play();
					if(gbuilding_mc.x+gbuilding_mc.width/2 < posx){
					blast.x=gbuilding_mc.width-blast.width;
					}else{
					blast.x=0;//fireBall.x;					
					}
					//blast.x=0;
					blast.y=fireBall.y-gbuilding_mc.y;//fireBall.y;
					gbuilding_mc.addChild(blast);
				}else{
					blast.x=fireBall.x;//fireBall.x;
					blast.y=fireBall.y//-gbuilding_mc.y;//fireBall.y;
					bg.addChild(blast);
				}
				blast.play();				
				bg.removeChild(fireBall);				
				blast.addEventListener(Event.COMPLETE,blastanimationComplete);				
		}
		private function blastanimationComplete(evt:Event):void{
			var mc:MovieClip=evt.currentTarget as MovieClip;
				mc.stop();
			if(obj_hit){
				/*var img:Image
				var str:String="image_blast"+Math.ceil(Math.random()*3);			
				img=new Image(RootClass.assets.getTexture(str));						
				img.x=mc.x;
				img.y=mc.y;				
				gbuilding_mc.addChild(img);
				if(gBuildingHeight < mc.y+img.height){
					gbuilding_mc.removeChild(img);
				}*/
				//count++;
			}else{
				bg.removeChild(mc);
			}
			bg.removeEventListener(Event.ENTER_FRAME, loop);
						
			gbuilding_mc.removeChild(mc);
			
			
			//bg_end_pos
			if(gorilla1){
				Tweener.addTween(bg,{x:-bg_end_pos,time:2,delay:2,onComplete:bgMovingComplete});
			}else if(gorilla2){
				Tweener.addTween(bg,{x:bg_start_pos,time:2,delay:2,onComplete:bgMovingComplete});
			}
		}
		
		// players change
		private function bgMovingComplete():void{
			if(container.scaleX<0.8){
				Tweener.addTween(container,{scaleX:0.8,scaleY:0.8,time:0.2});
			}
			player2Turn=!player2Turn;
			player1Turn=!player1Turn;
			if(player2Turn){
				//player2angle();
				Tweener.addTween(container,{delay:1,onComplete:p2Turn});
			}else{
				Tweener.addTween(container,{delay:1,onComplete:p1Turn});
			}
		}
		private function p2Turn():void{
			if(noOfPoo<=0){
				gameOverB=true;
				bg.removeEventListener(TouchEvent.TOUCH, rotate);
				gameOver();
			}else{
			gorilla1=false;
			gorilla2=true;
			//charge = 0;
			dir = 0;
			obj_hit=false;
			bg.removeEventListener(Event.ENTER_FRAME, loop);
			
			/*if(gbuilding_mc.currentFrame==gbuilding_mc.totalFrames){
				gun.charge = 15+Math.random()*10;
				gun.dir = -65+Math.random()*-10;
			}
			else{*/
			//var angles:Number=(90+Math.random()*90)
			fireBall= new FireBall();
			fireBall.speed = 30+Math.random()*15;
			fireBall.dir = (Math.random()*-1);//-75+Math.random()*-20;
			//}
			bg.addEventListener(Event.ENTER_FRAME, eLoop);
			gorilla2_mc.stop();
			gorilla2_mc.play();
			bullet_visible=false;
			}
		}
		private function eLoop(evt:Event):void{
			if(gorilla2_mc.gorilla_mc.currentFrame>=19 && bullet_visible==false){
				//gorilla2_mc.pause();
				bullet_visible=true;				
				fireBall.x = gorilla2_mc.x+75;
				fireBall.y = gorilla2_mc.y;
				bg.addChild(fireBall);						
				angle(fireBall);
				var snd:Sound=RootClass.assets.getSound("Swoosh");
				snd.play();
				bg.removeEventListener(Event.ENTER_FRAME, eLoop);
				fireBall.addEventListener(Event.ENTER_FRAME,updateballpos);
				//Tweener.addTween(container,{delay:0.5,onComplete:p2FireBallShoot});
				
			}
			//onMove(fireBall);
		}
		/*private function p2FireBallShoot():void{
			gorilla2_mc.play();
			fireBall.addEventListener(Event.ENTER_FRAME,updateballpos);
		}*/
		/*private function touched(event:TouchEvent):void {
			var touch:Touch = event.getTouch(Starling.current.stage);
			if (touch && touch.phase == TouchPhase.ENDED) {
				// show and hide the stage bounds when the screen is touched
				FullScreenExtension.showStageBounds = FullScreenExtension.showStageBounds ? false : true;
			}
		}*/
		
		private function onResize(event:ResizeEvent):void {
			positionImages();
		}
		private function gameOver():void{
			//trace("ad starting");
			
			//AmazonAds.createInterstitialAd();
			AmazonAds.createBannerAd();
			bg.removeEventListener(Event.ENTER_FRAME, eLoop);
			fireBall.removeEventListener(Event.ENTER_FRAME,updateballpos);
			bg.removeChild(fireBall);	
			fireBall=null;
			endScreen=new Sprite();
			bg.addChild(endScreen);
			gbuilding_mc.visible=false;
			for(var i:int=gbuilding_mc.numChildren-1;i>0;i--){
				if(gbuilding_mc.getChildAt(i).name!="building"){
					gbuilding_mc.removeChild(gbuilding_mc.getChildAt(i));
				}
			}
			var scoreBg:Image=new Image(RootClass.assets.getTexture("end_score_bg"));			
				endScreen.addChild(scoreBg);
				endScreen.x=FullScreenExtension.stage.stageWidth/2;
				endScreen.y=(FullScreenExtension.stage.stageHeight-(scoreBg.height/2))/2;
				Tweener.addTween(bg,{x:bg_start_pos,time:0.5});
			var title:Image; 
			var scores:int=0;
			var snd:Sound;
			if(score>enScore){
				title=new Image(RootClass.assets.getTexture("youwin"));
				scores=score;
				snd = RootClass.assets.getSound("win");
				
			}else{
				title=new Image(RootClass.assets.getTexture("youlose"));
				scores=enScore;
				snd = RootClass.assets.getSound("loas");
			}
			title.x=(endScreen.width-title.width)/2;
			title.y=title.height*0.3;
			endScreen.addChild(title);
			snd.play();
			var score_txts:TextField=new TextField(300, 150, "Score", "verdana_20", 75, 0x000000);
			score_txts.x=(endScreen.width-score_txts.width)/2;			
			score_txts.y=endScreen.height*0.3;
			score_txts.vAlign=VAlign.CENTER;
			endScreen.addChild(score_txts);
			
			var score_txt:TextField=new TextField(300, 150, ""+scores, "verdana_20", 75, 0x000000);
			score_txt.x=(endScreen.width-score_txt.width)/2;			
			score_txt.y=endScreen.height*0.45;
			score_txt.vAlign=VAlign.CENTER;
			endScreen.addChild(score_txt);
			
			var btn:Button=new Button(RootClass.assets.getTexture("Replay_btn"),"");
			btn.x=(endScreen.width-btn.width)/2;			
			btn.y=endScreen.height*0.70;
			endScreen.addChild(btn);
			btn.addEventListener(Event.TRIGGERED,playAgain);
			if(iOS == false){
			var end_btn:Button=new Button(RootClass.assets.getTexture("end_button"),"");
			end_btn.x=(endScreen.width-btn.width)/2;			
			end_btn.y=endScreen.height*0.85;
			endScreen.addChild(end_btn);
			end_btn.addEventListener(Event.TRIGGERED,gameClose);
			}
		}
		private function playAgain(evt:Event):void{
			var btn_snd:Sound=RootClass.assets.getSound("click_snd");
			btn_snd.play();
			Tweener.addTween(endScreen,{alpha:0,time:0.5,onComplete:gameStart});
			//gameStart();
		}
		private function gbuildingCreating():void{
			if(gbuild_arr.length != 0){
				for(var j:int=0;j<gbuild_arr.length;j++){
					gbuilding_mc.removeChild(gbuild_arr[j]);
					bg.removeChild(build_hit_arr[j]);
				}
				gbuild_arr=[];
				build_hit_arr=[];
			}
			
			var randomx:int=0;
			var randomy:int=1;
			var top_bloc:Number=0;
			var blockScale:Number=1;
			var img_name:String="left";
			for(var i:int=1;i<=14;i++){
				var img:MovieClip
				if(i==8){
					randomy=1;
					randomx++;
					blockScale=-1;
					img_name="right";
				}
				if(i%7==0){					
					img=new MovieClip(RootClass.assets.getTextures("top_block_"),10);
					top_bloc=1.5;
				}else{
					img=new MovieClip(RootClass.assets.getTextures("below_block_"),10);
					top_bloc=0;
				}
				img.name=img_name+randomy;
				img.x=(-10+img.width*2)*randomx;
				img.y=(top_bloc+120)*randomy*-1;
				img.scaleX=blockScale;
				gbuilding_mc.addChild(img);
				img.loop=false;
				img.stop();
				Starling.juggler.add(img);
				randomy++;
				gbuild_arr.push(img);
				
				var hit_quad:Quad = new Quad(75,75,0xFFFFFF);
				hit_quad.x=50+gbuilding_mc.x+100*randomx;
				hit_quad.y= gbuilding_mc.y+(120*(randomy-1)*-1);
				hit_quad.alpha=0;
				bg.addChild(hit_quad);
				build_hit_arr.push(hit_quad);
			}
			
			
			
			gBuildingHeight = gbuilding_mc.height+40;
		}
		private function gameClose():void{
			NativeApplication.nativeApplication.exit(); 
			//fscommand("quit");
		}
		
	}
}