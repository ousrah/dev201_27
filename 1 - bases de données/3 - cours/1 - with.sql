use vod201;


with dicaprio as 
( select id_acteur from acteurs where nom_acteur like '%caprio%'  )

select * from contenus
join jouer using(id_contenu) 
join dicaprio using(id_acteur);



with  min_vues_par_utilisateur as(
							select  sum(minute_regardee) as minutes
							from  historique
							group by id_utilisateur),
max_min_vue as (
					select max(minutes) maximum 
					from min_vues_par_utilisateur
)                            
                            
select nom_utilisateur , sum(minute_regardee) as minutes
from utilisateurs 
join historique using (id_utilisateur)
group by id_utilisateur
having sum(MINUTE_REGARDEE) = (select maximum from max_min_vue);

