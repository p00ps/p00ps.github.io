package classes.ui 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import classes.Main;
	import flash.text.TextFormat;
	import classes.net.MessagesManager;
	/**
	 * ...
	 * @author poops
	 */
	public class OpenScreen extends Sprite
	{
		//-----------------------> PROPRIETES <-----------------------//
		private var _texte:TextField;
		private var _bt:SimpleButton;
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function OpenScreen() 
		{
			addEventListener(Event.ADDED_TO_STAGE, toStageHandler);
		}
		
		//-----------------------> METHODES <-----------------------//
		//-----------------------> LISTENERS <-----------------------//
		
		private function toStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, toStageHandler);
			x = stage.stageWidth * 0.5;
			y = stage.stageHeight * 0.5;
			//mise en place du texte
			_texte = getChildByName("texte") as TextField;
			_texte.text = "LEVEL " + (Main.level +1);
			var tf:TextFormat = new TextFormat();
			tf.align = "center";
			_texte.setTextFormat(tf);
			//mise en marche du bouton
			_bt = getChildByName("bt_jouer") as SimpleButton;
			_bt.addEventListener(MouseEvent.CLICK, clickHandler);			
		}
		
		private function clickHandler(e:MouseEvent):void {
			//true bubble remonte // false (par defaut) bubble descend dans l'arborescence
			dispatchEvent(new Event(MessagesManager.START_GAME, true));
			parent.removeChild(this);
		}
		

		//-----------------------> GETTERs/SETTERs <-----------------------//
		
		
	}

}