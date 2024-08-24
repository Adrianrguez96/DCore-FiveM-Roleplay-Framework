$('.register-form').submit(function(event){
    event.preventDefault();
    $('input').css('border-bottom-color', '');

    let nameValue = $('#name').val().trim();
    let genderValue = $('input[name="gender"]:checked').val()
    let birthdayValue = $('#birthday').val();
    let heightValue = $('#height').val().trim();

    if (nameValue == "" || genderValue == "" || birthdayValue == "" || heightValue == "")
    {
        $('input:not(:last-child)').css('border-bottom-color', '#DF1010');
        errorMessage ("Error: Debes rellenar todos los campos para continuar");
        return;
    }

    if(!validateName(nameValue)) 
    {
        $('#name').css('border-bottom-color', '#DF1010');
        errorMessage ("Error: Debes poner un nombre y apellido validos");
        return;
    }

    if(!validateHeight(heightValue))
    {
        $('#height').css('border-bottom-color', '#DF1010');
        errorMessage ("Error: Debes poner una altura valida entre 140 y 210");
        return;
    }

    let name = nameValue.split(" ")[0];
    let lastName = nameValue.split(" ")[1];

    $('.register-player').addClass('hidden');
    $('.error-register').addClass('hidden');
    $.post('https://core/registerPlayer', JSON.stringify({
        name: name,
        lastName: lastName,
        gender: genderValue,
        birthday: birthdayValue,
        height: heightValue
    }));
});

function errorMessage (string) {
    $('.error-register').removeClass('hidden');
    $('.error-register').text(string);
}

function validateName(string) {
    var alpha = /^[a-zA-Z\s-, ]+$/;  
    if (!string.match(alpha)) {
        return false;
    }
    else {
        if (string.indexOf(' ') >= 0) return true;
        else return false;
    }
}

function validateHeight (number) {
    var numbers = /^[0-9]{3,4}$/
    if(!number.match(numbers)) {
        return false;
    }
    else {
        if (number <= 140 || number >= 210) return false;
        else return true;
    }
}