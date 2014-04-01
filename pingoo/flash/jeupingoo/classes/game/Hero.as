package classes.game 
{
	import flash.display.Bitmap;
	import classes.net.BitmapDataManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import classes.net.XmlManager;
	import flash.events.KeyboardEvent;
	import classes.Main;
	import classes.game.Mechants;
	import classes.net.MessagesManager;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author poops
	 */
	public class Hero extends MovieClip 
	{
		//-----------------------> PROPRIETES <-----------------------//
		//deplacement g/d de 10px
		private var _stepX:int = 10;
		private var _stepY:int = 10;
		//controle du saut //max par 50 sur position initiale Y
		private var _maxSaut:int = 80;
		private var _initY:int;
		private var _saut:Boolean = false;
		//au max du saut saut
		private var _isMax:Boolean = false;
		//quand il tombe, touchable ou pas
		private var _tombe:Boolean = false;
		private var _touchable:Boolean = true;
		//bool pour avancer en meme temps qu'un saut
		private var _gauche:Boolean = false;
		private var _droite:Boolean = false;
		//pour le fond par rapport au hero/number pour pas avoir de virgule/plan du main/déplacement fond
		private var _widthPlan:Number;
		private var _plan:Sprite;
		private var _background:Sprite;
		private var _ratioBg:int = 3;
		//hittest
		private var _hitTestArray:Array;
		private var _hitTestCase:Case;
		//méchant
		public var coucheMechant:Sprite;
		//son obj son accessible via le soundchannel (espece de vpn)
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		//case collision du xml //obj deplacé bitmap //deplacable ou pas
		private var _caseCollision:Case;
		private var _objetDeplace:Bitmap = null;
		private var _deplaceXML:XML;
		//
		private var _myHeight:Number;
		private var _myWidth:Number;
		//
		
		
		//-----------------------> CONSTRUCTEURS <-----------------------//
		
		public function Hero(){
			gotoAndStop("stop");
			_myHeight = height;
			_myWidth = width;
			//créa des son rapport au geste du hero
			_soundChannel = new SoundChannel();
			_sound = new Sound();
			//
			addEventListener(Event.ADDED_TO_STAGE, toStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		//-----------------------> METHODES <-----------------------//
		private function checkMechant(obj:Mechants):void {
			if (obj is Mechants) {
				if (Mechants(obj).myXmlCase.@autokill == "no") {
					if (Mechants(obj).touchable) {
						_sound = new Sound();
						_sound.load(new URLRequest("datas/sounds/kick.mp3"));
						_soundChannel = _sound.play(0);
						Mechants(obj).turnIntouchable();
						Mechants(obj).life--;
						if (Mechants(obj).life <= 0) {
							Main.score += int(Mechants(obj).myXmlCase.@point);
							dispatchEvent(new Event(MessagesManager.UPDATE_BARRE_UI, true));
							Mechants(obj).killMe();
							coucheMechant.removeChild(obj);	
							if (coucheMechant.numChildren == 0) {
								dispatchEvent(new Event(MessagesManager.CHANGE_LEVEL, true));
								
							}
						}
					}
				} else {
					Mechants(obj).killMe();
					coucheMechant.removeChild(obj);	
				}
			}	
		}
		
		private function checkHeros():void {
			if (_touchable) {
				_touchable = false;
				Main.vies--;
				dispatchEvent(new Event(MessagesManager.UPDATE_BARRE_UI, true));
				if (Main.vies > 0) {
					var t:Timer = new Timer(1000, 1);
					t.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
					t.start();
				}else {
					//si restart game, on eleve tout les ecouteur d'evenement puis remove du hero et on dispatch le gam_over
					stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, downHandler);
					stage.removeEventListener(KeyboardEvent.KEY_UP, upHandler);
					dispatchEvent(new Event(MessagesManager.GAME_OVER, true));
					parent.removeChild(this);
				}
			}
		}
		
		private function completeTimerHandler(e:TimerEvent):void 
		{
			Timer(e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
			_touchable = true;
		}

		private function checkHitTest(pSens:String):Boolean {
			var i:int;
			var obj:DisplayObject;
			var cse:Case;
			
			switch(pSens) {
				case "haut":
					//toujours décrémenté quand on remove qqch dans une boucle for, sinon boucle while c'est mieux
					for (i = coucheMechant.numChildren-1; i >= 0; i--) {
						obj = coucheMechant.getChildAt(i) as DisplayObject;
						if (obj.hitTestPoint(x, y - _myHeight +1) == true) { 
							if (obj is Mechants) {
								//checkMechant(Mechants(obj));
								Main.vies--;
								dispatchEvent(new Event(MessagesManager.UPDATE_BARRE_UI, true));
							}
							return true;
						}
					}
					
					for (i = 0; i < _hitTestArray.length; i++) {
						cse = _hitTestArray[i] as Case;
						if (cse.hitTestPoint(x, y - _myHeight +1) == true) {
							_caseCollision = cse;
							return true;
							break;
						}
					}
					
					break;
				case "bas":
					for (i = coucheMechant.numChildren-1; i >= 0; i--) {
						obj = coucheMechant.getChildAt(i) as DisplayObject;
						if (obj.hitTestPoint(x, y) == true) { 
							if (obj is Mechants) {
								//ternaire; if tombe, alors check mechant, sinon check hero
								// ? : ;
								if (_tombe) { 
									_touchable = false;
									var t:Timer = new Timer(1000, 1);
									t.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
									t.start();
									checkMechant(Mechants(obj));
								} else { 
									checkHeros();
								}
							}
							return true;
						}
					}
					
					for (i = 0; i < _hitTestArray.length; i++) {
						cse = _hitTestArray[i] as Case;
						if (cse.hitTestPoint(x, y) == true) {
							_caseCollision = cse;
							return true;
						}
					}
					
					break;
				case "gauche":
					for (i = coucheMechant.numChildren-1; i >= 0; i--) {
					obj = coucheMechant.getChildAt(i) as DisplayObject;
					if (obj.hitTestPoint(x - (_myWidth / 2), y - 1) == true && obj.hitTestPoint(x - (width / 2), y - _myHeight + 10) == true) { 
						if (obj is Mechants) {
								//checkMechant(Mechants(obj));
							}
						return true;
						}
					}
					
					for (i = 0; i < _hitTestArray.length; i++) {
						cse = _hitTestArray[i] as Case;
						if (cse.hitTestPoint(x - (width / 2), y - 1) == true) {
							_caseCollision = cse;
							return true;
						}
					}
					
					break;
				case "droite":
					for (i = coucheMechant.numChildren - 1; i >= 0; i--) {
					obj = coucheMechant.getChildAt(i) as DisplayObject;
					if (obj.hitTestPoint(x + (width / 2), y - 1) == true || obj.hitTestPoint(x + (width / 2), y - _myHeight + 10) == true) { 
						if (obj is Mechants) {
								//checkMechant(Mechants(obj));
							}
						return true; 
						}
					}
					
					for (i = 0; i < _hitTestArray.length; i++) {
						cse = _hitTestArray[i] as Case;
						if (cse.hitTestPoint(x + (width / 2), y - 1) == true) {
							_caseCollision = cse;
							return true;
						}
					}
					break;
			}
			return false;
		}
		
		
		//-----------------------> LISTENERS <-----------------------//		
		
		private function removeFromStageHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, downHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, upHandler);
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
				
		private function toStageHandler(e:Event):void {
			_plan = Main.COUCHEPLAN;
			_background = Main.COUCHEBG;
			//pointeur, comme une static, modif mirroir sur tout les tableaux ex: _hitTestArray ici est égal au meme HITTESTARRAY du main
			_hitTestArray = Main.HITTESTARRAY;
			removeEventListener(Event.ADDED_TO_STAGE, toStageHandler);
			x = 100;
			y = stage.stageHeight - (XmlManager.XMLLEVEL.config.tile.@height);
			//
			_widthPlan = XmlManager.XMLLEVEL.config.tile.@width * (XmlManager.XMLLEVEL.plan.colonne.length()/XmlManager.XMLLEVEL.plan.length());
						
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, upHandler);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		//function du saut avec action a chaque image seconde (enterframe, 24img/s = 24 actions)
		private function enterFrameHandler(e:Event):void {
			if (_saut == true) {
				if (y > _initY - _maxSaut && _isMax==false && checkHitTest("haut")==false) {
					y -= _stepY;
				}else {
					_isMax = true;
					y += _stepY;
					_tombe = true;
						if (checkHitTest("bas") == true) {
							_saut = false;
							_tombe = false;
							if (_gauche == true || _droite == true) {
								gotoAndStop("marche");
							}else {
								gotoAndStop("stop");
							}						
						}
					}
						
				}else if (checkHitTest("bas") == false) {
					y += _stepY;
					_saut = true;
					_isMax = true;
			}

			//pour tuer le héro dès qu'il sort de la scene + la taille d'une case
			//remove de l'enterframe, du haut/bas
			//dispatch de l'event game_over, et remove du perso lui meme
			// trace(y +" ==== "+ (int(XmlManager.xmlLevel.config.tile.@height)+ int(stage.stageHeight)));
			if (y == int(XmlManager.XMLLEVEL.config.tile.@height)+ int(stage.stageHeight)) {
				stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, downHandler);
				stage.removeEventListener(KeyboardEvent.KEY_UP, upHandler);
				
				dispatchEvent(new Event(MessagesManager.GAME_OVER, true));
				parent.removeChild(this);
			}

			//si il va a gauche
			if (_gauche == true) {
				if(checkHitTest("gauche")==false){
					if(x <= (stage.stageWidth/2) && _plan.x < 0){
						_plan.x += _stepX;
						_background.x += (_stepX) / _ratioBg;
					}else {
						if (x - _stepX - (_myWidth / 2) > 0) {
							x -= _stepX;
						}
					}
				}
			}
			
			//si il va a droite
			if (_droite == true) {
				if(checkHitTest("droite")==false){
					if (x >= (stage.stageWidth / 2) && _plan.x > stage.stageWidth - _plan.width) {
						_plan.x -= _stepX;
						_background.x -= (_stepX) / _ratioBg;
					}else{
						if(x+_stepX+(_myWidth/2)<stage.stage.stageWidth){
							x += _stepX;
						}
					}
				}	
			}
			
			//si il bouge pas, si toute action est a false
			if (_gauche == false && _droite == false && _saut == false) {
				gotoAndStop("stop");
			}
		}
		
		private function upHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
					//fleche gauche
					case 37:
						_gauche = false;
						break;
					//fleche droite
					case 39:
						_droite = false;
						break;
			}
		}
		
		private function downHandler(e:KeyboardEvent):void {
			switch(e.keyCode) {
				//D
				case 68:
					if(_objetDeplace==null){
						if (_caseCollision.xml.@deplacable == "true") {
							var type:String = _caseCollision.xml.@memo;
							//copy de la case pour pas toucher a l'original
							_deplaceXML = _caseCollision.xml.copy();
							//couper l'array(a l'indexOf de _caseCollision du tableau, 1 donnée) //2 pour deux
							_hitTestArray.splice(_hitTestArray.indexOf(_caseCollision), 1);
							_caseCollision.parent.removeChild(_caseCollision);
							_objetDeplace = new Bitmap(BitmapDataManager[_caseCollision.xml.@memo]);
							_objetDeplace.scaleX = .5;
							_objetDeplace.scaleY = .5;
							_objetDeplace.y = -_myHeight / 2;
							addChild(_objetDeplace);
						}
					} else {
						//par coordonnées du héro en x et sens du héro
						//analyse de la colonne dans laquelle recréer la case
						//a l'aide de l'xml préalablement mémorisé
						var ptPlan:Point = new Point(_plan.x, _plan.y);
						var ptHeros:Point = new Point(x, _plan.y);
						var distance:Number = Point.distance(ptPlan, ptHeros);
						//
						var numColonne:int = distance / XmlManager.XMLLEVEL.config.tile.@width;
						var numObj:int = _plan.numChildren - 1;
						//
						var plan:Plan;
						while (numObj > 0) {
							var obj:DisplayObject = _plan.getChildAt(numObj) as DisplayObject;
							if (obj is Plan) {
								plan = obj as Plan;
								break;
							}
							numObj--;
						}
						var colonne:Colonne = plan.getChildAt(numColonne) as Colonne;
						numColonne += scaleX;
						//calcul de la position verticale de la case
						var verticalePos:int = int((y - XmlManager.XMLLEVEL.config.tile.@height) / XmlManager.XMLLEVEL.config.tile.@height);
						colonne.createCase(verticalePos, _deplaceXML);
						removeChild(_objetDeplace);
						_objetDeplace = null;
					}
					//trace("_caseCollision.xml=", _caseCollision.xml.toXMLString());
					break;
					//fleche gauche
				case 37:
					gotoAndStop("marche");
					scaleX = -1;
					_gauche = true;
				break;
				//fleche droite
				case 39:
					gotoAndStop("marche");
					scaleX = 1;
					_droite = true;
				break;
				//espace+haut
				case 32:
				case 38:
					gotoAndStop("saute");
					if (_saut == false) {
						//ecouteur activé uniquement quand on saute (remov dans uphandler)
						_saut = true;
						_initY = y;
						_isMax = false;
						_sound = new Sound();
						_sound.load(new URLRequest("datas/sounds/saut.mp3"));
						_soundChannel = _sound.play(0);
					}
				break;
			}
			if (_objetDeplace != null) addChild(_objetDeplace);
		}
		

		//-----------------------> GETTERs/SETTERs <-----------------------//
		
		
	}

}