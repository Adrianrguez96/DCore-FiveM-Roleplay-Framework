
window.addEventListener('message', event => {
    let item = event.data;

    if(item.message !== undefined && item.type === 'notification') { 
        let element = $(`<div class = "body-message ${item.typeMessage}"><i class='${item.typeMessage}-icon'></i><span class ="text-message">${item.message}</span></div>`);
        $('.notifications').prepend(element);
        
        setTimeout(() => {
            $(element).remove();
        }, item.time);
    }

    if(item.type === 'notification-above') { 
        if (item.message !== undefined)
        {
            $('.above-notifications').html(item.message)
            $('.above-notifications').show();
        } else {
            $('.above-notifications').hide();
        }
    }
});