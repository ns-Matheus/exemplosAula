var app = new Vue({
    el: '#app',
    data:{
       titulo:"Selecione um modelo de roupa" ,
       show: true,
       lista_roupa: [
        {nome: "roupa numero 1"},
        {nome: "roupa numero 2"},
        {nome: "roupa numero 3"},
        {nome: "roupa numero 4"},
        {nome: "roupa numero 5"},
        {nome: "roupa numero 6"},
        {nome: "roupa numero 7"},
        {nome: "roupa numero 8"},
        {nome: "roupa numero 9"},
        {nome: "roupa numero 10"},
        {nome: "roupa numero 11"},
        {nome: "roupa numero 12"},
        {nome: "roupa numero 13"},
        {nome: "roupa numero 14"},
        {nome: "roupa numero 15"},
        {nome: "roupa numero 10"},
        {nome: "roupa numero 11"},
        {nome: "roupa numero 12"},
        {nome: "roupa numero 13"},
        {nome: "roupa numero 14"},
        {nome: "roupa numero 15"},
        {nome: "roupa numero 10"},
        {nome: "roupa numero 11"},
        {nome: "roupa numero 12"},
        {nome: "roupa numero 13"},
        {nome: "roupa numero 14"},
        {nome: "roupa numero 15"},
        {nome: "roupa numero 10"},
        {nome: "roupa numero 11"},
        {nome: "roupa numero 12"},
        {nome: "roupa numero 13"},
        {nome: "roupa numero 14"},
        {nome: "roupa numero 15"},
       ]
    }
 })

 $('.close_css').click(function(event){
    $('#alert').fadeOut();
    event.preventDefault();
    app.show = false
});

window.addEventListener("message",(event)=>{
   let data = event.data
   app.show = data.show
   app.rotas = data.rotas
})


function sair() {
   app.show = false
   $.post('http://monkey_outfit/sair')
}

document.addEventListener('DOMContentLoaded', function () {
   document.onkeyup = function (data) {
      if (data.which == 27) {
         sair()
      }
   }
})
