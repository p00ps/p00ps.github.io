package classes.game 
{
	import classes.net.ServerDataGetter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import classes.net.BitmapDataManager;
	/**
	 * ...
	 * @author poops
	 */
	public class Background extends Sprite
	{
		//-----------------------> PROPRIETES <-----------------------//
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function Background() {
		
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			serverDataGetter.loadBg();
			serverDataGetter.addEventListener(Event.COMPLETE, completeBgHandler);
		}
		
		
		//-----------------------> METHODES <-----------------------//
		//-----------------------> LISTENERS <-----------------------//
		private function completeBgHandler(e:Event):void {
			ServerDataGetter(e.target).removeEventListener(Event.COMPLETE, completeBgHandler);
			var l:Loader = ServerDataGetter(e.target).loader;
			var bmpData:BitmapData = new BitmapData(l.width, l.height, true, 0x000000);
			bmpData.draw(l);
			//auto/never/always = snapping //true = smoothy => contour des pixel quand l'img grandie
			var bmp:Bitmap = new Bitmap(bmpData, "auto", true)
			addChild(bmp);
		}
		//-----------------------> GETTERs/SETTERs <-----------------------//

		
		
		
		
		
		
		
		
		
		
	}

}