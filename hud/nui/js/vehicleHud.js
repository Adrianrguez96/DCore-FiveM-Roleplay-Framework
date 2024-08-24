export default class vehicleHud {
  constructor() {
    this.temporalSpeed = 0;
    this.audioSeatBelt = null;
  }

  enableVehicleHud(data) {
    $(".main-car").show();
    $(".main-gps").show();
    $(".speed-number").html(Math.round(data.speed));
  }
  disableVehicleHud(data) {
    $(".main-car").hide();
    $(".main-gps").hide();
  }
  updateLocation(data) {
    $(".compass").html(data.direction);
    $(".street").html(data.streetName);
    $(".zone").html(data.zoneName);
  }
  setSeatBelt(data) {
    let audioName;

    if (data.state) {
      $(".seatBelt-circle").css("stroke", "#FFF");
      audioName = "buckle";
    } else {
      $(".seatBelt-circle").css("stroke", "#881313");
      audioName = "unbuckle";
    }

    if (this.audioSeatBelt != null) {
      this.audioSeatBelt.pause();
    }
    this.audioSeatBelt = new Audio("./sounds/" + audioName + ".ogg");
    this.audioSeatBelt.volume = 0.8;
    this.audioSeatBelt.play();
  }
}
