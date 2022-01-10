//stream_chat init
const StreamChat = require('stream-chat').StreamChat;

class Chat{
    constructor(apiKey, secret){
        this.client = new StreamChat('grdysyd7gzfn', 'mf5fnujjbt43rgepwh47h8ccp6r6c54vnrgh9sgn337ce3y4nnq3jxnv88bedanh');
        //init custom command
        this.createNewCommand('save');
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

        console.log(type);
    }
}

exports.chat = new Chat();