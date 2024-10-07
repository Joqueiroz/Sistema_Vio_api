const connect = require("./connect");

module.exports = function testConnect() {
  try {
    const query = `SELECT 'Conexão bem-sucedida' As mensagem`;
    connect.query(query, function (err) {
      if (err) {
        console.log("Conexão não reqlizada", err);
        return;
      }
      console.log("Conexão realizada com mysql");
    });
  } catch (error) {
    console.error("Erro a executar a consulta", error);
  }
};
