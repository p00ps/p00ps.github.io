package classes.ui 
{
	//simpleButton deja sécu lier au bouton
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import classes.net.MessagesManager;
	/**
	 * ...
	 * @author poops
	 */
	public class GameOver extends Sprite
	{
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> PROPRIETES <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		private var _texte:TextField;
		private var _btRejouer:SimpleButton;
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> CONSTRUCTEURS <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		public function GameOver() 
		{
			addEventListener(Event.ADDED_TO_STAGE, gameOverHandler);
		}
		
		private function gameOverHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE,restartGameHandler);
			x = stage.stageWidth * 0.5;
			y = stage.stageHeight * 0.5;
			//import du bouton + mise en place du text
			_texte = getChildByName("texte") as TextField;
			var tf:TextFormat = new TextFormat();
			tf.align = "center";
			_texte.setTextFormat(tf);
			//import du bt + mise en place du bouton par un click
			_btRejouer = getChildByName("bt_rejouer") as SimpleButton;
			_btRejouer.addEventListener(MouseEvent.CLICK, restartGameHandler);
		}
		
		private function restartGameHandler(e:MouseEvent):void 
		{
			dispatchEvent(new Event(MessagesManager.RESTART_GAME, true));
			parent.removeChild(this);
		}
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> METHODES <-----------------------//
		//
		////////////////////////////////////////////////////////////////

		////////////////////////////////////////////////////////////////
		//
		//-----------------------> LISTENERS <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> GETTERs/SETTERs <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
	}

}