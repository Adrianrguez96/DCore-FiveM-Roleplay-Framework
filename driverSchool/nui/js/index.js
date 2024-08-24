let numberAnswer = 0;
let correctAnswer = 0;
let answers = ["control_01","control_05"]

window.addEventListener("message", (event) => {
    let data = event.data
    switch(data.status) {
        case 'openTheoricalTest': {
            $('.content').removeClass('hidden');
            break;
        }
        case 'notification': {
            let textIndication = event.data
            if (textIndication !== undefined) {
                
                let element = $(`
                <div class ="school-notifications">${textIndication.TextExam}</div>
                `);
                $('#main-notificacions').prepend(element);

                setTimeout (function() {
                    $(element).remove();
                }, 8000)
            }
        }
    }
});

$('.pass-buttom').click(function(event) {
    let page = $(this).data('page');
    $('.page').addClass('hidden');
    $(page).removeClass('hidden');
});

$('.test-btn').click(function(event) {
    if (!$('input[type=radio]:checked','#answer-' + (numberAnswer + 1)).is(":checked")) 
    {
        return 
    }
    let radioSelect = $('input[type=radio]:checked','#answer-' + (numberAnswer + 1)).attr('id');

    if(answers[numberAnswer] === radioSelect) {correctAnswer++;}
    let page = $(this).data('page');
    $('.page').addClass('hidden');
    $(page).removeClass('hidden');
    numberAnswer++;

    if(numberAnswer >= 2)
    {
        if (correctAnswer >= 1) {
            $('.test-part-final').html(`<h2>Has <span class="green">aprobado</span> el examen</h2>
            <p class ="final-text">Enhorabuena, acabas de aprobar el examen. Ahora vamos a continuar con la parte practica, el profesor le esperara fuera con un vehículo para realizar dicha prueba.</p>
            <p class="good-luck-text">¡¡Mucha suerte en la parte practica!!</p>
            <button class="bnt-finish pass-finish-test" type="button">Salir del test</buttom>
            `);
        }
        else {
            $('.test-part-final').html(`
            <h2>Has <span class="red">suspendido</span> el examen el examen</h2>
            <p class="final-text">Puedes volver a intentar el examen de nuevo pagando la tasas y leyendo bien el contenido teorico que se te da durante la clase.</p>
            <p class="good-luck-text">¡¡Mucha suerte en tú proximo intento!!</p>
            <button class="bnt-finish fail-finish-test" type="button">Salir del test</buttom>
            `);
        }
    }
});

$(document).on('click', '.fail-finish-test', function(){
    $('.content').addClass('hidden');
    $('.test-part-final').addClass('hidden');
    $('.introduction-part').removeClass ('hidden');
    
    numberAnswer = 0;
    correctAnswer = 0;
    $.post('https://driverSchool/finishTest', JSON.stringify({approved: false}));
});

$(document).on('click', '.pass-finish-test', function(){
    $('.content').addClass('hidden');
    $('.test-part-final').addClass('hidden');
    $('.introduction-part').removeClass ('hidden');
    numberAnswer = 0;
    correctAnswer = 0;
    $.post('https://driverSchool/finishTest', JSON.stringify({approved: true}));
});