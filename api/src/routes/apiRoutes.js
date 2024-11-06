const router = require("express").Router();

const userController = require("../controllers/userController");
const orgController = require("../controllers/orgController");
const eventoController = require("../controllers/eventoController");

router.post("/user", userController.createUser);
router.get("/user", userController.getAllUsers);
router.put("/user", userController.updateUser);
router.delete("/user/:id_usuario", userController.deleteUser);

router.post("/org", orgController.createOrg);
router.get("/org", orgController.getAllOrgs);
router.put("/org", orgController.updateOrg);
router.delete("/org/:id_organizador", orgController.deleteOrg);

//rotas eventoController
router.post("/evento", eventoController.createEvento);
router.get("/evento", eventoController.getallEventos);
router.put("/evento", eventoController.updateEventos);
router.delete("/evento/:id_evento", eventoController.deleteEvento);


module.exports = router;
