$('.modal-form').html('<%= escape_javascript( render partial: 'logs/form', locals: {} ) %>')
$('#modal-form').modal()
