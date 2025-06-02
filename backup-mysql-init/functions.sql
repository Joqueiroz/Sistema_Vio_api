delimiter $$
create function calcula_idade(data_nascimento date)
returns int 
deterministic
contains sql 
begin
    declare idade int;
    set idade = timestampdiff(year, data_nascimento, curdate());
    return idade;
end; $$
delimiter ;

select calcula_idade('1990-01-01');

--verifica se a função existe
show create function calcula_idade;

select name, calcula_idade(data_nascimento) as idade from usuario;

delimiter $$
create function status_sistema()
returns varchar(50)
no sql
begin
    return 'Sistema Funcionando Normalmente';
end; $$
delimiter ;

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

select total_compras_usuario(1) as "Total de compras";

--tabela para testar a clausula modifies sql data
create table log_evento(
    id_log int AUTO_INCREMENT PRIMARY KEY,
    mensagem varchar(255),
    data_log datetime default current_timestamp
);

delimiter $$
create function registrar_log_evento(texto varchar(255))
returns varchar(50)
not deterministic
modifies sql data
begin
    insert into log_evento(mensagem)
    values(texto);

    return 'Log registrado com sucesso';
end; $$
delimiter ;

    select registrar_log_evento('Teste de log');

--visualiza o estado da variavel de controle para permissoes de criação de funções
show variables like 'log_bin_trust_function_creators';

--altera variavel global no MYSQL
--precisa ter permissao de administração no banco
set global log_bin_trust_function_creators= 1;

delimiter $$
create function mensagem_boas_vindas(nome_usuario varchar(100))
returns varchar(255)
deterministic
contains sql
begin
    declare msg varchar(255);
    set msg = concat('Olá, ',nome_usuario, '! Seja bem-vindo(a) ao sistema VIO.');
    return msg;
end; $$
delimiter ;

select mensagem_boas_vindas('matezin')

select routine_name from
information_schema.routines
    where routine_type = 'FUNCTION'
        and routine_schema = 'vio_mateus';


-- maior idade
delimiter $$

create function is_maior_idade(data_nascimento date)
returns boolean
not deterministic
contains sql
begin
    declare idade int;

    -- utilizando a função ja criada
    set idade = calcula_idade(data_nascimento);
    return idade >= 18;
end; $$

delimiter ;

-- categorizar usuários por faixa etária
delimiter $$

create function faixa_etaria(data_nascimento date)
returns varchar(20)
not deterministic
contains sql
begin
    declare idade int;

    -- calculo da idade com a função existente
    set idade = calcula_idade(data_nascimento);
    if idade < 18 then
        return "Menor de idade";
    elseif idade < 60 then
        return "Adulto"; 
    elseif idade >= 60 then
        return "Idoso";
    else 
        return "Idade não encontrada";
end if; 
end; $$

delimiter ;

-- agrupar usuarios por faixa etária 
select faixa_etaria(data_nascimento) as faixa,
count(*) as quantidade from usuario
group by faixa;

-- identificar uma faixa etartia especifica
select name from usuario
    where faixa_etaria(data_nascimento) = "Adulto";

-- "timestampdiff" diferença de time

-- calcular a média de idade de usuarios cadastrados
delimiter $$
create function media_idade()
returns decimal(5,2)
not deterministic
reads sql data
begin
    declare media decimal(5,2);
    
    -- cálculo da média das idades
    select avg(timestampdiff(year, data_nascimento, curdate())) into media from usuario;

    return ifnull(media, 0);
end; $$
delimiter ;

-- selecionar idade especifica
select "A média de idade dos clientes é maior que 30" as resultado where media_idade() > 30;


-- EXERCICIO DIRECIONAS DE FUNCTIONS/PROCEDURES --------------------------------------------------------------------------------------------
-- cálculo do total de gasto por um usuário
delimiter $$
create function calcula_total_gasto(pid_usuario int)
returns decimal(10, 2)
not deterministic
reads sql data
begin
    declare total decimal (10, 2);

    select sum(i.preco * ic.quantidade) into total
    from compra c
    join ingresso_compra ic on c.id_compra = ic.fk_id_compra
    join ingresso i on i.id_ingresso = ic.fk_id_ingresso
    where c.fk_id_usuario = pid_usuario;

    return ifnull(total, 0);

    end; $$
    delimiter ;

-- buscar a faita etaria do usuario
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

-- EXERCICIOO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Função para ver todos os ingressos vendidos no evento
delimiter $$

create function total_ingressos_vendidos(id_evento int)
returns int
reads sql data
begin
    declare total int;

    select ifnull(sum(ic.quantidade), 0)
    into total
    from ingresso_compra ic
    join ingresso i on ic.fk_id_ingresso = i.id_ingresso
    where i.fk_id_evento = id_evento;

    return total;
end $$

delimiter ;

-- Função para ver a renda total do evento
delimiter $$

create function renda_total_evento(id_evento int)
returns decimal(10,2)
reads sql data
begin
    declare total decimal(10,2);

    select ifnull(sum(i.preco * ic.quantidade), 0.00)
    into total
    from ingresso_compra ic
    join ingresso i on ic.fk_id_ingresso = i.id_ingresso
    where i.fk_id_evento = id_evento;

    return total;
end $$

delimiter ;

-- Codigo ip da maquina 10.89.240.82