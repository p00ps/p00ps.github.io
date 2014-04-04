package classes.game 
{
	import classes.net.ServerDataGetter;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import classes.net.XmlManager;
	import classes.net.BitmapDataManager;
	import flash.events.Event;
	import flash.display.Loader;
	/**
	 * ...
	 * @author poops
	 */
	public class Case extends Sprite
	{
		
		//-----------------------> PROPRIETES <-----------------------//
		public var _xml:XML;
		public var type:String;
		
		//-----------------------> CONSTRUCTEURS <-----------------------//
		public function Case() 
		{
			
		}
		
		//-----------------------> METHODES <-----------------------//
		public function init(pNum:int, pXml:XML):void {
			_xml = pXml;
			y = pNum * XmlManager.XMLLEVEL.config.tile.@height;
			//gestion du viduel
			/*class bitmapmanager permet de mémo les bitmap des element image constituant le decor (cases)
			 * soit la bitmapdata est null dans la class, l'image na encore jms été used, soit elle est chargé
			 * sinon img deja chargé, la bitmapdata a été enregistré donc la case peur passer à l'affichage de l'img*/
			//[pXml.@memo]=mini obj de donnée = concaténation
			//if (pXml.hasOwnProperty("@mechant")) {
				//if (pXml.@mechant == "citrouille") {
					//type = "citrouille";
					//var citrouille:Citrouille = new Citrouille;
					//addChild(citrouille)
				//}else if (pXml.@mechant == "ghost") {
					//type = "ghost";
					//var ghost:Ghost = new Ghost;
					//addChild(ghost);
				//}
			//}else {			
				//type = "terrain";
				if (BitmapDataManager[pXml.@memo] == null) {
					loadImage();
				}else {
					displayBmp();
				}
			//}
		}
		
		private function loadImage():void {
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			serverDataGetter.loadPict(_xml.@file);
			serverDataGetter.addEventListener(Event.COMPLETE, completeImgHandler);
		}
		
		private function displayBmp():void {
			var bmp:Bitmap = new Bitmap(BitmapDataManager[_xml.@memo], "auto", true);
			addChild(bmp);
		}
		
		//-----------------------> LISTENERS <-----------------------//
		private function completeImgHandler(e:Event):void {
			ServerDataGetter(e.target).removeEventListener(Event.COMPLETE, completeImgHandler);
			//recup du loader du contentloaderinfo ayant diffusé l'evt complete, loader dans lequel se trouve l'img chargé
			var l:Loader = ServerDataGetter(e.target).loader;
			//largeur, hauteur, alpha(opacity), couleur noir
			//affectation de la var voulu (BitmapDataManager[_xml.@memo]) de la capture de l'img chargé
			//créa d'un doc virtu aux dimension de l'imh chargé, se trouvant dans le loader (ici l)
			//NOIR OBLIGATOIRE 0x000000
			BitmapDataManager[_xml.@memo] = new BitmapData(l.width, l.height, true, 0x000000);
			//impressui de l'img chargé ds le doc
			BitmapDataManager[_xml.@memo].draw(l);
			//
			displayBmp();
		}
		//-----------------------> GETTERs/SETTERs <-----------------------//
		public function get xml():XML {
			return _xml;
		}
			
			
	}
}
