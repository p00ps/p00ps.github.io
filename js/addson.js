$(document).ready(function(){    
	var a = $('#thumbnails').children();
	a.click(function(){
		//alert($(this).index());
		filtre($(this).index());
	})
	filtre(0);
	repositionScroll();
});

//------------------------------------------------------> repositionnement des ancres

function repositionScroll(){

	$('.side-nav li').find('a').on('click', function(evt){
       // bloquer le comportement par défaut: on ne rechargera pas la page
       evt.preventDefault(); 
       // enregistre la valeur de l'attribut  href dans la variable target
	var target = $(this).attr('href');
       // le sélecteur $(html, body) permet de corriger un bug sur chrome et safari (webkit)
	$('html, body')
       // on arrête toutes les animations en cours 
       .stop()
       // on fait maintenant l'animation vers le haut (scrollTop) vers notre ancre target
       .animate({scrollTop: $(target).offset().top}, 1000 );
    });

/*
	$('.scrollverstop').click(function(e){
		e.preventDefault();
		$('html, body').stop().animate({scrollTop: 0}, 'fast');
	}); 
*/

	$('#contConn article').find('a').on('click', function(evt){
       evt.preventDefault(); 
		var target =  $(this).attr('href');
		$('html, body').stop().animate({scrollTop: $(target).offset().top}, 1000 );
    });

}

//------------------------------------------------------> filtre projet
function filtre(pId){
	var article = $("#filtreconteneur").find("article");
	article.eq(pId).stop().fadeIn(2000);
	article.css('display','none');
	article.eq(pId).css('display','block');
}


