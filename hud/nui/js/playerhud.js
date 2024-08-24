let diametre = 2 * Math.PI * 22;
const offsetCalculate = (percent, diametre) => {
  percent = percent >= 0 ? percent = percent : 0;
  return diametre - ((-percent * 100) / 100 / 100) * diametre;
};

export default class PlayerHud {
  updateStatus(data) {
    let health = Math.round(data.health);
    let armour = Math.round(data.armour);
    $('.health').css('stroke-dashoffset', offsetCalculate(health, diametre));
    $('.armour').css('stroke-dashoffset', offsetCalculate(armour, diametre));
    $('.hunger').css('stroke-dashoffset', offsetCalculate(data.hunger, diametre));
    $('.thirsty').css('stroke-dashoffset', offsetCalculate(data.thirsty, diametre));

    if(data.inWater == true)
    {
      $('.inWater').show();
      $('.oxygen').css('stroke-dashoffset', offsetCalculate(data.oxygenTime, diametre));
    } else {
      $('.inWater').hide();
    }
  }

  setVoiceDistance(data) {
    let distanceText;
    switch (data.voiceDistance) {
      case 0:
        distanceText = 'Normal';
        break;
      case 1:
        distanceText = 'Gritar';
        break;
      case 2:
        distanceText = 'Susurrar';
        break;
    }
    $('.text-microphone').html(distanceText);
  }

  isTalking(data) {
    return;
  }
}
