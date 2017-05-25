package
{
	
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import core.RootClass;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.brinkbit.fullscreenscreenextension.FullScreenExtension;
	import starling.utils.AssetManager;
	
	[SWF(frameRate="60", backgroundColor="#05459C")]
	public class GorillaFling extends Sprite
	{
		
		public function GorillaFling()
		{
			super();
			
			// support autoOrients
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			if (stage)
				start();
			else 
				addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:flash.events.Event):void {
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			start();
		}
		
		private function start():void {
			
		
			Starling.handleLostContext = true;
			
			//load assets
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager();
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
				appDir.resolvePath("assets/textures")
			);
			
			// create the Starling instance
			var mStarling:Starling = FullScreenExtension.createStarling(RootClass, stage, 1180,760);//1180,760
			mStarling.enableErrorChecking = Capabilities.isDebugger;
			
			//Starling.current.showStats = true;
			// load assets and start Starling
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, 
				function onRootCreated(event:Object, root:RootClass):void
				{
					trace(assets," Hello World!")
					root.start(assets);
					mStarling.start();
				});
			
			// handle application stopping and starting
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, 
				function (e:flash.events.Event):void { mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, 
				function (e:flash.events.Event):void { mStarling.stop(); });
			
			
			
		}
	}
}