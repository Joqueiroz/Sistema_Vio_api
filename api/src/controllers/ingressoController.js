const connect = require("../db/connect");

module.exports = class ingressoController {
  // Criação de um ingresso
  static async createIngresso(req, res) {
    const { preco, tipo, fk_id_evento } = req.body;

    // Validação genérica de todos os atributos
    if (!preco || !tipo || !fk_id_evento) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos" });
    }
    
    const query = `INSERT INTO ingresso(preco, tipo, fk_id_evento) VALUES(?, ?, ?)`;
    const values = [preco, tipo, fk_id_evento];

    try {
      connect.query(query, values, (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao criar o ingresso" });
        }
        return res.status(201).json({ message: "Ingresso criado com sucesso" });
      });
    } catch (error) {
      console.log("Erro ao executar consulta:", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  // Visualizar todos os ingressos cadastrados
  static async getAllIngressos(req, res) {
    const query = `SELECT * FROM ingresso`;

    try {
      connect.query(query, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao buscar ingressos" });
        }
        return res.status(200).json({ message: "Lista de ingressos", ingressos: results });
      });
    } catch (error) {
      console.error("Erro ao executar a query:", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  // Atualizar ingresso
  static async updateIngresso(req, res) {
    const { id_ingresso, preco, tipo, fk_id_evento } = req.body;

    if (!preco || !tipo || !fk_id_evento) {
      return res.status(400).json({ error: "Todos os campos devem ser preenchidos" });
    }

    const query = `UPDATE ingresso SET preco=?, tipo=?, fk_id_evento=? WHERE id_ingresso=?`;
    const values = [preco, tipo, fk_id_evento, id_ingresso];

    try {
      connect.query(query, values, function (err, results) {
        console.log("Resultados: ", results);
        if (err) {
          console.error(err);
          return res.status(500).json({ error: "Erro interno do servidor" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Ingresso não encontrado" });
        }
        return res.status(200).json({ message: "Ingresso atualizado com sucesso" });
      });
    } catch (error) {
      console.error("Erro ao executar consulta: ", error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  // Deletar ingresso
  static async deleteIngresso(req, res) {
    const ingressoId = req.params.id_ingresso;
    const query = `DELETE FROM ingresso WHERE id_ingresso = ?`;
    const values = [ingressoId];

    try {
      connect.query(query, values, function (err, results) {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao excluir ingresso" });
        }
        if (results.affectedRows === 0) {
          return res.status(404).json({ error: "Ingresso não encontrado" });
        }
        return res.status(200).json({ message: "Ingresso excluído com sucesso" });
      });
    } catch (error) {
      console.log(error);
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }
};
