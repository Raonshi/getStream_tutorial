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

//message save
app.post('/save', async (req, res) => {
    const message = req.body.message;
    
    await chat.client.updateAppSettings({ 
        custom_action_handler_url: "http://localhost:4000/webhooks/stream/custom-commands?type={type}", 
    });  
    
    //var result = await fire.saveData(data);

    res.send('helklo');
});