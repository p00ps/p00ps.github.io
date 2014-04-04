package classes 
{
	//import de classe, console, etc
	import classes.game.Background;
	import classes.game.Citrouille;
	import classes.game.Ghost;
	import classes.game.Hero;
	import classes.game.Mechants;
	import classes.game.Plan;
	import classes.net.ServerDataGetter;
	import classes.ui.BarreUi;
	import classes.ui.GameOver;
	import classes.ui.HighScore;
	import classes.ui.OpenScreen;
	import flash.display.Sprite;
	import flash.events.Event;
	import classes.net.XmlManager;
	import classes.net.MessagesManager;
	import flash.events.IMEEvent;
	import flash.events.TransformGestureEvent;
	//full screen, interactive, normal
	import flash.display.StageScaleMode;
	//comment l'grandissement se fera, avec ou sans distorsion etc
	import flash.display.StageDisplayState;
	//
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	
	/**
	 * ...
	 * @author poops
	 */
	public class Main extends Sprite 
	{
		//Main = class principale/centrale //static et const en MAJ
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> PROPRIETES <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		//déclaration du niveau par défaut
		static public var level:int = 0;
		static public var vies:int = 3;
		static public var score:int = 0;
		//
		static public const BDD_SERVICES:String = "http://localhost/jeu/jeu-service.php";
		//
		//static = si on déclare static, si on modif qqch, toute les classe découlant de cet obj changera
		static public var COUCHEPLAN:Sprite;
		static public var COUCHEBG:Sprite;
		static public var HITTESTARRAY:Array;
		//private/protected = _ d'abord // constante en MAJ
		//declaration des sprites contenant les diff couche du jeu (interface, jeu, etc)
		private var _gameElements:Sprite = null;
		private var _uiElements:Sprite = null;
		//
		private var _persosElements:Sprite = null;
		private var _mechantElements:Sprite;
		//
		private var _barreUi:BarreUi = null;
		//
		private var _globalSprite:Sprite;
		//plan container
		private var _planContainer:Sprite;
		//
		private var _hero:Hero;
		//
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> CONSTRUCTEURS <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		public function Main() {
			_globalSprite = new Sprite();
			addChild(_globalSprite);
			//init des ecouteur spé au jeu
			initListeners();
			//chargement des données du level //ctrl+shift+1& = generate function
			loadLevelData();
			//mise en place de la couche de l'interface
			_uiElements = new Sprite();
			addChild(_uiElements);
			
		}
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> METHODES <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		private function initListeners():void {
			//tjs finir par handler les function des eventlistener
			addEventListener(Event.ADDED_TO_STAGE, toStageHandler);
			addEventListener(MessagesManager.START_GAME, startGameHandler);
			addEventListener(MessagesManager.CREATE_MECHANT, createMechantHandler);
			addEventListener(MessagesManager.UPDATE_BARRE_UI, updateBarreHandler);
			addEventListener(MessagesManager.CHANGE_LEVEL, changeLevelHandler);
			addEventListener(MessagesManager.RESTART_GAME, restartGameHandler);
			addEventListener(MessagesManager.GAME_OVER, gameOverHandler);
			addEventListener(MessagesManager.SCORE_SCREEN, scoreScreenHandler);
		}
		
		private function gameOverHandler(e:Event):void 
		{
			//chargement des scores
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			serverDataGetter.addEventListener(Event.COMPLETE, completeScoreHandler);
			serverDataGetter.loadScore();
		}
		
		private function completeScoreHandler(e:Event):void 
		{
			var numScoreSup:int = 0;
			//pour chaque ligne dans var (s) nommé "score" dans mon xmlscore  
			for each(var s:XML in XmlManager.XMLSCORE.score) {
				//static=attention forcé flash a aller chercher la static en précisant la class MAin.score
				if (int(s.@value) > Main.score) numScoreSup++;
			}
			//
			if (numScoreSup < 3) {
				var popScore:HighScore = new HighScore();
				_uiElements.addChild(popScore);	
			}else {
				scoreScreenHandler(null);
			}
		}
		
		private function restartGameHandler(e:Event):void { 
			//reset des var vitales du jeu
			vies = 3;
			level = 0; 
			score = 0;
			//_barreUi.update();
			//chargement du xml du level0 dans un contexte de rejouer et pas de new game
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			serverDataGetter.addEventListener(Event.COMPLETE, completeRestartLevelHandler);
			serverDataGetter.loadXMLLEVEL();
		}
		
		private function changeLevelHandler(e:Event):void 
		{
			level++;
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			serverDataGetter.addEventListener(Event.COMPLETE, completeLevelHandler);
			serverDataGetter.loadXMLLEVEL();
		}
		
		private function updateBarreHandler(e:Event):void 
		{ // update de la barre des qu'on perd une vie etc, pour eviter de le faire un par un on stock tout dans une barre qui s'update
			removeEventListener(Event.ADDED_TO_STAGE, updateBarreHandler);
			_barreUi.update();
		}
		
		
		private function toStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, toStageHandler);
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			//
			var masque:Sprite = new Sprite();
			//remplissage de couleur en graphic
			masque.graphics.beginFill(0xff0000, 1);
			masque.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			addChild(masque);
			//.mask qui est une propriété de la class sprite
			_globalSprite.mask = masque;
		}
				
		
		private function loadLevelData():void {
		//void = ne renvoit rien
			//instanciation d'un obj de chargement
			var serverDataGetter:ServerDataGetter = new ServerDataGetter();
			//declaration de la methode public permettant de charger la map du jeu en xml
			serverDataGetter.loadXMLLEVEL();
			//ajout d'un ecouteur afin de poursuivre l'exe du prog fini
			serverDataGetter.addEventListener(Event.COMPLETE, completeLevelHandler);
		}
		
		
		//function qui permet de construire les obj physique de mon level
		private function buildLevel():void {
			//verif de l'existence d'un niveau de jeu a l'écran
			if (_gameElements != null) {
					//on suppr le sprite contenant les elements du jeu
					_globalSprite.removeChild(_gameElements);
					//on declare a null le sprite
					_gameElements = null;
			}
			
			//instanciation du container des elements du jeu
			_gameElements = new Sprite();
			//ajout du sprite dans la scene du Main en premier (At à quel profondeur)
			_globalSprite.addChildAt(_gameElements, 0);
			
			//instanciation du fond
			var background:Background = new Background();
			_gameElements.addChild(background);
			COUCHEBG = background;
			_mechantElements = new Sprite;
			//instanciation et ajout des plans dans le sprite
			_planContainer = new Sprite;
			_gameElements.addChild(_planContainer);
			//
			HITTESTARRAY = new Array;
			for each(var p:XML in XmlManager.XMLLEVEL.plan) {
				//instanciation des plans issu de l'xml du level
				var plan:Plan = new Plan();
				//ajout du plan ds le sprite de la couche du jeu
				_planContainer.addChild(plan);
				//init des plan en leur passant la balise "plan" leur correspondant
				plan.init(p);
			}
			_planContainer.addChild(_mechantElements);
			COUCHEPLAN = _planContainer;
			//
			_sound = new Sound();
			_sound.load(new URLRequest("datas/sounds/ambiance.mp3"));
			_soundChannel = _sound.play(0);
		}
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> LISTENERS <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		private function scoreScreenHandler(e:Event):void 
		{
			//mise en place de l'écran de fin
			var gameOverScreen:GameOver = new GameOver();
			_uiElements.addChild(gameOverScreen);	
		}
		
		//toujours un parametre dans les function de type handler de type event
		private function completeLevelHandler(e:Event):void {
			ServerDataGetter(e.target).removeEventListener(Event.COMPLETE, completeLevelHandler);
			//appel a la function de construction de level
			buildLevel();
			//trace("xml=", XmlManager.XMLLEVEL.toXMLString()); //toXMLString = force a etre en chaine de char
			//ajout de la barre ui si le level est 0
			if(level==0){
				if (_barreUi != null) {
					_uiElements.removeChild(_barreUi);
					_barreUi = null;
				}
				_barreUi = new BarreUi();
				_uiElements.addChild(_barreUi);
				//ajout d'ecran de demarrage du level
				var openScreen:OpenScreen = new OpenScreen();
				_uiElements.addChild(openScreen);
			}else {
					createHero();
					_barreUi.update();
			}
		}

		
			private function completeRestartLevelHandler(e:Event):void 
		{
			ServerDataGetter(e.target).removeEventListener(Event.COMPLETE, completeLevelHandler);
			buildLevel();
			createHero();
			_barreUi.update();
		}
		
		private function createHero():void {
			//if (_persosElements != null) {
				//_gameElements.removeChild(_persosElements);
				//_persosElements = null;
			//}
			_persosElements = new Sprite();
			//_gameElements.addChildAt(_persosElements, _gameElements.numChildren -1);
			_gameElements.addChild(_persosElements);
			//
			_hero = new Hero();
			//pont permettant au hero d'aller voir les méchantélement dans la couche méchant
			_hero.coucheMechant = _mechantElements;
			_persosElements.addChild(_hero);
			//ajout d'un focus pour pas avoir a clicker apres le start game
			stage.focus = this;
		}
		
		
		private function startGameHandler(e:Event):void {
			//je range mes méchant dans ma couche méchant
			createHero();
			//ajout du focus afin de ne pas avoir a clicker pour rendre le jeu actif
			stage.focus = this;
		}
		
		
		private function createMechantHandler(e:Event):void {
			//class parente
			var mechant:Mechants;
			//pour créer des méchant découlant de class enfant
			if (Mechants.xmlCase.@mechant == "ghost") { mechant = new Ghost(); }
			if (Mechants.xmlCase.@mechant == "citrouille") { mechant = new Citrouille(); }
			_mechantElements.addChild(mechant);
		}
		
		////////////////////////////////////////////////////////////////
		//
		//-----------------------> GETTERs/SETTERs <-----------------------//
		//
		////////////////////////////////////////////////////////////////
		
		
		
		
		
		
		
	}

}