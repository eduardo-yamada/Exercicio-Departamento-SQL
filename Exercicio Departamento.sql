create table depto (
	cd_depto int primary key,
	ds_depto varchar(50)
);

create table pssoa (
	cd_pssoa int primary key,
	ds_pssoa varchar(50),
	cd_depto int,
	constraint fk_depto_pssoa foreign key (cd_depto) references depto(cd_depto)
);

/* A) Desenvolva o script SQL de criação da tabela DEPTO. Inclua pelo menos 5 registros (utilize sequence e insert com query quando necessário). */

create sequence "contador_depto"
select setval('contador_depto',1);

insert into depto values (nextval('contador_depto'),'Financeiro');
insert into depto values (nextval('contador_depto'),'RH');
insert into depto values (nextval('contador_depto'),'TI');
insert into depto values (nextval('contador_depto'),'Diretoria');
insert into depto values (nextval('contador_depto'),'Controladoria');
insert into depto values (nextval('contador_depto'),'Compras');
insert into depto values (nextval('contador_depto'),'Marketing');
insert into depto values (nextval('contador_depto'),'Processos');

/* b) Desenvolva o script SQL de criação da tabela PSSOA. Inclua pelo menos 5 registros (utilize sequence e insert com query quando necessário). */

create sequence "contador_pssoa"
select setval('contador_pssoa',1);

insert into pssoa values (nextval('contador_pssoa'),'Gabriel',(select cd_depto from depto where cd_depto=2));
insert into pssoa values (nextval('contador_pssoa'),'Fernando',(select cd_depto from depto where cd_depto=3));
insert into pssoa values (nextval('contador_pssoa'),'Josias',(select cd_depto from depto where cd_depto=4));
insert into pssoa values (nextval('contador_pssoa'),'Eduardo',(select cd_depto from depto where cd_depto=5));
insert into pssoa values (nextval('contador_pssoa'),'Emir',(select cd_depto from depto where cd_depto=6));
insert into pssoa values (nextval('contador_pssoa'),'TesteEx',(select cd_depto from depto where cd_depto=8));

update pssoa set cd_depto=null where ds_pssoa='TesteEx'

select * from pssoa;
select * from depto;

/*c) O analista de projeto te pediu para adicionar uma nova coluna na tabela PSSOA chamada de DT_NASC (Data de Nacimento). 
Atualize esta informação em todos os registros inseridos.*/

alter table pssoa
add column dt_nasc date;

update pssoa set dt_nasc = '1998-07-04' where ds_pssoa='Gabriel';
update pssoa set dt_nasc = '1996-01-07' where ds_pssoa='Eduardo';
update pssoa set dt_nasc = '1991-05-09' where ds_pssoa='Josias';
update pssoa set dt_nasc = '1995-10-10' where ds_pssoa='Emir';
update pssoa set dt_nasc = '1999-12-12' where ds_pssoa='Fernando';


/*d) O analista de sistemas solicitou que seja criada uma view para possibilitar a geração de um relatório referente aos aniversariantes 
(nome da pessoa, data de nascimento) o mês de setembro. Dica: pesquise sobre a função date_part.  */

create view pssoa_aniver as
select ds_pssoa, dt_nasc 
from pssoa 
where date_part('month', dt_nasc)=07;


/*e) O analista de sistemas solicitou que seja criada uma view para possibilitar a geração de
um relatório mensal de pessoas lotada em um departamento (nome da pessoa, nome
do departamento). */

create view relMenPssoaDpto as
select p.ds_pssoa, d.ds_depto
from pssoa p,depto d
where p.cd_depto=d.cd_depto 

/* F) O analista de sistemas solicitou que seja criada uma view para gerar relatório de
pessoas em ordem decrescente.*/

create view pssoa_ordem as
select ds_pssoa
from pssoa
order by ds_pssoa desc;

/* g) O analista de sistemas solicitou que seja criada uma view para gerar relatório de
departamento que estão vazios (não possuem pessoas). */

create view depto_vazio as
select d.ds_depto 
from depto d
where d.cd_depto not in(select cd_depto from pssoa group by cd_depto)

delete from pssoa where cd_depto is null;

/*h) O analista de sistemas solicitou que seja criada uma view para gerar relatório de
departamento que não estão vazios (possuem pessoas).
*/
create view dpto_alguem as
select ds_depto
from depto d,pssoa p
where p.cd_pessoa=d.cd_depto;

/* 3) O analista do projeto, 1 ano depois decidiu criar o sistema de segurança e pediu
para incluir uma nova tabela chamada USUAS (Usuários) de acordo com o modelo revisado
apresentado abaixo (OBS: incluir pelo menos 5 registros na nova tabela): */

create table usuas (
	cd_usuas int primary key,
	cd_pssoa int,
	ds_login varchar(20),
	ds_senha varchar(20),
	constraint fk_pssoa_usuas foreign key (cd_pssoa) references pssoa(cd_pessoa)
 
);

create sequence "contador_usuas"
select setval('contador_usuas',1);

insert into usuas values (nextval('contador_usuas'),(select cd_pessoa from pssoa where ds_pssoa='Emir'),'emir1','123654');
insert into usuas values (nextval('contador_usuas'),(select cd_pessoa from pssoa where ds_pssoa='Gabriel'),'gabriel1','185454');
insert into usuas values (nextval('contador_usuas'),(select cd_pessoa from pssoa where ds_pssoa='Josias'),'josias1','123250654');
insert into usuas values (nextval('contador_usuas'),(select cd_pessoa from pssoa where ds_pssoa='Eduardo'),'eduardo1','1232521654');
insert into usuas values (nextval('contador_usuas'),(select cd_pessoa from pssoa where ds_pssoa='Fernando'),'fernando','12352228654');


select * from usuas;

/* a) O analista de sistemas solicitou que seja criada uma view para gerar relatório de
usuários do sistema por departamento (login do usuário, nome do departamento). */

create view usua_sistem as
select u.ds_login, d.ds_depto
from usuas u,depto d, pssoa p
where (u.cd_usuas=p.cd_pessoa) and (d.cd_depto=p.cd_pessoa);
