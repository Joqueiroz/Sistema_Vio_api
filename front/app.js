// Chamada da função "createuser" para a associação ao evento de envio do formulario
document
  .getElementById("formulario-registro")
  .addEventListener("submit", createUser);

document.addEventListener("DOMContentLoaded", getAllUsers);
document.addEventListener("DOMContentLoaded", getAllorgsTable);

document.addEventListener("DOMContentLoaded", getAllUsersTable);

function createUser(event) {
  //Previne o comportamento padrao do formulario, ou seja, impede que ele seja enviado e recarregue a pagona
  event.preventDefault();

  //Captura os valores dos campos do formularios
  const name = document.getElementById("nome").value;
  const cpf = document.getElementById("cpf").value;
  const email = document.getElementById("email").value;
  const password = document.getElementById("senha").value;

  //Requisição HTTP para o endpoint de cadastro de usuario
  fetch("http://10.89.240.3:5000/api/v1/user", {
    //Realiza uma chamada http para o servidor(a rota definida)
    method: "POST",
    headers: {
      //A requisição será em formato json
      "Content-Type": "application/json",
    },
    //Transforma os dados do formulario de uma string json para serem enviados no corpo da req
    body: JSON.stringify({ name, cpf, email, password }),
  })
    .then((response) => {
      //Tratamento da resposta do servidor / API
      if (response.ok) {
        //verifica se a resposta foi bem sucedida (status 2xx(duzentos e alguma coisa))
        return response.json();
      }
      //Convertendo o erro em formato JSON
      return response.json().then((err) => {
        //Mensagem retornada do servidor acessada pela chave "error"
        throw new Error(err.error);
      });
    }) //Fechamento da then(response)
    .then((data) => {
      //executa a resposta de sucesso - retorna ao usuario final

      //Exibe um alerta para o usuario final (front) com o nome que acabou de ser cadastrado
      alert(data.message);
      console.log(data.message);
      //Exibe o log no terminal

      //Reseta os campos do formulario após o sucesso do cadastro
      document.getElementById("formulario-registro").reset();
    })
    .catch((error) => {
      //Captura qualquer erro que ocorra durante o processo de requisição / resposta

      //Exibe alerta (front) com o erro processado
      alert("Erro no cadastro: " + error.message);
      console.error("Erro:", error.message);
    });
}

function getAllUsers() {
  fetch("http://10.89.240.3:5000/api/v1/user", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      return response.json().then((err) => {
        throw new Error(err.error);
      });
    })
    .then((data) => {
      const userList = document.getElementById("user-list");
      userList.innerHTML = " "; // Limpa a lista existente

      data.users.forEach((user) => {
        const listItem = document.createElement("li");
        listItem.textContent = `Nome: ${user.name},CPF: ${user.cpf}, Email: ${user.email}`;
        userList.appendChild(listItem);
      });
    })
    .catch((error) => {
      alert("Erro ao obter usuarios" + error.message);
      console.error("Erro:", error.message);
    });
}

function getAllUsersTable(){
  fetch("http://10.89.240.3:5000/api/v1/user", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      return response.json().then((err) => {
        throw new Error(err.error);
      });
    })
    .then((data) => {
      const userList = document.getElementById("user-list-tabela");
      userList.innerHTML = ""; //Limpa a lista antes de adicionar novos itens
      data.users.forEach((usuario) => { //Verifica se há usuarios retornados e os adiciona á tabela
      const tr = document.createElement("tr");//Cria uma nova linha
      const tdName = document.createElement("td");//Cria celulas para nome, CPF e e-mail
      tdName.textContent = usuario.name;
      tr.appendChild(tdName);

      const tdcpf = document.createElement("td");//Cria celulas para nome, CPF e e-mail
      tdcpf.textContent = usuario.cpf;
      tr.appendChild(tdcpf);

      const tdemail = document.createElement("td");//Cria celulas para nome, CPF e e-mail
      tdemail.textContent = usuario.email;
      tr.appendChild(tdemail);

      userList.appendChild(tr); //Adiciona a linha á tabela  

      });
    })
    .catch((error) => {
      alert("Erro ao obter usuarios: " + error.message);
      console.error("Erro: ", error.message)
    });
}

function getAllorgsTable(){
  fetch("http://10.89.240.3:5000/api/v1/organizador", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      return response.json().then((err) => {
        throw new Error(err.error);
      });
    })
    .then((data) => {
      const orgList = document.getElementById("org-list-tabela");
      orgList.innerHTML = ""; //Limpa a lista antes de adicionar novos itens
      data.organizadores.forEach((organizador) => { //Verifica se há usuarios retornados e os adiciona á tabela
      const tr = document.createElement("tr");//Cria uma nova linha
      const tdNome = document.createElement("td");//Cria celulas para nome, CPF e e-mail
      tdNome.textContent = organizador.nome;
      tr.appendChild(tdNome);

      const tdtelefone = document.createElement("td");//Cria celulas para nome, CPF e e-mail
      tdtelefone.textContent = organizador.telefone;
      tr.appendChild(tdtelefone);

      const tde_mail = document.createElement("td");//Cria celulas para nome, CPF e e-mail
      tde_mail.textContent = organizador.email;
      tr.appendChild(tde_mail);

      orgList.appendChild(tr); //Adiciona a linha á tabela  

      });
    })
    .catch((error) => {
      alert("Erro ao obter organizadores: " + error.message);
      console.error("Erro: ", error.message)
    });
}