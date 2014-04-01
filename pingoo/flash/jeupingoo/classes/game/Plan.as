package classes.game 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author poops
	 */
	public class Plan extends Sprite
	{
		//-----------------------> PROPRIETES <-----------------------//
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function Plan() {

		}
	
		//-----------------------> METHODES <-----------------------//
		public function init(pXml:XML):void {
			//boucle sur le nb de col contenue dans l'xml du plan
				for (var i:int = 0; i < pXml.children().length(); i++) { 
					//instancie les new cols
						var colonne:Colonne = new Colonne();
						//ajoute la col dans la scene
						addChild(colonne);
						//initialise les cols en leur passant 2 params (i et l'xml de la col)
						colonne.init(i, XML(pXml.children()[i]));	
				}
				//trace("pXml dans le plan=", pXml.toXMLString());
		}
		//-----------------------> LISTENERS <-----------------------//
		//-----------------------> GETTERs/SETTERs <-----------------------//
		
	}

}