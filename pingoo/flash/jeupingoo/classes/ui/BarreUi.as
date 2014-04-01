package classes.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import classes.Main;
	import flash.system.System;
	/**
	 * ...
	 * @author poops
	 */
	public class BarreUi extends Sprite
	{
		
		//-----------------------> PROPRIETES <-----------------------//
		private var _temps:TextField;
		private var _score:TextField;
		private var _vies:MovieClip;
		private var _level:TextField;
		private var _quitter:Sprite;
		
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function BarreUi() {
			x = 10;
			y = 10;
			_temps = getChildByName("timer_txt") as TextField;
			//
			_score = getChildByName("score_txt") as TextField;
			_score.text = String(Main.score);
			//
			_vies = getChildByName("vies") as MovieClip;
			_vies.gotoAndStop(Main.vies + 1);
			//
			_level = getChildByName("level_txt") as TextField;
			_level.text = "Level " + (Main.level + 1);
			//
			_quitter = getChildByName("exit") as Sprite;
			//buttonMode=true: cursor en forme de main
			_quitter.buttonMode = true;
			_quitter.mouseChildren = false;
			_quitter.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function update():void {
			_score.text = String(Main.score);
			_vies.gotoAndStop(Main.vies + 1);
			_level.text = "Level " + (Main.level + 1);
		}
		
		//-----------------------> METHODES <-----------------------//
		//-----------------------> LISTENERS <-----------------------//
		private function clickHandler(e:MouseEvent):void {
			System.exit(0);
		}
		
		
		//-----------------------> GETTERs/SETTERs <-----------------------//
		
		
		
		
		
	}

}