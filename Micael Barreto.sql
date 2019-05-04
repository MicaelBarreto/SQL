-- PREENCHA O CABEÇALHO --
-- Nome: Micael Barreto de Moraes
-- Turma: Ciência da Computação 3º Semestre
-- Data: 12/03/2018
-- OBS -> Ao enviar o nome do arquivo .sql deve ser alterado para o seu NOME. 
 
-- EXERCÍCIO 2 --

-- execute este comando;
use jogos;


-- 1 - Faça um select que apresente a arma que possui maior danos. 
	select nome, danos from arma
    order by danos desc
    limit 2;

-- 2 - Crie uma view que retorne o monstro que possui maior enegia para cada cenário. (ESTA)
	-- Exemplo de como chamar a view: select * from nomeView;

CREATE VIEW energiaMonstroPorCenario AS
	SELECT max(energia) AS energia,
		   cenario.nome AS cenario,
		   monstro.nome AS monstro
	FROM monstro
	JOIN temmonstro ON (monstro.idMonstro = temmonstro.idMonstro)
	JOIN cenario ON (temmonstro.idCenario = cenario.idCenario)
	GROUP BY cenario.idCenario;

-- chamar a view 
select * from energiaMonstroPorCenario;	
	

-- 3 - Crie uma view que retorne os alunos com a respectiva quantidade de mortes de monstros efetuadas.
	drop view if exists matarmonstros;
    
    create view matarmonstros as
		select aluno.nome, count(*) as qtd from killmonstro
        join jogador on (jogador.idJogador = killmonstro.idJogador)
        join aluno on (aluno.idAluno = jogador.idAluno)
        group by killmonstro.idJogador
        order by count(*) desc;
        select * from matarmonstros;

-- 4 - Com base na view criada anteriormente, faça um select que apresente quais são os alunos que possuem número de mortes de mostros acima  da média.
	select nome,qtd from matarmonstros
    where qtd > (select AVG(qtd) from matarmonstros);
-- 5 - Crie uma view que retorne todos os alunos em cada morte efetuada, sendo eles monstros ou outro jogador.  (ESTA)
-- Dica necessário utilizar o operador Union

create view alunosEobjMorreu AS 
SELECT aluno.nome AS Aluno,
       monstro.nome AS objMorreu
FROM aluno
JOIN jogador ON (aluno.idAluno = jogador.idAluno)
JOIN killmonstro ON (jogador.idJogador = killmonstro.idJogador)
JOIN monstro ON (killmonstro.idMonstro = monstro.idMonstro)
UNION  ALL
SELECT aluno.nome AS Aluno,
       alunoJogMorto.nome AS objMorreu
FROM aluno
JOIN jogador ON (aluno.idAluno = jogador.idAluno)
JOIN killjogador ON (jogador.idJogador = killjogador.jogMatador)
JOIN jogador AS jogMorto ON (killjogador.jogMorto = jogMorto.idJogador)
JOIN aluno AS alunoJogMorto ON (jogMorto.idAluno = alunoJogMorto.idAluno);

SELECT * FROM alunosEobjMorreu;

-- 6 - Faça um select que retorne os alunos por número de participações em partida. Ordernar do mais participativo para o menos participativo. 
	
    select nome, count(*) participacao from aluno
    join jogador on (aluno.idAluno = jogador.idAluno)
    join partida on (partida.idPartida = jogador.idPartida)
    group by aluno.nome
    order by participacao desc;
    
-- 8 - Crie uma procedure que liste o nome do jogador que foram mortos pelo jogador que será passado como parâmetro (identificador) (ESTA)
	-- utilize como parametro os alunos '030316002' e '030310001'. 
    -- Exemplo de como chamar a procedure: CALL nomeProcedure(parametro);
    drop procedure if exists pListaJogadoresMortos;
	
DELIMITER $$
CREATE PROCEDURE pListaJogadoresMortos(IN pIdJogador integer)
BEGIN
	SELECT alunoJogMorto.nome as JogMorto
	FROM aluno alunoJogMorto
	JOIN jogador AS jogMorto ON (alunoJogMorto.idAluno = jogMorto.idAluno)
	JOIN killJogador ON (jogMorto.idJogador = killjogador.jogMorto)
	JOIN jogador AS jogMat ON (jogMat.idJogador = killJogador.jogMatador)
	JOIN aluno AS alunoJogMat ON (alunoJogMat.idAluno = jogMat.idAluno)
	WHERE alunoJogMat.idAluno = pIdJogador;    
