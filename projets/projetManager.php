<?php
switch ($_GET['nomProjet']) {
	case 'android':
		displayAndroidProjet();
		break;
	case 'php':
		displayPhpProjet();
		break;
	case 'cms':
		displayCmsProjet();
		break;
	default:
	echo '<div class="large-12 columns" role="content">
      <article>
        <h3><a href="#">PROJET MACHIN TOP SECRET</a></h3>
        <div class="row">
          <div class="large-8 columns">
            <p>Pense a faire un include pour chaque projet en peusheupeuh.</p>
            <p>et patati et pastrami</p>
          </div>
          <div class="large-4 columns">
            <img src="http://placehold.it/400x240&text=[img]" />
          </div>
        </div>
      </article>';
		break;
}

function displayAndroidProjet(){
echo'
    <div class="large-12 columns" role="content">
      <article>
        <h3>projet perso d\' application android</h3>
        <div class="row">
          <div class="large-8 columns">
            <p>top secret super difficile, arrachage de cheveux garanti pour noob</p>
            <p>et patati et pastrami</p>
          </div>
          <div class="large-4 columns">
            <img src="http://placehold.it/400x240&text=[img]" />
          </div>
        </div>
      </article>';
}

function displayPhpProjet(){
echo'
    <div class="large-12 columns" role="content">
      <article>
        <h3>Site web dynamique recensant mes recettes de cuisine franco-asiatique</h3>
        <div class="row">
          <div class="large-8 columns">
            <p>peusheupeuh.</p>
            <p>et patati et pastrami</p>
          </div>
          <div class="large-4 columns">
            <img src="http://placehold.it/400x240&text=[img]" />
          </div>
        </div>
      </article>';
}

function displayCmsProjet(){
echo'
    <div class="large-12 columns" role="content">
      <article>
        <h3>Création site marchand vente bijoux fantaisie</h3>
        <div class="row">
          <div class="large-8 columns">
            <p>les fantaisies de mon amie</p>
            <p>et patati et pastrami</p>
          </div>
          <div class="large-4 columns">
            <img src="http://placehold.it/400x240&text=[img]" />
          </div>
        </div>
      </article>';
}

?>