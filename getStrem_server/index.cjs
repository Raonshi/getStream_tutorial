const Firebase = require('./firebase_module.cjs');
const Chat = require('./stream_module.cjs');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

const fire = Firebase.firebase;
const chat = Chat.chat;

app.listen(4000, async ()=> {
    console.log('App listening on port 4000!');
});

//generate token
app.post('/token', (req, res, next) => {
    console.log('req : ', req.body);
    const userToken = chat.client.createToken(req.body.userId);
    res.json({success: 200, token: userToken});
});

//create custom command
app.post('/createCommand', async (req, res) => {
    res = await chat.createNewCommand(req.body);

    console.log(res);
});


//update custom command
app.post('/updateUrl', async (req, res) => {
    res = await chat.client.updateAppSettings({ 
        custom_action_handler_url: "http://localhost:4000/webhooks/stream/custom-commands?type={type}", 
    });  
    console.log(res);
});


//create custom command
app.post('/custom-commands', async(req, res) => {
    const type = req.body;
    console.log(type);
});