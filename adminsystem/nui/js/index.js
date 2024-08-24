let targetid = null;
let firstValue = null;

window.addEventListener("message", (event) => {
    let data = event.data
    switch(data.status) {
        case 'openPanel': {
            $('.main-adminpanel').removeClass('hidden');
            $('.home').removeClass('hidden');
            $('.online').text(data.result.onlinePlayers);
            $('.registerUsers').text(data.result.totalRegisters);
            break;
        }
    }
});

function DialogPrompt()  {
    this.render = (dialog,dialogid,type = null) => {
        $('.info-dialog').text(dialog);
        $('.dialog-panel').removeClass('hidden');
        let html = `
        <button class="btn-style" onclick="prompt.accept('${dialogid}','${type}')">Aceptar</button>
        <button class="btn-style" onclick="prompt.cancel()">Cancelar</button>
        `
        $('.button-dialog').html(html)
    }

    this.cancel = () => {
        $('.dialog-panel').addClass('hidden');
        $('#prompt-value').val('');
    }

    this.accept = (dialogid,type) => {

        let value = $('#prompt-value').val().trim();

        if(value === '') {
            this.errorDialog('Debe escribir algun valor en el cuadro');
            return false;
        }

        switch (type) {
            case 'number': {
                let isNumber=/^[0-9]+$/;
                if(!value.match(isNumber)) {
                    this.errorDialog('Solo se aceptan valores númericos');
                    return false;
                }
                break;
            }
            case 'letter': {
                let isLetter = /^[a-zA-Z]+$/;
                if(!value.match(isLetter)) {
                    this.errorDialog('Solo se aceptan caracteres alfabeticos');
                    return false;
                }
            }
        }

        $('.dialog-panel').addClass('hidden');
        $('.error-input').addClass('hidden');
        $('#prompt-value').css('border-bottom-color', '#FFFFFF');
        $('#prompt-value').val('');
        DialogAccept(dialogid,value);
    }

    this.errorDialog = (message) => {
        $('#prompt-value').css('border-bottom-color', '#8E1600');
        $('.error-input').removeClass('hidden');
        $('.error-input').text(message);
    }
}
var prompt = new DialogPrompt()

function DialogAccept(dialogid,value) {
    switch(dialogid) {
        
        case 'setNewItemAmount': {
            firstValue = value;
            prompt.render('Diga la cantidad a poner','setPlayerItem');
            break;
        }

        default: {
            if (firstValue !== null) {
                value = {
                    first: firstValue,
                    second: value
                };
            }
            $.post('https://adminsystem/' + dialogid, JSON.stringify({targetsrc: targetid , value: value}));
        }
    }
}

$('.menu-adminpanel li').click (function(event){
    $('.main-body').addClass('hidden');
    let menuData = $(this).data('menu');
    $(menuData).removeClass('hidden');
});

$('[data-menu=".user"]').click(function(event) {
    $.post('https://adminsystem/getUsers', function(players){
        $('.online-players').empty()
        for (const player of players) {
            let html = '<tr data-playerid ="' + player.playerid + '" data-serverid = "' + player.serverid + '"><td>' + player.serverid + 
            '</td><td>' + player.userName + 
            '</td><td>' + player.playerName.name + ' ' + player.playerName.lastName + 
            '</td><td>' + player.discordid.replace('discord:','') + '</td></tr>';
            $('.online-players').append(html);
        }
    });
});

$('.left-lateral-nolinear > button').click(function(event) {
    let buttonid = $(event.target).attr('id');

    switch (buttonid) {
        default: {
            $.post('https://adminsystem/' + buttonid, JSON.stringify({targetsrc: targetid}))
            break;
        }
    }
})

$('.online-players').on('click','tr td', function(event) {

    let playerid = $(event.target).parent().data('playerid');
    let src = $(event.target).parent().data('serverid');

    $.post('https://adminsystem/getPlayerData',JSON.stringify({playerid: playerid, src: src}),function(data){ 

        targetid = data.serverid;

        $('.player-data > .body-header h1').text(`Panel de administración - ${data.playerName.name} ${data.playerName.lastName} (${data.steamName})`)

        $('.server-id').text(targetid);
        $('.steam-name').text(data.steamName);
        $('.discord-identifier').text(data.discordid.replace('discord:',''));

        $('.player-name').text( `${data.playerName.name} ${data.playerName.lastName}`);
        $('.player-birthday').text(data.birthday);
        $('.player-main-job').text (`${data.job.whitelistJob} // ${data.job.rank}`);
        $('.player-money').text(`${data.money}$`)

        $('.user').addClass('hidden');
        $('.player-data').removeClass('hidden');
    });
});

const UpdateItemTable = () => {
    $('.table-inventory').empty();
    $.post('https://adminsystem/showInventory', JSON.stringify({src: targetid}), function(items){
    
        $('.player-inventory > .body-header h1').text(`Panel de administración - Inventario de ${$('.player-name').text()}`)

        for (const item of items) {
            if (item.name !== undefined) {
                let html = '<tr data-hash="'+ item.hashName +'"><td>' + item.name + 
                '</td><td>' + item.weight + 
                '</td><td>' + item.amount +
                '</td><td><button class="btn-small btn-green btn-addinv" onclick="prompt.render(\'Indique la cantidad del item a poner\',\'addAmountItem\')\"><i class="fas fa-plus"></i></button><button class="btn-small btn-red btn-delinv"><i class="fas fa-trash"></i></button></td></tr>';
                $('.table-inventory').append(html);              
            }
        }
    });
}

