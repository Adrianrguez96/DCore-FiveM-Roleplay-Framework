window.addEventListener("message", (event) => {
    let data = event.data
    switch(data.status) {
        case 'openClotherShop': {
            $('.container').removeClass('hidden');
            break;
        }
    }
});

document.onkeyup = function(data) {
    if (data.which == 27) 
    {
        $('.container').addClass('hidden');
        $.post('https://shops/cancel', JSON.stringify({}));
    }
}

$(document).on('click', '.list .controls button', function(evt) {
  let list = $(this).siblings('select').first();
  let numOpt = list.children('option').length
  let oldVal = list.find('option:selected');
  let newVal = null;

  if ($(this).hasClass('left')) {
      if (list.prop('selectedIndex') == 0) {
          newVal = list.prop('selectedIndex', numOpt - 1);
      }
      else {
          newVal = oldVal.prev();
      }
  }
  else if ($(this).hasClass('right')) {
      if (list.prop('selectedIndex') == numOpt - 1) {
          newVal = list.prop('selectedIndex', 0);
      }
      else {
          newVal = oldVal.next();
      }
  }
  oldVal.prop('selected', false)
  newVal.prop('selected', true)
  newVal.trigger('change')
});

$(document).on('click', '.slider .controls button', function(evt) {
  let slider = $(this).siblings('input[type=range]').first();
  let min = parseInt(slider.prop('min'));
  let max = parseInt(slider.prop('max'));
  let val = parseInt(slider.val());

  if ($(this).hasClass('left')) {
      if (val > min) {
          slider.val(val - 1);
      }
  }
  else if ($(this).hasClass('right')) {
      if (val < max) {
          slider.val(val + 1);
      }
  }

  slider.trigger('input');
});
