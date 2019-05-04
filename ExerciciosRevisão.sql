-- PREENCHA O CABEÇALHO --
-- Nome: Micael Barreto de Moraes
-- Turma: Ciência da Computação 3ªFase
-- Data: 05/03/2018
-- OBS -> Ao enviar o nome do arquivo .sql deve ser alterado para o seu NOME. 
 

use jogos;


-- Insira dois novos registros na tabela de aluno;


-- Insira dois novos cenários na tabela Cenario; 


-- Insira um novo monstro e relacione este novo mostro com um novo cenario criado por você (temmonstro)


-- Adicione o nome da rua para a aluna Manuela


-- Insira um volume de 20 para a arma "Sniper"


-- Agora exclua o primeiro aluno adicionado por você, no primeiro exercício. 


-- Exclua também o cenário que você adicionou mas que não foi relacionado com nenhum monstro. 


-- ***************************
--       CONSULTAS
-- ***************************


-- 1 - Liste quais são os alunos que mataram monstros; (ESTA)
	select aluno.nome from aluno join jogador on (aluno.idAluno = jogador.idAluno)
    join Killmonstro on (jogador.idJogador = Killmonstro.idMonstro)
    order by aluno.nome;

-- 2 - Liste quais são os alunos que não são jogadores. (ESTA)
	select aluno.nome from aluno
    where aluno.idAluno not in (select idAluno from jogador);

-- 3 - Liste os alunos que já usaram a arma 'Shotgun' (ESTA)
	SELECT aluno.nome from aluno
    join jogador on (aluno.idaluno = jogador.idAluno)
    join temArma on (jogador.idJogador = temArma.idJogador)
    join arma on (temArma.idArma = arma.idArma)
    where arma.nome like 'Shotgun';

-- 4 - Faça um select que retorna as munições que são utilizadas pelos jogadores(nome) que fazem mais ou igual a 39 PV de danos e tem peso menor de 60g (ordene-as por peso)
	select aluno.nome, danos from municao
    join temmunicao on (municao.idMunicao = temmunicao.idMunicao)
    join jogador on (jogador.idJogador = temmunicao.idJogador)
    join aluno on (aluno.idAluno = jogador.idAluno)
    where municao.danos >= 39 and municao.peso <60;

-- 5 - Faça um select que retorne qual são os monstros que nunca foram mortos.
	select nome from monstro
    where monstro.idMonstro not in (select idMonstro from killmonstro);

-- 6 - Liste quais os alunos que já foram mortos pelo menos uma vez.  
	select nome from aluno
    join jogador on (aluno.idAluno = jogador.idAluno)
    where jogador.idJogador in (select jogMorto from killJogador);

-- 7 - Qual o nome dos jogadores que mataram a eles próprios?
	select nome from aluno
    join jogador on (aluno.idAluno = jogador.idAluno)
    join killJogador on (jogador.idJogador = killjogador.jogMorto)
    where killJogador.jogMorto = killJogador.jogMatador;

-- 8 - Faça um select que retorne quais são jogadores que pertencem a uma equipe, mas não entram num round de equipe ('CatchTheFlag' ou 'TeamDeathMatch'). (ESTA)
	select aluno.nome from aluno
    join jogador on (aluno.idAluno = jogador.idAluno)
    join equipe on (jogador.idEquipe = equipe.idequipe)
    join partida on (jogador.idPartida = partida.idPartida)
    where partida.tipo not in ('CatchTheFlag', 'TeamDeathMatch');

-- 9 - Qual cenário não possui nenhum monstro?
	select nome from cenario
    where cenario.idcenario not in (select idcenario from temMonstro) ;

-- 10 - Qual o monstro que não foi morto e a qual cenário ele pertencia? (ESTA)
	select monstro.nome as Mostro, cenario.nome as Cenario from monstro
    join temmonstro on (monstro.idMonstro = temmonstro.idMonstro)
    join cenario on (cenario.idcenario = temmonstro.idcenario)
    where monstro.idMonstro  not in (select idmonstro from killmonstro);

-- 11 - Qual o nome do jogador que matou mais monstros (ESTA)
	select count(*) qtdMonstrosMortos, max(aluno.nome) from killmonstro
    join jogador on (killmonstro.idJogador = jogador.idJogador)
    join aluno on (jogador.idAluno = aluno.idAluno)
    group by jogador.idJogador
    order by qtdMonstrosMortos desc
    limit 1;

-- 12 - Qual foi o cenário que tem a maior quantidade de morte de monstros? 
	select count(*) qtdMonstrosMortos, max(cenario.nome) from cenario
    join temMonstro on (cenario.idCenario = temMonstro.idCenario)
    join Monstro on (temMonstro.idMonstro = monstro.idMonstro)
    join killmonstro on (monstro.idmonstro = killmonstro.idMonstro)
    order by qtdMonstrosMortos desc
    limit 1;
    
-- 13 - Quais os jogadores que mataram monstros que não pertencem ao cenário do seu round? 
	
                 
-- 14 - Faça um select que apresente os alunos que mataram UM monstro em todas partidas que participaram?  -- DICA USAR HAVING 
	select count(*) qtdMonstrosMortos, aluno.nome from killmonstro
    join jogador on (killmonstro.idJogador = jogador.idJogador)
    join aluno on (jogador.idAluno = aluno.idAluno)
    group by aluno.nome
    having count(*)=1; 