const UpdateVehicleTable = () => {
    $('.table-vehicles').empty();
    $.post('https://adminsystem/showVehicles', JSON.stringify({src: targetid}), function(vehicles){
    
        $('.player-vehicles > .body-header h1').text(`Panel de administración - Vehículos de ${$('.player-name').text()}`)
        for (const vehicle of vehicles) {
            if (vehicle.model !== undefined) {
                let html = '<tr data-vehicleid="'+ vehicle.id +'"><td>' + vehicle.id + 
                '</td><td>' + vehicle.model + 
                '</td><td>' + vehicle.meta.plate +
                '</td><td><button class="btn-small btn-green btn-addinv"><i class="fas fa-plus"></i></button><button class="btn-small btn-red btn-delinv"><i class="fas fa-trash"></i></button></td></tr>';
                $('.table-vehicles').append(html);              
            }
        }
    });
}

const UpdateSantionsTable = () => {
    $('.table-santions').empty();
    $.post('https://adminsystem/showSantions', JSON.stringify({src: targetid}), function(santions){
    
        $('.player-vehicles > .body-header h1').text(`Panel de administración - Sanciones de ${$('.player-name').text()}`)

        for (const santion of santions) {
            if (vehicle.model !== undefined) {
                let html = '<tr data-vehicleid="'+ vehicle.id +'"><td>' + vehicle.id + 
                '</td><td>' + vehicle.model + 
                '</td><td>' + vehicle.meta.plate +
                '</td><td><button class="btn-small btn-green btn-addinv"><i class="fas fa-plus"></i></button><button class="btn-small btn-red btn-delinv"><i class="fas fa-trash"></i></button></td></tr>';
                $('.table-vehicles').append(html);              
            }
        }
    });
}

const UpdateTickets = () => {
    $.post('https://adminsystem/getTickets', function(tickets){
        $('.table-tickets').empty()
        for (const ticket of tickets) {
            let html = '<tr data-ticketid ="'+ ticket.ticketid +'">><td>' + ticket.ticketid + 
            '</td><td>' + ticket.user + 
            '</td><td>' + ticket.attendFor+ 
            '</td><td style="font-size: 0.7em;">' + ticket.msg + 
            '</td><td><button class="btn-small btn-green btn-attendrep"><i class="fas fa-check"></i></button><button class="btn-small btn-red btn-delrep"><i class="fas fa-trash"></i></button></td></tr>';
            $('.table-tickets').append(html);
        }
    });
}

$('.watch-inventory').click(function(event) {
    UpdateItemTable();

    $('.player-data').addClass('hidden');
    $('.player-inventory').removeClass('hidden');
});

$('.watch-vehicles').click(function(event) {
    UpdateVehicleTable();

    $('.player-data').addClass('hidden');
    $('.player-vehicles').removeClass('hidden');
});

$('.watch-santions').click(function(event) {
    UpdateSantionsTable();

    $('.player-data').addClass('hidden');
    $('.player-santions').removeClass('hidden');
});

 $('body').on('click', '.btn-delinv', function(event) {
    let hashNameItem = $(event.target).parents("tr").data('hash');
    $.post('https://adminsystem/deleteItem', JSON.stringify({src: targetid, hashName: hashNameItem}),function(){
        UpdateItemTable();
    });
 });

 $('body').on('click', '.btn-attendrep', function(event) {
    let ticketid = $(event.target).parents("tr").data('ticketid');
    $.post('https://adminsystem/attendrep', JSON.stringify({ticketid: ticketid}),function(){
        UpdateTickets();
    });
 });

 $('body').on('click', '.btn-delrep', function(event) {
    let ticketid = $(event.target).parents("tr").data('ticketid');
    $.post('https://adminsystem/delrep', JSON.stringify({ticketid: ticketid}),function(){
        UpdateTickets();
    });
 });
 

$('.btn-return').click(function(event){
    $('.player-inventory').addClass('hidden');
    $('.player-vehicles').addClass('hidden');
    $('.player-santions').addClass('hidden');
    $('.player-data').removeClass('hidden');
});

$('[data-menu=".faction"]').click(function(event) {
    $.post('https://adminsystem/getJobs', function(jobs){
        $('.server-jobs').empty();
        for (const job of jobs) {
            let html = '<tr data-hash ="' + job.hash + '"><td>' + job.name + 
            '</td><td>' + job.jobAccount + 
            '</td><td>' + '20' + '</td></tr>';
            $('.server-jobs').append(html);
        }
    });
});

$('.server-jobs').on('click','tr td', function(event) {

    let hashName = $(event.target).parent().data('hash');
    console.log(hashName)

    $.post('https://adminsystem/getJobData',JSON.stringify({hashName : hashName}),function(data){ 

        $('.faction-data > .body-header h1').text(`Panel de administración - ${data.name}`)

        $('.faction-id').text(data.id);
        $('.faction-name').text(data.name);
        $('.faction-money').text(`${data.jobAccount}$`);

        $('.faction').addClass('hidden');
        $('.faction-data').removeClass('hidden');
    });
});

$('[data-menu=".tickets"]').click(function(event) {
    UpdateTickets();
});


document.onkeyup = function(data) {
    if (data.which == 27) 
    {
        $('.main-adminpanel').addClass('hidden');
        $('.main-body').addClass('hidden');
        $('.home').removeClass('hidden');
        $.post('https://adminsystem/exit', JSON.stringify({}));
    }
}