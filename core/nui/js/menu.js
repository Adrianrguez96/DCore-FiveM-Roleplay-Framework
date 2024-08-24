let options = [];
let typeMenuActive;

const renderMenu = (header,index) => {
    if(header) {
        return `
        <li><div class="not-skew" data-option-id = "${index}">${header}</div></li>
        `
    }
}

const closeMenu = () => {
    options = []
    $('.main-menu').addClass('hidden');
    $('.menu-options').html('');
    $.post('https://core/closeMenu', JSON.stringify({}));
}

const closeWheelNav = () => {
    $('.main-wheelnav').addClass('hidden');
    $('#wheelmenu').html('');
    $.post('https://core/closeMenu', JSON.stringify({}));
    delete wheelNav;
}

$('.menu-options').click(function(event){
    let target =$(event.target).data('option-id');
    $.post('https://core/clickedOption',JSON.stringify(options[target]));
    closeMenu();
});

$('.close-button').click(function(event){
    closeMenu();
});

window.addEventListener('message',function(event) {
    switch(event.data.action) {
        case 'OpenMenu': {
            typeMenuActive = 'Menu';

            let menu = event.data.options;
            let title = event.data.title;
            let html = '';
    
            menu.forEach((option,index) => {
                html += renderMenu(option.header,index)
                if (option.params) options[index] = option.params;
            });
            $('.menu-title').text(title);
            $('.menu-options').html(html);
            $('.main-menu').removeClass('hidden');
            break;
        }
        case 'OpenWheelNav': {
            typeMenuActive = 'WheelMenu';

            let menu = event.data.options;
            let html = '';

            menu.forEach((option,index) => {
                html +=  `<div data-wheelnav-navitemtext='${option.header}'></div>`;
            });
            
            $('#wheelmenu').html(html);
            $('.main-wheelnav').removeClass('hidden');

            var wheelNav = new wheelnav('wheelmenu');
            wheelNav.wheelRadius = wheelNav.wheelRadius * 0.83;
            wheelNav.selectedNavItemIndex = null;
            wheelNav.createWheel();
    
            for (let i = 0; i < wheelNav.navItems.length; i ++) {
                let eventData = menu[i].params;
                wheelNav.navItems[i].navSlice.mousedown(function () {
                    $.post('https://core/clickedOption', JSON.stringify(eventData));
                    closeWheelNav();
                });

                wheelNav.navItems[i].navTitle.mousedown(function () {
                    $.post('https://core/clickedOption', JSON.stringify(eventData));
                    closeWheelNav();
                });
            }
            wheelNav.refreshWheel();

            break;
        }
        case 'CloseWheelMenu': {
            closeWheelNav();
            break;
        }
    }
});

document.onkeyup = function (event) {
    if (event.key == 'Escape') {
        switch(typeMenuActive) {
            case 'Menu' : {
                closeMenu();
                break;
            }
            case 'WheelMenu': {
                closeWheelNav();
                break;
            }
        }
        typeMenuActive = null;
    }
};