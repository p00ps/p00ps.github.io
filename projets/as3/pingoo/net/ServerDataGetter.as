package classes.net 
{
	//notre RequetesManager à nous =) plateforme ou les données transitent gentillement
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import classes.Main;
	import flash.events.IOErrorEvent;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author poops
	 */
	public class ServerDataGetter extends EventDispatcher
	{
		//-----------------------> PROPRIETES <-----------------------//
		public var loader:Loader;
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function ServerDataGetter() {

		}

		//-----------------------> METHODES <-----------------------//
		public function writeBddScore(pPseudo:String):void {
			var url:URLRequest = new URLRequest(Main.BDD_SERVICES+"?action=writeScore");
			//création d'un objet contenant des variables (ici postées)
			var variables:URLVariables = new URLVariables();
			variables.score = Main.score;
			variables.pseudo = pPseudo;
			url.data = variables;
			url.method = URLRequestMethod.POST;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.load(url);	
		}
			
		public function loadScore():void {
			//requete flash pour aller chercher dans la base de donnés les scores
			var url:URLRequest = new URLRequest(Main.BDD_SERVICES+"?action=getScores");
			var urlLoader:URLLoader = new URLLoader(url);
			urlLoader.addEventListener(Event.COMPLETE, completeScoreHandler);
			//a faire et aussi changer dans param de pub les sec avant decrochage
			//si jms ca merde jai pas de retour, au bout de 15sec par défaut, permet d'ajouter qqch une popup ou autre pour lui dire de patienter ou recommencer
			//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
		}
		
		//function prenant en charge le chargement d'un xml de niveau de jeu
		public function loadXMLLEVEL():void {
			//new urlloader=newurlrequest (instanciation tout en une ligne sinon 2) afin d'atteindre et de charger l'xml du niveau visé (d'ap var static dans Main)
			var urlLoader:URLLoader = new URLLoader(new URLRequest("datas/xml/level" + Main.level + ".xml"));
			urlLoader.addEventListener(Event.COMPLETE, completeLevelHandler);
			//on colle un ec d'ev a urlloader, quand fini, on lance completeLevelHandler
		}
		
		public function loadPict(pName:String):void {
			loader = new Loader();
			//contentLoaderInfo = objet natif dans l'obj qui ressemble a un journal de bord = PHP CLI // ecouteur d'ev TOUJOURS sur le content
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completePictHandler);
			loader.load(new URLRequest("datas/images/" + pName));
		}
		
		public function loadBg():void {
			//créa d'un chargeur
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completePictHandler);
			//lien de l'img que le chargeur doit chargé
			loader.load(new URLRequest("datas/images/"+XmlManager.XMLLEVEL.config.background.@file));
		}
		
		//-----------------------> LISTENERS <-----------------------//
		private function completeHandler(e:Event):void { 
			dispatchEvent(e);
		}
		
		private function completeScoreHandler(e:Event):void {
			XmlManager.XMLSCORE = new XML(e.target.data);
			//trace(XmlManager.XMLSCORE.toXMLString());
			dispatchEvent(e);
		}
		
		private function completePictHandler(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completePictHandler);
			//propagation via dispatch de l'event complet vers le Main ou autre
			dispatchEvent(e);
		}
		
		private function completeLevelHandler(e:Event):void {
			URLLoader(e.target).removeEventListener(Event.COMPLETE, completeLevelHandler);
			//memo de la var static XMLLEVEL de l'xml du level
			XmlManager.XMLLEVEL = new XML(e.target.data);
			//e:evenement, target:obj cible qui a déclenche ici mon urlloader, data:specifie seulement les données logées dans ledit obj cible
			dispatchEvent(e);
		}
		
		
		
		//-----------------------> GETTERs/SETTERs <-----------------------//
		
		
		
		
		
		
		
		
	}

}