const router = require('express').Router()

const { route } = require('..');
const userController = require("../controllers/userController")
const orgController = require("../controllers/orgController")

router.post('/user', userController.createUser);
//router.post('user/login', userController.postLogin);
router.get('/user', userController.getAllUsers);
//router.get('/user/:cpf', userController.gerUserById); 
router.put('/user', userController.updateUser);
router.delete('/user/:cpf', userController.deleteUser);

router.post('/organizador', orgController.createOrganizador);
router.get('/organizador', orgController.getAllOrganizadores);
router.put('/organizador', orgController.updateOrganizador);
router.delete('/organizador/:id', orgController.deleteOrganizador);



module.exports = router