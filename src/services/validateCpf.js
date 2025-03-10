const connect = require ("../db/connect")

module.exports = async function validateCpf(cpf, userId){

    const query = "SELECT id_usuario from usuario where cpf = ?"
    const values = [cpf];

    connect.query(query, values, (err, results)=>{
        if (err){
            // fazer algo
        }
        else if (results.length > 0){
            const idDocpfCadastrado = results [0].id_usuario;

            if(userId && idDocpfCadastrado !== userId){
                return {error: "CPF ja cadastrado para outro usuario"}
            }else if (!userId){
                return {error:"CPF ja cadastrado"}
            }
        }
        else{
            return null;
        }
    })
}