set global event_scheduler = on;

create event if not exists arquivar_compras_antigas
    on schedule every 1 day
    starts current_timestamp + interval 1 day
    on completion preserve
    ENABLE
do
    insert into historico_compra(id_compra, data_compra,
        id_usuario)
    select id_compra, data_compra, fk_id_usuario from compra
    where data_compra < now() - interval 6 month;