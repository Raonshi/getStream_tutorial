const express = require('express');
const StreamChat = require('stream-chat').StreamChat;
const bodyParser = require('body-parser');
const app = express();


const client = new StreamChat('grdysyd7gzfn', 'mf5fnujjbt43rgepwh47h8ccp6r6c54vnrgh9sgn337ce3y4nnq3jxnv88bedanh');

app.use(bodyParser.json());
app.post('/token', (req, res, next) => {
    console.log('req : ', req.body);
    const userToken = client.createToken(req.body.userId);
    res.json({success: 200, token: userToken});
});

app.listen(4000, _ => {
    console.log('App listening on port 4000!');
});