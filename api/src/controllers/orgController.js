let orgs = []; 
let nextId = 1;

module.exports = class orgController {
  static async createOrganizador(req, res) {
    const {telefone, email, password, name } = req.body;

    if (!telefone || !email || !password || !name) {
      return res.status(400).json({ error: "Todos os campos devem ser preenchidos" });
    } else if (isNaN(telefone) || telefone.length !== 11) {
      return res.status(400).json({ error: "Telefone inválido. Deve conter exatamente 11 dígitos numéricos" });
    } else if (!email.includes("@")) {
      return res.status(400).json({ error: "Email inválido. Deve conter @" });
    } 
    
      

    // Verifica se já existe um usuário com o mesmo email
    const existingOrganizador = orgs.find(org => org.email === email);
    if (existingOrganizador) {
      return res.status(400).json({ error: "Email já cadastrado" });
    }

    // Cria e adiciona novo organizador
    const newOrganizador = {id: nextId++,telefone, email, password, name };
    orgs.push(newOrganizador);

    return res.status(201).json({ message: "Usuário criado com sucesso", org: newOrganizador });
  }


  static async getAllOrganizadores(req, res) {
    return res.status(200).json({ message: "Obtendo todos os usuários", orgs });
  }


  static async updateOrganizador(req, res) {
    // Desestrutura e recupera os dados enviados via corpo da requisição
    const {id, telefone, email, password, name } = req.body;

    // Validar se todos os campos foram preenchidos
    if(!id || !telefone || !email || !password || !name) {
        return res.status(400).json({error:"Todos os campos devem ser preenchidos"});
    }
    //Procurar o indice do user no Array 'orgs' pelo id
    const orgIndex = orgs.findIndex(org => org.id == id)
    //Se o usuário não for encontrado userIndex equivale a -1
    if(orgIndex === -1){
        return res.status(400).json({error: "Usuário não encontrado"});
    }

    //Atualiza os dados do usuário no Array 'users'
    orgs[orgIndex] = {id, telefone, email, password, name }
    
    return res.status(200).json({message: "Usuário atualizado", org:orgs[orgIndex]})
  }

  static async deleteOrganizador(req, res) {
    // Obtem o parametro 'id' da requisição, que é o id do org a ser deletado
    const orgId = req.params.id

    //Procurar o indice do user no Array 'users' pelo cpf
    const orgIndex = orgs.findIndex((org) => org.id == orgId)
    //Se o usuário não for encontrado userIndex equivale a -1
    if(orgIndex == -1){
        return res.status(400).json({error: "Usuário não encontrado"});
    }

    // Removendo o usuário do Array 'orgs'
    orgs.splice(orgIndex,1);
    return res.status(200).json({message: "Usuário Apagado!", orgs})
   
};
}