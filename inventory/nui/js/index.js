let totalWeight = 0;
let selectTimer = null;
let slotSelect = null;


window.addEventListener('message', event => {

    let data = event.data;

    switch(data.status) {
        case 'openInventory': {
            UpdateInventory(data);
            $('.main-inventory-hud').removeClass('hidden');
            $('.main-inventory-selector').removeClass('hidden'); 
            $('.main-inventory-panel').removeClass('hidden');
            break;
        }
        case 'updateInventory': {
            UpdateInventory(data);
            break;
        }
        case 'selectItem': {
            $('.main-inventory-selector').removeClass('hidden');
            $('.main').css('border-color','');
            $(`[data-mainSlot=${data.mainSlotSelect}]`).css('border-color','#FFF');
            
            clearTimeout(selectTimer);
            selectTimer = setTimeout(function(){ 
                if($('.main-inventory-hud').hasClass('hidden')) {
                    $('.main-inventory-selector').addClass('hidden');
                    $(`[data-mainSlot=${data.mainSlotSelect}]`).css('border-color','');
                }
             }, 1500);
             break;
        }
        case 'busyHand': {
            break;
        }
        case 'loadInventory': {
            for (let slot = 0; slot < 5; slot++){
                if (data.items[slot] !== undefined && data.items[slot] !== null) {
                    $('.inventory-selector').append(`<div class= "main slot" data-id="${slot + 1}" style= "background-image:url('images/items/${data.items[slot].hashName}.png')">
                    <span class = "number-slot">${slot + 1}</span>
                    </div>`);
                }
                else {
                    $('.inventory-selector').append(`<div class= "main slot" data-id="${slot + 1}"><span class = "number-slot">${slot + 1}</span></div>`) 
                }
            }
            break;
        }
    }
})

window.addEventListener('contextmenu', (e) => {
    if ($(e.target).closest(".slot").length === 0) {
        $('.lateral-menu').addClass('hidden');
    }
  })

document.onkeyup = function(data) {
    if (data.which == 27) 
    {
        slotSelect = null;
        $('.main-inventory-hud').addClass('hidden');
        $('.main-inventory-selector').addClass('hidden');
        $('.lateral-inventory').addClass('hidden');
        $('.lateral-menu').addClass('hidden');
        $('.right-inventory').addClass('drop-item');
        $.post('https://inventory/exit', JSON.stringify({}));
    }
}

function UpdateInventory(data) {
    let secondInventory = data.secondInventory;
    totalWeight = 0;
    $('.inventory-selector').empty();
    $('.grid-inventory').empty();
    $('.lateral-grid-inventory').empty();

    for (let slot = 0; slot < 21; slot++){
        if (data.items[slot] !== undefined && data.items[slot] !== null) {
            if(slot < 5) {
                $('.inventory-selector').append(`<div class= "main slot" data-id="${slot + 1}" style= "background-image:url('images/items/${data.items[slot].hashName}.png')">
                <span class = "number-slot">${slot + 1}</span>
                </div>`);
            }
            else {
                $('.grid-inventory').append(`<div class= "slot" data-id="${slot + 1}" style= "background-image:url('images/items/${data.items[slot].hashName}.png')">
                <span class ="amount"></span>
                </div>`);
                $(`[data-id=${slot + 1}]`).html(`<span class ="amount">${data.items[slot].amount}</span>`);  
            }
            ChangeWeightData(data.items[slot].weight,data.items[slot].amount);
        }
        else {
            if(slot < 5) {
                $('.inventory-selector').append(`<div class= "main slot" data-id="${slot + 1}"><span class = "number-slot">${slot + 1}</span></div>`)
            }
            else {
                $('.grid-inventory').append(`<div class= "slot empty" data-id="${slot + 1}"><span class ="amount"></span></div>`)
            }
        }
    }

    if(secondInventory) {
        for (let slot = 0; slot < secondInventory.maxSlot; slot++) {
            $('.lateral-grid-inventory').append(`<div class= "slot empty" data-id-secondary-slot="${slot + 1}"><span class ="amount"></span></div>`);
        }
        let title = secondInventory.type === "Trunk" ? "Maletero" : "Guantera";
        $('.secondary-inv-title').text(title);
        $('.lateral-inventory').attr('data-secondinv',secondInventory.type);
        $('.lateral-inventory').removeClass('hidden');
    }
    ActiveDraggableSlots();
}

