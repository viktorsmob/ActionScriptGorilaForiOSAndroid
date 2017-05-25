package ads
{
	import com.amazon.mas.cpt.ads.Ad;
	import com.amazon.mas.cpt.ads.AdFit;
	import com.amazon.mas.cpt.ads.AmazonMobileAds;
	import com.amazon.mas.cpt.ads.ApplicationKey;
	import com.amazon.mas.cpt.ads.Dock;
	import com.amazon.mas.cpt.ads.HorizontalAlign;
	import com.amazon.mas.cpt.ads.Placement;
	import com.amazon.mas.cpt.ads.ShouldEnable;
	
	import flash.system.Capabilities;
	
	

	public class AmazonAds
	{

		private static var bannerAd:Ad;

		private static var interstitialAd:Ad;
		
		public function AmazonAds()
		{
//		trace("ok");
//			
		}
		public static function init(androidID:String,iOSID:String):void{
			if(AmazonMobileAds.isSupported()){
				var appKey:String;
				if(Capabilities.manufacturer.match(/Android/i)){
					appKey = androidID;
				}
				else if(Capabilities.manufacturer.match(/iOS/i)){
					appKey = iOSID;
					
				}
				var key:ApplicationKey = new ApplicationKey(appKey);
//				key.stringValue = appKey;
				
				AmazonMobileAds.setApplicationKey(key);
				//AmazonAds.enableTesting(false);
				AmazonAds.enableGeoLocation(true);
				AmazonAds.createBannerAd();
				//AmazonAds.createInterstitialAd();
				
			}
		}
		
		public static function createBannerAd():void{
			var placement:Placement = new Placement(Dock.BOTTOM,HorizontalAlign.CENTER,AdFit.FIT_AD_SIZE);
//			placement.dock = Dock.BOTTOM;
//			placement.horizontalAlign = HorizontalAlign.CENTER;
//			placement.adFit = AdFit.FIT_AD_SIZE;
			bannerAd = AmazonMobileAds.createFloatingBannerAd(placement);
			if(AmazonMobileAds.isInterstitialAdReady()){
				AmazonMobileAds.loadAndShowFloatingBannerAd(bannerAd);
			}
		}
		
		public static function createInterstitialAd():void{
			interstitialAd = AmazonMobileAds.createInterstitialAd();
			if(AmazonMobileAds.loadInterstitialAd()){
				if(AmazonMobileAds.isInterstitialAdReady()){
					AmazonMobileAds.showInterstitialAd();
					
				}
			}
			
		}
		
		public static function showInterstitialAd():void{
			if(AmazonMobileAds.isSupported()){
				if(AmazonMobileAds.isInterstitialAdReady()){
					AmazonMobileAds.showInterstitialAd();
					
				}
			}
		}
		
/*		public static function enableTesting(arg_enable:Boolean):void{
			if(AmazonMobileAds.isSupported()){
				var enable:ShouldEnable = new ShouldEnable();
				enable.booleanValue = arg_enable;
				AmazonMobileAds.enableTesting(disable);
			}
		}
		*/
		
		public static function enableGeoLocation(arg_enable:Boolean):void{
			if(AmazonMobileAds.isSupported()){
				var enable:ShouldEnable = new ShouldEnable(arg_enable);
				
				//enable.booleanValue = arg_enable;
				AmazonMobileAds.enableGeoLocation(enable);
			}
		}
		
		public static function showBannerAd():void{
			if(AmazonMobileAds.isInterstitialAdReady()){
				AmazonMobileAds.loadAndShowFloatingBannerAd(bannerAd);
			}
		}
		
		
		public static function enableTesting(param0:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
	}
}