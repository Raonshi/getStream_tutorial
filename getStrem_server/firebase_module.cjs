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
            for(var i = 0; i < data.length; i++){
                var message = data[i]['message'];
                var text = message['text'];
                var date = message['created_at'];

                var user = message['user'];
                console.log(user);

                //저장일자는 메시지가 전송된 시간으로 저장해야함
                //지금은 코드가 수행되는 시점의 현재시간으로 되어 있음.
                var save = this.db.collection(user['id']).doc('save_'+date);
                await save.set({
                  'text': text,
                  'date': date,
                  'user': user['id'],
                });
            }
            return true;
        }
        catch(e){
            return false;
        }
    }

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
        }
    }
}



exports.firebase = new Firebase();

