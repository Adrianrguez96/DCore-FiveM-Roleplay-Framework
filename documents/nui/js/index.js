window.addEventListener("message",function(event) {
    let data = event.data;

    switch(data.action) {
        case 'idcard': {
            $('.number-id').text(`ID${data.meta.idNumber}`);
            $('.name-id').text(data.meta.name);
            $('.sex-id').text(data.meta.sex == "male" ? "M" : "F");
            $('.birthday-id').text(data.meta.birthday);
            $('.signature').text(data.meta.name);
            $('.expedition-id').text(data.meta.expedition);
            $('.id-card').removeClass('hidden'); 
            break;
        }
        case'licenseCard': {
            $('.license-card').removeClass('hidden');
            break; 
        }
        case 'close': {
            $('.id-card').addClass('hidden'); 
            $('.license-card').addClass('hidden'); 
            break;
        }
    }
})
