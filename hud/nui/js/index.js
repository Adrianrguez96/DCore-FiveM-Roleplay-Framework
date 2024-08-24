import PlayerHud from "./playerhud.js";
import VehicleHud from "./vehicleHud.js";

const playerHud = new PlayerHud();
const vehicleHud = new VehicleHud();

window.addEventListener("message", (event) => {
  if (!event.data.showHud) {
    switch (event.data.action) {
      case "updateStatus": {
        playerHud.updateStatus(event.data);
        break;
      }
      case "setVoiceDistance": {
        playerHud.setVoiceDistance(event.data);
        break;
      }
      case "isTalking": {
        playerHud.isTalking(event.data);
        break;
      }
      case "enableVehicleHud": {
        vehicleHud.enableVehicleHud(event.data);
        break;
      }
      case "disableVehicleHud": {
        vehicleHud.disableVehicleHud(event.data);
        break;
      }
      case "updateLocation": {
        vehicleHud.updateLocation(event.data);
        break;
      }
      case "setSeatbelt": {
        vehicleHud.setSeatBelt(event.data);
        break;
      }
    }
    $(".main-hud").removeClass('hidden');
  } else {
    $(".main-hud").addClass('hidden');
  }
});
