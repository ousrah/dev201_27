


// 1.   Liste de tous les livres (type « Book ») ;
use("DBLP");
db.dblp.find({"type":"Book"})


// 2.   Liste des publications depuis 2011 ;
use("DBLP");
db.dblp.find({"year":{$gte:2011}})



// 3.   Liste des livres depuis 2014 ;
use("DBLP");
db.dblp.find({type:"Book","year":{$gte:2014}})

// 4.   Liste des publications de l’auteur « Toru Ishida » ;
use("DBLP");
db.dblp.find({authors: "Toru Ishida"})



// 5.   Liste de tous les éditeurs (type « publisher »), 
// distincts ;
use("DBLP");
db.dblp.distinct("publisher")



// 6.   Liste de tous les auteurs distincts ;
use("DBLP");
db.dblp.distinct("authors")



// 7.   Trier les publications de « Toru Ishida » par 
// titre de livre et par page de début ;
use("DBLP");
varMatch=({$match:{"authors":"Toru Ishida"}});
varSort=({$sort:{"booktitle":1,"pages.start":1}});
db.dblp.aggregate([varMatch,varSort]);



use("DBLP");
db.dblp.find({"authors":"Toru Ishida"})
.sort({"title":1,"pages.start":1})





// 8.   Projeter le résultat sur le titre de la publication,
//  et les pages ;
use("DBLP");
db.dblp.find({"authors":"Toru Ishida"},
    {"_id":0,"title":1,"pages":1})
    .sort({"title":1,"pages.start":1})


use("DBLP");
varMatch=({$match:{"authors":"Toru Ishida"}});
varSort=({$sort:{"title":1,"pages.start":1}});
varproject=({$project:{"_id":0,"title":1,"pages":1}})

db.dblp.aggregate([varMatch,varSort,varproject]);



// 9.   Compter le nombre de ses publications ;
use("DBLP");





// 10.  Compter le nombre de publications part type 
// depuis 2011 ype ;
use("DBLP");



// 11.  Donnez pour chaque type le nombre des ouvrages 
// edités depuis 2011, n’affichez que ceux qui dépassent 1000 
use("DBLP");



// 12.  Compter le nombre de publications par auteur et 
// trier le résultat par ordre croissant ;
use("DBLP");
