var app = new Vue({
   el: '#app',
   data:{
      titulo:"Rotas de Trabalho" ,
      show: false,
      rotas: [
         { nome: "Lavagem Dinheiro", police: 5, valor_suborno: 5000},
         { nome: "Rota de Armas", police: 5, valor_suborno: 5000},
         { nome: "Rota de Eletrônicos", police: 5, valor_suborno: 5000},
      ],
      tipoRota:[
         {nome:'norte'},
         {nome:'sul'}
      ],
   }
})

function confirmarSuborno(r,i){
   Swal.fire({
      title: 'Tem certeza que deseja subornar a Polícia?',
      text: "1 Estrela por R$ " + r.valor_suborno,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#F00',
      confirmButtonText: 'SIM'
    }).then((result) => {
      if (result.isConfirmed) {

         fetch('http://monkey_rotanortesul/pagarSuborno', { method: 'POST', body: JSON.stringify(r) })
         .then(function(response) {
            return response.json();
         })
         .then(function(data) {

            if(data.pagamento == true) {

               app.rotas[i].police =  app.rotas[i].police -1

               Swal.fire(
                  'Subornado com sucesso!',
                  data.msg,
                  'success'
               )
            } else {
               Swal.fire(
                  'Para subornar tem de ter o que oferecer!',
                  data.msg,
                  'error'
               )
            }
           
         }).catch(function() {

         })

      }
    })
}


document.addEventListener('DOMContentLoaded', function () {
   document.onkeyup = function (data) {
      if (data.which == 27) {
         sair()
      }
   }
})

function sair() {
   app.show = false
   $.post('http://monkey_rotanortesul/sair')
}

function iniciar(e){
   if(e == 'norte'){
      $.post('http://monkey_rotanortesul/iniciarRotaNorte')
      sair()
   }else if( e == 'sul'){
      $.post('http://monkey_rotanortesul/iniciarRotaSul')
      sair()
   }
}

function setarTipoRota(rota_s) {
   $.post('http://monkey_rotanortesul/setarRota', JSON.stringify(rota_s))

   // $('.tipo_rota').removeClass("ativado")
   // $('.' + tipo_rota).addClass("ativado")

   Swal.fire(
      'Rota de ' + rota_s.nome + ' Selecionada!',
      'Bora trabalhar, seleciona norte ou sul!',
      'success'
   )
}


window.addEventListener("message",(event)=>{
   let data = event.data
   app.show = data.show
   app.rotas = data.rotas
})