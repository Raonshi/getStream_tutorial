//stream_chat init
const StreamChat = require('stream-chat').StreamChat;

class Chat{
    constructor(apiKey, secret){
        this.client = new StreamChat('grdysyd7gzfn', 'mf5fnujjbt43rgepwh47h8ccp6r6c54vnrgh9sgn337ce3y4nnq3jxnv88bedanh');

        //this.firebaseConfig();
    }

    //firebase module configration
    firebaseConfig = async () => {
        await this.client.updateAppSettings({
            firebase_config: {
                server_key: 'AAAA4Gtxo8k:APA91bHSJ_PikJfY4U1NGsqp-lGK3vArTFNb_1SId3M0KHQGagBRmaVBcs0JZSW6BMWWbnT-GmYBrNAmWUynjA6oiTS5mioXFTED6e0Lz6SFVFLVfKLrFkr3m64aO2R-bRaDnNmKDzG9',
                notification_template: `{
                    "message":{
                        "notification":{
                            "title":"New messages",
                            "body":"You have {{ unread_count }} new message(s) from {{ sender.name }}"
                        },
                        "android":{
                            "ttl":"86400s",
                            "notification":{
                                "click_action":"OPEN_ACTIVITY_1"
                            }
                        }
                    }
                }`,
                data_template: `{
                    "sender":"{{ sender.id }}",
                    "channel":{
                        "type": "{{ channel.type }}",
                        "id":"{{ channel.id }}"
                    },
                    "message":"{{ message.id }}"
                }`,
            },
        });
    }

    

    //generate your new command
    createNewCommand = async (commandName) => {
        const response = await this.client.listCommands();
        const commands = response['commands'];

        var isNew = true;

        for(var i = 0; i < commands.length; i++){
            const command = commands[i];
            if(command['name'] == commandName){
                console.log('Command already exist');
                isNew = false;
                break;
            }
        }

        if(isNew){
            await this.client.createCommand({
                name: commandName,
                description: 'Save chat message contains keyword',
                set: 'support_commands_set',
                arg: '[description]'
            });
        }

        const type = (await this.client.getChannelType('messaging')).commands;

        for(var i = 0; i < type.length; i++){
            const name = type[i].name;
            if(name == 'save'){
                console.log('Command already exist');
                return;
            }
        }

        await this.client.updateChannelType('messaging', {
            commands: ['save'],
        });        
        /*
        await this.client.updateAppSettings({ 
            custom_action_handler_url: "http://def0-121-134-227-161.ngrok.io/"+commandName, 
        });
        */

        console.log(type);
    }
}

exports.chat = new Chat();