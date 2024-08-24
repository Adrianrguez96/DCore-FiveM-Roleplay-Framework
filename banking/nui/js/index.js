window.addEventListener("message", (event) => {
    let data = event.data
    switch(data.status) {
        case 'openBanking': {
            $('.main-banking').removeClass('hidden');
            break;
        }
    }
});

$('.banking-menu li').click (function(event){
    $('.body-banking').addClass('hidden');
    let menuData = $(this).data('menu');

    if(menuData == '.exit') {
        $('.main-banking').addClass('hidden');
        $('.home').removeClass('hidden');
        $.post('https://banking/close', JSON.stringify({}));
        return;
    } 

    $(menuData).removeClass('hidden');
});