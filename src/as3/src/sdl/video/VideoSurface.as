package sdl.video {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import sdl.SDLApplication;
	
	/**
	 * @private
	 * 
	 * A flash representation of SDL_VideoSurface. This class initializes itself around videoData.
	 */
	public class VideoSurface extends Bitmap {
		
		private var screenRectangle:Rectangle;
		
		private var videoSurfaceData:BitmapData;
		private var updateTimer:UpdateTimer;
		private var domainMemory:ByteArray;	// The C virtual machine's RAM
		
		internal var sdlApplication:SDLApplication;
		
		/**
		 * Initialize local variables and construct the Bitmap using videoSurfaceData bitmapData
		 */
		public function VideoSurface( sdlApplication:SDLApplication, width:int, height:int ) {
			
			// Init
			var ram_NS:Namespace = new Namespace("cmodule.sdlApplication");
			this.domainMemory = (ram_NS::gstate).ds;
			this.videoSurfaceData = new BitmapData( width, height, false, 0x0 );
			this.screenRectangle = new Rectangle( 0, 0, width, height );
			this.updateTimer = new UpdateTimer( this );
			
			this.sdlApplication = sdlApplication;
			
			// Pass bitmapData to the super constructor
			super( videoSurfaceData );
		}
		
		/**
		 * Update ram pointer and copy pixels into videoSurfaceData.
		 */
		internal function updateDisplay( displayBuffer:uint ):void {
			domainMemory.position = displayBuffer;
			videoSurfaceData.setPixels( screenRectangle, domainMemory );
		}
		
	}
}