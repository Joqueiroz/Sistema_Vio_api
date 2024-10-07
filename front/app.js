//Acessa o objeto "document" que representa a página html
// Seleciona o elemento com o Id do formulario
document
    .getElementById ("formulario-registro")
    //adiciona o ouvinte de evento (submit) para capturar o envio do formulario
    .addEventListener("submit", function (event){
        //Previne o comportamento padrao do formulario, ou seja, impede que ele seja enviado e recarregue a pagina
        event.preventDefault("");

        //Captura os valores dos campos do formulario
        const name = document.getElementById("nome");
        const cpf = document.getElementById("cpf");
        const email = document.getElementById("email");
        const password = document.getElementById("senha");

        //Requisição HTTP para o endpoint do cadastro de usuario
        fetch ("http://localhost:5000/api/v1/user",{
            //Realiza uma chamada http para o servidor (a rota definida)
            method: "POST",
            headers:{
                //A requisição sera em formato json
                "Content-type": application/JSON
            },
            //Transforma os dados do formulario em uma string json para serem enviados no corpo da requisição
            body: JSON.stringify({name, cpf, email, password}),
        })
    });
