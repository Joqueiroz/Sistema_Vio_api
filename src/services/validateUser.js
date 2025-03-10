module.exports = function validateUser({
    cpf, email, password, name, data_nascimento
}){
 if(!cpf || !email || !password || !name || !data_nascimento){
    return{error:"Todos os campos devem ser preenchidos"}
 }
 if(isNaN(cpf)|| cpf.length !== 11){
    return{error:"Cpf deve conter 11 digitos"}
 }
 if (!email.includes("@")){
    return{error:"Email invalido, deve conter @"}
 }
 return null;//se estiver tudo certo retorna nulo para ignorar o if, na userController

}