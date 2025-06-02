delimiter //

create trigger impedir_alteracao_cpf
before update on usuario
for each row
begin
    if old.cpf <> new.cpf then
        signal sqlstate '45000'
        set message_text = 'Não é permitido alterar o CPF de um usuário já cadastrado';
    end if;
end; //

delimiter ;

-- Criando tablea para historico de compra log--
create table historico_compra (
    id_historico int AUTO_INCREMENT PRIMARY KEY,
    id_compra int not null,
    data_compra datetime not null,
    id_usuario int not null,
    data_exclusao datetime DEFAULT CURRENT_TIMESTAMP
);