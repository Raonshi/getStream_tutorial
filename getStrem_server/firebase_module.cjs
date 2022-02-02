//firebase init
const { json } = require('body-parser');
const {initializeApp, applicationDefault, cert} = require('firebase-admin/app');
const {getFirestore, Timestamp, FieldValue} = require('firebase-admin/firestore');
const serviceAccount = require('./serviceAccountKey.json');


class Firebase{
    constructor(){
        //firebase init
        initializeApp({
            credential: cert(serviceAccount)
        });
        this.db = getFirestore();
    }

    //put all user into firestore
    saveData = async (data) => {
        try{
            for(var dataIndex = 0; dataIndex < data.length; dataIndex++){
                var message = data[dataIndex]['message'];
                var text = message['text'];
                var date = message['created_at'];

                var user = message['user'];
                console.log('===================');
                console.log(user);
                console.log('===================');
                console.log(text);
                console.log('===================');
                console.log(date);

                
                var save = this.db.collection('save').doc(user['id']).collection('save').doc(text+"_"+date);
                const item = {
                    'text': text,
                    'date': date,
                    'user': user['id'],
                };
                await save.set(item);
            }
            return true;
        }
        catch(e){
            return false;
        }
    }


    //write account infomation to firestore
    saveAccount = async (json) => {
        try{
            var save = this.db.collection('account').doc(json['email']);
            await save.set({
                'userId': json['userId'],
                'name': json['name'],
                'email': json['email'],
            });
            return true;
        }
        catch(e){
            return false;
        }
    }

    //read account infomation from firestore
    readAccount = async (email) => {
        var json;
        try{
            var read = this.db.collection('account').doc(email);
            await read.get().then((result) => {
                //console.log(result);
                json = result;
            });
            const userData = {
                'email': json['_fieldsProto']['email']['stringValue'],
                'name': json['_fieldsProto']['name']['stringValue'],
                'id': json['_fieldsProto']['userId']['stringValue'],
            };
            return userData;
        }
        catch(e){
            console.log(e);
            const failData = {
                'result': 'failed',
                'reason': e,
            };
        }
    }
}



exports.firebase = new Firebase();