END $$
DELIMITER ; 

CALL pListaJogadoresMortos(030316002);
CALL pListaJogadoresMortos(030310001);   
 
-- 9 - Agora altere a procedure do exercício anterior, para que ela receba um segundo parâmetro, que será o nome do aluno. 
--     A procedure deve verificar se o idJogador foi preenchido. Caso não esteja preenchido, deve filtrar pelo segundo parâmetro que será o nome do aluno.
	-- utilize "Rui Morongo" como parâmetro.   
    drop procedure if exists pListaJogadoresMortos;
  
  DELIMITER $$
CREATE PROCEDURE pListaJogadoresMortos(IN pIdJogador integer, in pNomeJogador varchar(60))
BEGIN
	if (pIdJogador != null) then
	SELECT alunoJogMorto.nome as JogMorto
	FROM aluno alunoJogMorto
	JOIN jogador AS jogMorto ON (alunoJogMorto.idAluno = jogMorto.idAluno)
	JOIN killJogador ON (jogMorto.idJogador = killjogador.jogMorto)
	JOIN jogador AS jogMat ON (jogMat.idJogador = killJogador.jogMatador)
	JOIN aluno AS alunoJogMat ON (alunoJogMat.idAluno = jogMat.idAluno)
	WHERE alunoJogMat.idAluno = pIdJogador;
	else SELECT alunoJogMorto.nome as JogMorto
	FROM aluno alunoJogMorto
	JOIN jogador AS jogMorto ON (alunoJogMorto.idAluno = jogMorto.idAluno)
	JOIN killJogador ON (jogMorto.idJogador = killjogador.jogMorto)
	JOIN jogador AS jogMat ON (jogMat.idJogador = killJogador.jogMatador)
	JOIN aluno AS alunoJogMat ON (alunoJogMat.idAluno = jogMat.idAluno)
	WHERE alunoJogMat.nome = pNomeJogador;
    end if;
END $$
DELIMITER ; 

CALL pListaJogadoresMortos(030316002, 'Raquel Gago');
CALL pListaJogadoresMortos(null, 'Luísa Barata');  
CALL pListaJogadoresMortos(null, 'Rui Morongo');

-- 10 - Faça uma procedure que multiplique os danos dos monstros com o valor recebido por parâmetro que tenham um tipo de ataque "Contundente". (ESTA)
	-- A procedure deve retornar o valor da quantidade alterada e o nome do monstro. 

DELIMITER $$
CREATE PROCEDURE pAlteraDanosMonstros(IN pValorDanos float)
BEGIN
	SET SQL_SAFE_UPDATES=0;
	UPDATE monstro SET danos = danos * pValorDanos WHERE UPPER(tipoAtaque) = UPPER('CONTUNDENTE');
    SET SQL_SAFE_UPDATES=1;
    
    SELECT nome, danos from monstro WHERE UPPER(tipoAtaque) = UPPER('CONTUNDENTE');
END $$
DELIMITER ; 

CALL pAlteraDanosMonstros(10);  
	


-- 12 --  Execute os comandos abaixo. 
	update municao set volume = 13 where idMunicao = 1;
    update municao set volume = 25 where idMunicao = 2;
    update municao, (select volume volumeQuery from municao where idMunicao = 1) qtd set volume = volumeQuery * 2 where idMunicao = 3;
    update municao set volume = 38 where idMunicao = 4;  

	-- Agora, Crie uma procedure que receba como parâmetro o nome de um jogador e retorne qual a quantidade de municao que ele possui;
	-- considerar que volume seria a quantidade
    -- utilize "Rui Morongo" como parâmetro.
    
    drop procedure if exists pQtdMunicao;
    
    DELIMITER $$
    create procedure pQtdMunicao (in pNomeJogador varchar (60))
    begin
		select aluno.nome, municao.volume from aluno
        join jogador on (aluno.idAluno = jogador.idAluno)
		join temMunicao on (temMunicao.idJogador = jogador.idJogador)
        join municao on (municao.idMunicao = temMunicao.idMunicao)
        where aluno.nome = pNomeJogador;
        
	end $$
    
    DELIMITER ;
    
    call pQtdMunicao ('Rui Morongo');
    call pQtdMunicao ('Raquel Gago');


