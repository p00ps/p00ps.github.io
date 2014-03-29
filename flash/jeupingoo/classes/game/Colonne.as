package classes.game 
{
	import flash.display.Sprite;
	import classes.net.XmlManager;
	import classes.Main;
	import flash.events.Event;
	import classes.net.MessagesManager;
	/**
	 * ...
	 * @author poops
	 */
	public class Colonne extends Sprite
	{
		//-----------------------> PROPRIETES <-----------------------//
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function Colonne() 
		{
			
		}
		
		//-----------------------> METHODES <-----------------------//
		public function createCase(pNum:int, pXml:XML):void {
			var cse:Case = new Case();
			cse.init(pNum, pXml);
			addChild(cse);
			//push rajoute une entrée dans le tableau (array dans le main)
			Main.HITTESTARRAY.push(cse);
			//trace("createCase");
		}
		
		public function init(pNum:int, pXml:XML):void {
				//positionnement de la col dans le plan //@ = attr
				x = pNum * XmlManager.XMLLEVEL.config.tile.@width;
				//créa des cases si necessaire
				for (var i:int = 0; i < pXml.children().length(); i++) {
					//on verif la pertinence de création de la case par rapport à l'existence de l'attr file ds l'xml de la case
					if (pXml.children()[i].hasOwnProperty("@file") || pXml.children()[i].hasOwnProperty("@mechant")) {
						//hasOwnProperty permet de verif l'existence d'un attr avec "@" ou d'une balise enfant
						if(pXml.children()[i].hasOwnProperty("@file")){
						var cse:Case = new Case();
						cse.init(i, pXml.children()[i]);
						addChild(cse);
						//push rajoute une entrée dans le tableau (array dans le main)
						Main.HITTESTARRAY.push(cse)
					}else {
						//écriture des infos concernant le méchant à créer à l'instant T dans la var familiale des méchants
						Mechants.xmlCase = XML(pXml.children()[i]);
						//num de col du méchant dans l'xml + num i de case du méchant dans l'xml à l'instant T
						Mechants.xmlCase.@colonne = pNum;
						Mechants.xmlCase.@caseNum = i;
						//envoie du message créer ton mechant
						dispatchEvent(new Event(MessagesManager.CREATE_MECHANT, true));						
					}
				}
			}
		}
		//-----------------------> LISTENERS <-----------------------//
		//-----------------------> GETTERs/SETTERs <-----------------------//
		
		
	}

}