function ActiveDraggableSlots() {
    $('.slot').draggable({
        helper: "clone",
        appendTo: "body",
        scroll: false,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".empty",
        start: function(event, ui) {
            $(this).css("filter", "brightness(50%)");
            $(ui.draggable).css("background-color","blue");
            $(ui.helper).addClass("draggable-slot");
            $(ui.helper).empty();
        },
        stop: function() {
            $(this).css("filter", "brightness(100%)");
        },
    });
    
    $('.slot').droppable({
        drop: function(event, ui) {
            let targetSlot = $(this).data('id');
            let dragableSlot = $(ui.draggable).data('id');

            $.post('https://inventory/updateInventory', JSON.stringify({
                targetSlot: targetSlot,
                dragableSlot: dragableSlot
            }),function(item) {
                
                let dragableImage = $(`[data-id=${dragableSlot}]`).css('background-image');
                let targetImage = $(`[data-id=${targetSlot}]`).css('background-image');

                if (item.target !== undefined && item.draggable.hashName === item.target.hashName) {
                    $(`[data-id=${targetSlot}] > .amount`).text(item.draggable.amount + item.target.amount);
                    $(`[data-id=${dragableSlot}]`).removeAttr('style');
                    $(`[data-id=${dragableSlot}]`).addClass('empty');
                    $(`[data-id=${dragableSlot}] > .amount`).text('');
                }
                else {
                    $(`[data-id=${dragableSlot}] > .amount`).text(item.target === undefined ? '' : item.target.amount);
                    $(`[data-id=${targetSlot}] > .amount`).text(item.draggable.amount);
        
                    $(`[data-id=${targetSlot}]`).css("background-image",dragableImage);
                    $(`[data-id=${targetSlot}]`).removeClass('empty');
             
                    if(targetImage === 'none') {
                        $(`[data-id=${dragableSlot}]`).removeAttr('style');
                        $(`[data-id=${dragableSlot}]`).addClass('empty');
                    }
                    else {
                        $(`[data-id=${targetSlot}]`).css("background-image",dragableImage);
                        $(`[data-id=${dragableSlot}]`).css("background-image",targetImage);
                    }
                }
            });
        },
    });
}

$('.give-item').droppable({
    drop: function(event,ui) {
        console.log("Funcion dar objeto")
    }
})

$('.drop-item').droppable({
    drop:function(event,ui) {
        let slot = $(ui.draggable).data('id');
        $.post('https://inventory/throwItem',JSON.stringify({slot: slot}));
    }
})

//Divide items
$(document).on('contextmenu','.slot', function(event){
    slotSelect = $(this).data('id');
    if ($(`[data-id=${slotSelect}]`).css('background-image') != 'none') {
        $('.lateral-menu').removeClass('hidden');
    }
    else {
        $('.lateral-menu').addClass('hidden');
    }
});

$('.btn-divided').click(function(){  
    let divided = parseInt($(".text-divided").val());

    $('.lateral-menu').addClass('hidden');
    $.post('https://inventory/divideItem',JSON.stringify({
        slot: slotSelect ,
        dividedSlot : divided
    }));

    slotSelect = null;
});


function ChangeWeightData(itemWeight,itemAmount) {
    totalWeight += Math.round(itemWeight*itemAmount);
    let percentaje = Math.round((totalWeight*100)/120);
    $('.weight-number').text(`${totalWeight}/120 kg`);
    $('.weight-bar-complete').css("width",`${percentaje}%`);
}