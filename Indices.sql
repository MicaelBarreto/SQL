-- Micael Barreto de Moraes // 19/03/2018 // Ciência da Computação 3ªFase
-- Indices

use locadora;

drop index idx_id_pais on pais;
drop index idx_id_linguagem on linguagem;

create index idx_id_pais on pais(pais(20));

create index idx_id_linguagem on linguagem(name(5));

select * from pais use index(idx_id_pais);
select * from linguagem use index(idx_id_linguagem);
