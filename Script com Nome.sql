drop database if exists academia;
create database academia; 
use academia;

create table instrutor (
	idInstrutor int(10) auto_increment primary key,
    rg int(10), 
    nome varchar(100), 
    nascimento date, 
    titulacao int(10)
);


create table telefone_instrutor(
	idTelefone int(10) auto_increment primary key,
    numero int(10),
    tipo varchar(45), -- casa / celular
    idInstrutor int(10),
    FOREIGN KEY (idInstrutor) REFERENCES Instrutor(idInstrutor)
);

create table atividade (
	idAtividade int(10) auto_increment primary key, 
    nome varchar(150)
);

create table turma(
	idTurma int(10) auto_increment primary key,
    horario time,
    descricao varchar(100), 
    duracao int(10), 
    dataInicio date, 
    dataFim date, 
    idInstrutor int(10),
    idAtividade int(10),
    FOREIGN KEY (idInstrutor) REFERENCES Instrutor(idInstrutor), 
    FOREIGN KEY (idAtividade) REFERENCES atividade(idAtividade)
);

create table aluno(
	idAluno int(10) auto_increment primary key,    
    nome varchar(100), 
    endereco varchar (100), 
    telefone int (10), 
    dataNascimento date, 
    altura int(10), 
    peso int(10)
);


create table matricula (
	idAluno int(10), 
    idTurma int(10),
    PRIMARY KEY (idAluno, idTurma),
    FOREIGN KEY (idAluno) REFERENCES Aluno(idAluno), 
    FOREIGN KEY (idTurma) REFERENCES turma(idTurma)
);


create table chamada (
	idChamada int auto_increment primary key, 
    data date, 
    presente char(1),   -- f = falta , p = presente
    idAluno int(10), 
    idTurma int(10), 
    FOREIGN KEY (idAluno) REFERENCES matricula(idAluno), 
    FOREIGN KEY (idTurma) REFERENCES matricula(idTurma)
);

Alter table matricula ADD column dataMatricula date;

insert into Aluno (nome, endereco, telefone, dataNascimento, altura, peso) values ('Kaio', 'centro', 40028922, '2018-01-31', 170, 140);
insert into Aluno (nome, endereco, telefone, dataNascimento, altura, peso) values ('Rabuski', 'centro', 08006444, '1994-04-24', 154, 49);
insert into Aluno (nome, endereco, telefone, dataNascimento, altura, peso) values ('Micael', 'matriz', 99447896, '2001-05-06', 164, 68);

insert into telefone_instrutor(numero, tipo) values (88123456, 'celular');
insert into telefone_instrutor(numero, tipo) values (99123447, 'celular');
 
insert into Instrutor (RG, nome, nascimento, titulacao) values (456789123, 'Jose', '1988-04-24', 21);
insert into Instrutor (RG, nome, nascimento, titulacao) values (456789123, 'Joao', '1987-03-18', 22);

insert into Turma (horario, descricao, duracao, dataInicio, dataFim) values ('9:00:00', 'Turma da manha', 2, '2018-02-02', '2018-09-11');
insert into Turma (horario, descricao, duracao, dataInicio, dataFim) values ('14:00:00', 'Turma da tarde', 2, '2018-02-02', '2018-09-11');
insert into Turma (horario, descricao, duracao, dataInicio, dataFim) values ('00:00:00', 'Turma da madrugada', 2, '2018-02-02', '2018-09-11');

insert into Atividade (nome) values ('zumba');
insert into Atividade (nome) values ('musculacao');
insert into Atividade (nome) values ('danca alternativa');

insert into matricula (idAluno, idTurma, dataMatricula) values (1, 1, now());

select *from matricula;

-- Q1 - Mostre os alunos moram no centro
-- Q2 - Insira um campo 'endereco' na tabla 'Instrutor'
-- Q3 - Modifique os campos 'altura' e 'peso' da tablea 'Aluno' para o tipo Double
-- Q4 - Crie uma trigger que não permita o uso do mesmo 'rg' na tablela 'instrutor'
-- Q5 - Delete todos os alunos que se chamem 'Kaio'

-- Micael Barreto de Moraes e Marcos Narita
-- 19/02/2018


