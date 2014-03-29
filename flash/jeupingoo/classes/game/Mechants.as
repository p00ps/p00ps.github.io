package classes.game 
{
	import flash.display.MovieClip;
	import classes.net.XmlManager;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author poops
	 */
	public class Mechants extends MovieClip
	{
		
		//-----------------------> PROPRIETES <-----------------------//
		//zone de transfert des données xml direct des méchant au moment de la créa (cf colonnes.as)
		static public var xmlCase:XML;
		protected var _degat:int;
		//données unique du méchant protégées
		protected var _xmlCase:XML;
		//
		protected var _origineX:int;
		protected var _origineY:int;
		//
		public var life:int = 0;
		public var touchable:Boolean = true;
		
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function Mechants() 
		{
			//à l'instanciation du méchant, mémorisation en tant que données spécifique au méchant crée des données générique à la famille
			_xmlCase = xmlCase;
			gotoAndStop(1);
			
			//mise en place des méchant d'apres les données recues multiplié par les valeur du xml (largeur/hauteur)
			_origineX = x = _xmlCase.@colonne * XmlManager.XMLLEVEL.config.tile.@width;
			_origineY = y = _xmlCase.@caseNum * XmlManager.XMLLEVEL.config.tile.@height;
			
			//mise en place du nombre de vie du mechant
			if (_xmlCase.@autokill == "no") {
				life = _xmlCase.@killtouch;
			}
			//du deplacement du mechant
			if (_xmlCase.@movable == "true") {
					addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		private function enterFrameHandler(e:Event):void {
			//scale=demi tour ;) (180degres)
			var vitesse:int = scaleX * _xmlCase.@speed;
			//
			if (x > _origineX + _xmlCase.@amplitude * XmlManager.XMLLEVEL.config.tile.@width && scaleX > 0) {
				scaleX = -1;
			}
			if (x < _origineX && scaleX < 0) {
				scaleX = 1;
			}
			x += vitesse;
		}
		
		
	
		//-----------------------> METHODES <-----------------------//
		public function turnIntouchable():void {
			touchable = false;
			alpha = .5;
			var t:Timer = new Timer(1000, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
			t.start();
		}
		
		private function completeTimerHandler(e:TimerEvent):void {
			Timer(e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
			alpha = 1;
			touchable = true;
		}
		
		public function killMe():void {
			//verif si l'obj a un enterframe par un bool
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);				
			}
		}
		//-----------------------> LISTENERS <-----------------------//
		//-----------------------> GETTERs/SETTERs <-----------------------//
		public function get degat():int {
			return _degat;
		}
		
		public function get myXmlCase():XML {
			return _xmlCase;
		}
		
		
		
		
	}

}