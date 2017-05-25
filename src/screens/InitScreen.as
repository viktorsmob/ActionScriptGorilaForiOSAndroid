package screens
{		
	import com.freshplanet.ane.AirNativeShare.AirNativeShare;
	import com.freshplanet.ane.AirNativeShare.AirNativeShareObject;
	
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	import ads.AmazonAds;
	
	import core.RootClass;
	import core.ScreenNavigator;
	
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
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
	import starling.utils.VAlign;
	
	
	public class InitScreen extends Screen
	{
		
		//private static const APPLE_APP_ID:String= "420009108";
		private static const PLAY_APP_ID:String= "air.com.rtss.gorillafling"; 
		
		// Store URIs
		private static const PLAY_STORE_BASE_URI:String= "market://details?id=";
		private static const PLAY_REVIEW:String= "&reviewId=0";
		private static const APP_STORE_BASE_URI:String= "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?onlyLatestVersion=false&type=Purple+Software&id=";
		private var settingsContiner:Sprite;
		private var myTransform:SoundTransform = new SoundTransform();
		
		// ----------------- public API --------------------- //
		
		public function InitScreen()
		{
			super();	
		}	
		
		// ----------------- protected API --------------------- //
		
		override protected function initialize():void {
			super.initialize();
			
			FullScreenExtension.stageColor = 0xffffff;
		//	FullScreenExtension.addEventListener(TouchEvent.TOUCH, touched);
			
			// we add this listener so when the device reorients the objects automatically get repositioned
			FullScreenExtension.addEventListener(starling.events.Event.RESIZE, onResize);
			
			// create a bunch of images
			/*battleStartImg = new Image(RootClass.assets.getTexture("BattleStart"));
			addChild(battleStartImg);
			
			leftUIImg = new Image(RootClass.assets.getTexture("UILeft"));
			addChild(leftUIImg);
			
			rightUIImg = new Image(RootClass.assets.getTexture("UIRight"));
			addChild(rightUIImg);
			
			spaceBarLogo = new Image(RootClass.assets.getTexture("SpaceBarLogo"));
			addChild(spaceBarLogo);*/
			addChild(continer);
			menu = new Image(RootClass.assets.getTexture("menu"));
			continer.addChild(menu);
			
			var button:Button=new Button(RootClass.assets.getTexture("button_skin"));
			button.x=764;//(FullScreenExtension.screenWidth+button.width)/2;
			button.y=518;//(FullScreenExtension.screenHeight+button.height)/2;
			continer.addChild(button);
			button.addEventListener(Event.TRIGGERED,gotoGame);
			
/*			var rate_button:Button=new Button(RootClass.assets.getTexture("button_skin"));
			rate_button.x = 560;
			rate_button.y=772;
			rate_button.scaleX=0.58;
			rate_button.scaleY=0.6;			
			continer.addChild(rate_button);
			rate_button.addEventListener(Event.TRIGGERED,rateApp);
			
			var share_button:Button=new Button(RootClass.assets.getTexture("button_skin"));
			share_button.x = 828;
			share_button.y=772;
			share_button.scaleX=0.58;
			share_button.scaleY=0.6;	
			continer.addChild(share_button);
			share_button.addEventListener(Event.TRIGGERED,shareApp);
*/			
			
			var settings_button:Button=new Button(RootClass.assets.getTexture("button_skin"));
			settings_button.x = 1095;
			settings_button.y=772;
			settings_button.scaleX=0.68;
			settings_button.scaleY=0.6;	
			continer.addChild(settings_button);
			settings_button.addEventListener(Event.TRIGGERED,appSettings);
			createSettingsScreen();
			positionImages();
//			AmazonAds.showBannerAd();
		}
		private function createSettingsScreen():void{
			settingsContiner=new Sprite();
			settingsContiner.x=FullScreenExtension.screenLeft;
			settingsContiner.y=FullScreenExtension.screenTop;
			addChild(settingsContiner);
			settingsContiner.visible=false;
			
			var quad:Quad=new Quad(FullScreenExtension.screenWidth,FullScreenExtension.screenHeight,0x000000);			
			quad.alpha=0.6;
			settingsContiner.addChild(quad);
			
			var soundText:TextField = new TextField(400, 100, "Sound", "verdana_20", 50, 0xFFFFFF);
			soundText.vAlign=VAlign.CENTER;
			soundText.hAlign=HAlign.CENTER;
			//soundText.border=true;
			settingsContiner.addChild(soundText);
			soundText.x=(FullScreenExtension.screenRight-soundText.width)/2;
			soundText.y=(FullScreenExtension.screenBottom-soundText.height)/2;
			
			var offImage:Image=new Image(RootClass.assets.getTexture("off"));
			offImage.pivotX=offImage.width/2;
			offImage.pivotY=offImage.height/2;
			offImage.x=soundText.x+soundText.width;
			offImage.y=soundText.y+soundText.height/2;
			settingsContiner.addChild(offImage);
			
			var onImage:Button=new Button(RootClass.assets.getTexture("on"),"");
			onImage.pivotX=onImage.width/2;
			onImage.pivotY=onImage.height/2;
			onImage.x=offImage.x;
			onImage.y=offImage.y;
			settingsContiner.addChild(onImage);			
			onImage.addEventListener(Event.TRIGGERED,soundControl);	
			
			var closeButton:Button=new Button(RootClass.assets.getTexture("close"));			
			closeButton.scaleX=0.6;
			closeButton.scaleY=0.6;
			closeButton.x=FullScreenExtension.screenRight-closeButton.width;
			closeButton.y=FullScreenExtension.screenTop+closeButton.height;
			settingsContiner.addChild(closeButton);	
			closeButton.addEventListener(Event.TRIGGERED,closeSettingScreen);
		}
		private function rateApp(evt:Event):void{
			var snd:Sound = RootClass.assets.getSound("click_snd") as Sound;
				snd.play();
			var appUrl:String;// = APP_STORE_BASE_URI + APPLE_APP_ID;
			if (isAndroid()) {
				appUrl = PLAY_STORE_BASE_URI + PLAY_APP_ID + PLAY_REVIEW;
			}
			
			// Open store URI 	
			var req:URLRequest = new URLRequest(appUrl);
			navigateToURL(req);
		}

		private function isAndroid():Boolean
		{
			return Capabilities.manufacturer.indexOf('Android') > -1;
		}

		private function shareApp(evt:Event):void{
			var snd:Sound = RootClass.assets.getSound("click_snd") as Sound;
			snd.play();
			var myShareObject:AirNativeShareObject = new AirNativeShareObject();
			myShareObject.messageText = "Check out this cool app at https://play.google.com/store/apps/details?id=air.com.rtss.gorillafling on the Google Play Store."
			myShareObject.defaultLink = "http://www.gorillafling.com"
			
			// Display a share dialog for the aforementioned shareObject
			AirNativeShare.getInstance().showShare(myShareObject)
		}

		private function appSettings(evt:Event):void{
			var snd:Sound = RootClass.assets.getSound("click_snd") as Sound;
			snd.play();
			settingsContiner.visible=true;
		}
		
		private function soundControl(evt:Event):void{
			var mc:Button=evt.currentTarget as Button;
				
				mc.alpha=mc.alpha==0?1:0;
				if(mc.alpha==0){
					//SoundMixer.stopAll();
					//myTransform.volume=0;
					SoundMixer.soundTransform = new SoundTransform(0);
				}else{
					SoundMixer.soundTransform = new SoundTransform(1);
					//myTransform.volume=1;
				}
		}
		private function closeSettingScreen(evt:Event):void{
			settingsContiner.visible=false;
		}
		// ----------------- private API --------------------- //
		
		
		
		private var menu:Image;
		private var continer:Sprite=new Sprite();
		private function positionImages():void {
			
			// align to the top center of the stage
			/*battleStartImg.x = (FullScreenExtension.stageWidth - battleStartImg.width) >> 1;
			battleStartImg.y = FullScreenExtension.stageTop;
			
			// align to the bottom left of the screen
			leftUIImg.x = FullScreenExtension.screenLeft;
			leftUIImg.y = FullScreenExtension.screenBottom - leftUIImg.height;
			
			// align to the bottom right of the screen
			rightUIImg.x = FullScreenExtension.screenRight - rightUIImg.width;
			rightUIImg.y = FullScreenExtension.screenBottom - rightUIImg.height;
			
			// align to the center of the stage
			spaceBarLogo.x = (FullScreenExtension.stageWidth - spaceBarLogo.width) >> 1;
			spaceBarLogo.y = (FullScreenExtension.stageHeight - spaceBarLogo.height) >> 1;*/
			//menu.scaleX = Starling.contentScaleFactor;
			
			continer.pivotX=menu.width/2;
			continer.pivotY=menu.height/2;
			continer.x=(FullScreenExtension.stage.stageWidth)/2;
			continer.y=(FullScreenExtension.stage.stageHeight)/2;
			continer.scaleX=0.8;//Starling.contentScaleFactor;
			continer.scaleY=0.8;//Starling.contentScaleFactor;
		}
		private function gotoGame(evt:Event):void{
			var snd:Sound = RootClass.assets.getSound("click_snd") as Sound;
			snd.play();
			ScreenNavigator.instance.showScreen(RootClass.SCREEN_GAME);
		}
		
		private function touched(event:TouchEvent):void {
			var touch:Touch = event.getTouch(Starling.current.stage);
			if (touch && touch.phase == TouchPhase.ENDED) {
				// show and hide the stage bounds when the screen is touched
				FullScreenExtension.showStageBounds = FullScreenExtension.showStageBounds ? false : true;
			}
		}
		
		private function onResize(event:ResizeEvent):void {
			positionImages();
		}
		
	}
}