var app = new Vue({
   el: '#app',
   data:{
      titulo:"Rotas de Trabalho" ,
      ver: false,
      rotas: [
      {nome:'arma', icon:'fa-gun'}, 
      {nome:'lavagem', icon:'fa-money-bill-1-wave'}, 
      {nome : 'elêtronico', icon:'fa-microchip'},
      {nome:'plástico', icon: 'fa-sheet-plastic' },
   ],
      tipoRota:[
      {nome:'norte'},
      {nome:'sul'}
   ],
      verModal: false
   }
})

window.addEventListener("message",(event)=>{
   let data = event.data

   if (data.iniciarRota ===  true){
      app.ver = true
   }else{
      app.ver = false
   }
})

document.addEventListener('DOMContentLoaded', function(){
   document.onkeyup = function(data){
      if(data.which == 27){
         sair()
      }
   }
})


function sair(){
   app.ver = false
   app.verModal = false
   $.post('http://monkey_rotanortesul/sair')
}

function iniciar(e){
   if(e === 'norte'){
      $.post('http://monkey_rotanortesul/iniciarRotaNorte')
      sair()
   }else if( e === 'sul'){
      $.post('http://monkey_rotanortesul/iniciarRotaSul')
      sair()
   }
}

function setarTipoRota(tipo_rota) {
   $.post('http://monkey_rotanortesul/setarRota', JSON.stringify({tipo_rota : tipo_rota}))
   app.verModal = true
   $('.tipo_rota').removeClass("ativado")
   $('.'+tipo_rota).addClass("ativado")
}