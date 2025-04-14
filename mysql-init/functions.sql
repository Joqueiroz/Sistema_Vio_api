-- CRIAÇÃO DE FUNCTION 
delimiter $$
create function calcula_idade(datanascimento date)
returns int 
deterministic 
contains sql 
begin 
    declare idade int;
    set idade = timestampdiff(year, datanascimento, curdate());
    return idade;
end; $$
delimiter ;

-- VERIFICA SE A FUNÇÃO ESPECIFICADA FOI CRIADA 
show create function calcula_idade;

select name, calcula_idade(data_nascimento) AS idade from usuario;

delimiter $$
create function status_sistema()
returns varchar(50)
no sql
begin 
    return 'Sistema operando normalmente';
end; $$
delimiter ;

-- execução de query
select status_sistema();


delimiter $$
create function total_compras_usuario(id_usuario int)
returns int 
reads sql data
begin 
    declare total int;

    select count(*) into total
    from compra 
    where id_usuario = compra.fk_id_usuario;

    return total;
end; $$
delimiter ;

-- execução da function
select total_compras_usuario(1) as compras_por_usuario;

-- apagar uma função 
drop function

-- tabela para criar uma função 
create table log_evento(
    id_log int AUTO_INCREMENT PRIMARY KEY,
    mensagem varchar(255),
    data_log datetime DEFAULT current_timestamp
);

delimiter $$
create function registrar_log_evento(texto varchar(255))
returns varchar(50)
not deterministic
modifies sql data
begin 
    insert into log_evento(mensagem)
    values (texto);

    return 'Log inserido co sucesso';
end; $$   
delimiter ;

-- Visualiza o estado da variavel de controle para permissões de criação de funções
show variables like 'log_bin_trust_function_creators';

--altera a variavel global do MySQL
-- precisa ter permissão de asministrador do banco 
set global log_bin_trust_function_creators = 1;

select registrar_log_evento('teste');


delimiter $$
create function mensagem_boas_vindas(nome_usuario varchar(100))
returns varchar(255)
deterministic
contains sql 
begin 
    declare msg varchar(255);
    set msg = concat('Olá, ', nome_usuario, '! Seja bem vindo(a) ao sistema VIO.');
    return msg;
end; $$
delimiter ; 

select routine_name from information_schema.routines
where routine_type = "FUNCTION" and routine_schema = "vio_joao";

-- Maior idade

delimiter $$

create function is_maior_idade(data_nascimento date)
returns boolean
 deterministic
contains sql
begin
    declare idade int;

    -- utilizando a função já criada
    set idade = calcula_idade(data_nascimento);
    return idade >=18;
end; $$

delimiter;

-- categorizar usuarios por faixa etaria
delimiter $$
create function faixa_etaria(data_nascimento date)
returns varchar(20)
 deterministic
contains sql
begin
    declare idade int;

    -- calculo da idade com a função ja existente
    set idade = calcula_idade(data_nascimento);

    if idade < 18 then
        return "menor de idade";
    else if idade < 60 then
        return "adulto";
    else 
        return "velho";    
    end if;
end; $$     


delimiter;

-- agrupar usuarios por faixa etaria 
select faixa_etaria(data_nascimento ) as faixa, count(*) as quantidade from usuario 
group by faixa;

-- identificar uma faixa etaria especifica
select name from usuario
    where faixa_etaria(data_nascimento) = "adulto";

 -- calcular a media de idade de usuario
 delimiter $$
 create function media_idade()
 returns decimal (5, 2)
 not deterministic
 reads sql data
 begin  
    declare media decimal (5,2);   

    -- calculo da media das idades
    select avg(timestampdiff(year, data_nascimento, curdate())) into media from usuario;

    return ifnull(media, 0);
end; $$

delimiter ;

-- selecionar idade especifica
select "A media de idade aos clientes é maior que 30" as resultado where media_idade() > 30;

-- Exercio direcionado
-- Calculo do total gasto por usuario
delimiter $$
create function calcula_total_gasto (pid_usuario int)
returns decimal (10, 2)
not deterministic
reads sql data
begin
    declare total decimal (10, 2);

    select sum(i.preco * ic.quantidade) into total
    from compra c
    join ingresso_compra ic on c.id_compra = ic.fk_id_compra
    join ingresso i on i.id_ingresso = ic.fk_id_ingresso
    where c.fk_id_usuario = pid_usuario; 

    return ifnull (total, 0);

end; $$

delimiter ;

--buscar a faixa etaria de usuario
delimiter $$
create function buscar_faixa_etaria_usuario(pid int)
returns varchar(20)
not deterministic
reads sql data
begin
    declare nascimento date;
    declare faixa varchar(20);

    select data_nascimento into nascimento
    from usuario 
    where id_usuario = pid;

    set faixa = faixa_etaria(nascimento);

    return faixa;
end; $$

delimiter ;

delimiter $$

create function total_ingressos_vendidos(id_evento int)
returns int
deterministic
reads sql data
begin
    declare total int;

    select sum(ic.quantidade)
    into total
    from ingresso_compra ic
    join ingresso i on i.id_ingresso = ic.fk_id_ingresso
    where i.fk_id_evento = id_evento;

    return ifnull(total, 0);
end $$

delimiter ;

delimiter $$

create function renda_total_evento(id_evento int)
returns decimal(10,2)
deterministic
reads sql data
begin
    declare renda decimal(10,2);

    select sum(i.preco * ic.quantidade)
    into renda
    from ingresso_compra ic
    join ingresso i on i.id_ingresso = ic.fk_id_ingresso
    where i.fk_id_evento = id_evento;

    return ifnull(renda, 0.00);
end $$

delimiter ;
