delimiter //
create trigger impedir_alteracao_cpf
before update on usuario
for each ROW
begin   
    if old.cpf <> new.cpf then
        signal sqlstate "45000"
        set message_text = "Não é permitido alterar o cpf de um usuario ja cadastrado";
    end if;
end; //
delimiter ;        