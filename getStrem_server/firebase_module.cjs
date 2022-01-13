//firebase init
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
            var saveData = data['messages'];
        
            for(var i = 0; i < saveData.length; i++){
                var text = saveData[i]['text'];
                var date = saveData[i]['created_at'];

                if(text.match('D')){
                    console.log(text);
                    var user = data['user'];

                    //저장일자는 메시지가 전송된 시간으로 저장해야함
                    //지금은 코드가 수행되는 시점의 현재시간으로 되어 있음.
                    var save = this.db.collection(user['id']).doc('save_'+date);
                    await save.set({
                        'text': text
                    });
                }
            }
            return true;
        }
        catch(e){
            return false;
        }
    }

    saveAccount = async (json) => {
        try{
            var save = this.db.collection('account').doc(json['userId']);
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
}



exports.firebase = new Firebase();

