$(document).ready(function(){    

	var a = $('#thumbnails').children();
	a.click(function(){
		//alert($(this).index());
		filtre($(this).index());
	})

	filtre(0);



});


function filtre(pId){
	var article = $("#filtreconteneur").find("article");
	article.css('display','none');
	article.eq(pId).css('display','block');

}