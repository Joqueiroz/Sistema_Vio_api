delimiter //

create procedure registrar_compra(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)
begin 
    declare v_id_compra int;

-- CRIAR REGISTRO NA TABELA 'COMPRA'
insert into compra (data_compra, fk_id_usuario)
    values (now(), p_id_usuario);

-- OBTER OS INGRESSOS COMPRADOS 
set v_id_compra = last_insert_id();

-- REGISTRAR OS INGRESSOS COMPRADOS
insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
    values (v_id_compra, p_id_ingresso, p_quantidade);

end; //

delimiter ;

delimiter //

create procedure total_ingressos_usuarios(
    in p_id_usuario int,
    out p_total_ingressos int
)
begin 
    -- INICIALIZAR O VALOR DA SAÍDA 
    set p_total_ingressos = 0;

    -- CONSULTAR E SOMAR TODOS OS INGRESSOS COMPRADOS PELO USUÁRIO
    select coalesce (sum(ic.quantidade), 0)
    into p_total_ingressos
    from ingresso_compra ic
    join compra c on ic.fk_id_compra = id_compra
    where c.fk_id_usuario = p_id_usuario;
end; //

delimiter ;


show procedure status where db = "vio_joao";

set @total = 0;

call total_ingressos_usuarios (2, @total);


delimiter //

create procedure registrar_presenca(
    in p_id_compra int,
    in p_id_evento int
)
begin 
    -- REGISTRAR PRESENÇA
    insert into presenca (data_hora_checkin, fk_id_evento, fk_id_compra)
    values (now(), p_id_evento, p_id_compra);
end; //
delimiter ;

call registrar_presenca (1, 1);

drop procedure -- apaga a procedure

-- procedure para resumo do usuario
delimiter $$

create procedure resumo_usuario (in pid int)
begin
    declare nome varchar(100);
    declare email varchar(100);
    declare totalrs decimal(10, 2);
    declare faixa varchar(20);

    -- busca o nome e o email do usuario
    select u.name, u.email into nome, email 
    from usuario u
    where u.id_usuario = pid;

    -- chamada das funções especificas ja criadas
    set totalrs = calcula_total_gasto(pid);
    set faixa = buscar_faixa_etaria_usuario(pid);
    
    -- exibe os dados formatados
    select 
        nome as nome_usuario,
        email as email_usuario,
        totalrs as total_gasto,
        faixa as faixa_etaria;
end $$

delimiter ;

delimiter $$

create procedure resumo_evento(in id_evento int)
begin
    declare nome_evento varchar(100);
    declare data_evento datetime;
    declare total_vendidos int;
    declare renda_total decimal(10,2);

    -- Busca informações básicas do evento (
    select nome, data_hora
    into nome_evento, data_evento
    from evento
    where evento.id_evento = id_evento;

    -- Usa as funções para calcular ingressos e renda
    set total_vendidos = total_ingressos_vendidos(id_evento);
    set renda_total = renda_total_evento(id_evento);

    -- Exibe o resumo formatado
    select 
        nome_evento as nome,
        data_evento as data_hora,
        total_vendidos as ingressos_vendidos,
        renda_total as renda_total;
end $$

delimiter ;
