create event if not exists excluir_evento_antigo 
    on schedule every 1 week
    starts current_timestamp + interval 5 minute
    on completion preserve
    ENABLE
do
    delete from evento 
    where data_evento <= now() - interval 1 year;


insert into evento (id_evento, nome, descricao, data_hora, local, fk_id_organizador)
values (2001, 'Evento Antigo', 'Descrição do Evento 1', now() , 'Local 1', 1);