let isPlayerSelected = false;
let playeridSelect = null;

window.addEventListener("message",function(event) {
    if(event.data.action === 'selectMenu') {
        let players = event.data.players;

        if(players.length === 2)  $('.create-player').addClass('disable-button');
    
        for (const data of players) {
            let html = `<div data-playerid = "${data.id}" class ="button selection">${data.name} ${data.lastName}</div>`;
            $('.create-player').before(html);
        }
    
        $('.selection').click(function(event){
            if($(this).data('playerid') != playeridSelect) {
                isPlayerSelected = true;
                playeridSelect = $(this).data('playerid');
        
                $('.play').removeClass('disable-button');
                $.post('https://core/selectPlayer', JSON.stringify({playeridSelect: playeridSelect}));
            }
        });
    }
});


$('.play').click(function(event){
    if(isPlayerSelected) {
        $.post('https://core/loadPlayer', JSON.stringify({playeridSelect: playeridSelect}));
        $(".main-selector").addClass('hidden');
    }
});

$('.player').click(function(event){
    let playerSelector = $('.players-selector');
    
    if(playerSelector.hasClass('hidden')) {
        playerSelector.removeClass('hidden');
    }
    else{
        playerSelector.addClass('hidden');
    }
});

$('.create-player').click(function(event){
    $(".main-selector").addClass('hidden');
    $(".register-player").removeClass('hidden');
});