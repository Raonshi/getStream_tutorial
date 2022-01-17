const Firebase = require('./firebase_module.cjs');
const Chat = require('./stream_module.cjs');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const fire = Firebase.firebase;
const chat = Chat.chat;

//server init
app.listen(4000, async ()=> {
    console.log('App listening on port 4000!');
});

//generate token
app.post('/token', (req, res, next) => {
    console.log('req : ', req.body);
    const userToken = chat.client.createToken(req.body.userId);
    const storeAccount = fire.saveAccount(req.body);

    if(storeAccount){
        res.json({success: 200, token: userToken});
    } 
});

//create custom command
app.post('/createCommand', async (req, res) => {
    res = await chat.createNewCommand(req.body);

    console.log(res);
});


//login check
app.post('/loginCheck', async (req, res) => {
    console.log('LoginCheck Call!');
    console.log(req.body);
    const result = await fire.readAccount(req.body['email']);
    res.statusCode = 200;
    res.send(result);
})


//save command call
app.post('/custom-commands/save', async (req, res) => {
    const cid = req.body['message']['cid'];
    const text = req.body['message']['args'];
    const data = await chat.client.search({cid: cid}, {text: { "$autocomplete": text }});
    const isSave = await fire.saveData(data.results);
})