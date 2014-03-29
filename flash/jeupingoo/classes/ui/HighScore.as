package classes.ui 
{
	import classes.net.ServerDataGetter;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import classes.Main;
	import classes.net.MessagesManager;
	/**
	 * ...
	 * @author poops
	 */
	public class HighScore extends Sprite
	{
		//-----------------------> PROPRIETES <-----------------------//
		private var _score:TextField;
		private var _pseudo:TextField;
		private var _valid:SimpleButton;
		
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function HighScore() {
			_score = getChildByName("highScore") as TextField;
			_score.text = "HIGH SCORE: "+Main.score+" pts";
			_pseudo = getChildByName("pseudo") as TextField;
			_valid = getChildByName("valid") as SimpleButton;
			_valid.addEventListener(MouseEvent.CLICK, clickHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, toStageHandler);
		}

		//-----------------------> METHODES <-----------------------//
		//-----------------------> LISTENERS <-----------------------//
		
		private function clickHandler(e:MouseEvent):void {
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			serverDataGetter.writeBddScore(_pseudo.text);
			serverDataGetter.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function completeHandler(e:Event):void {
			dispatchEvent(new Event(MessagesManager.SCORE_SCREEN, true));
			parent.removeChild(this);
		}
		
		private function toStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, toStageHandler);
			x = stage.stageWidth / 2;
			y = stage.stageHeight / 2;
		}
		
		//-----------------------> GETTERs/SETTERs <-----------------------//
		
	}

}