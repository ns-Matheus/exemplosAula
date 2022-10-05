var app = new Vue({
   el: '#app',
   data: {
      show_vue: false,
      show_icone: false,
      lista_vue: [],
      player_carros: [],
      nome_carro_vue: 0,
      valor_vue: 0,
      kg_vue: 0,
      pesquisa: null,
      cores_vue: [
         { r: 0, g: 0, b: 0 },
         { r: 169, g: 169, b: 169 },
         { r: 255, g: 255, b: 255 },
         { r: 255, g: 0, b: 0 },
         { r: 220, g: 20, b: 60 },
         { r: 199, g: 21, b: 133 },
         { r: 255, g: 20, b: 147 },
         { r: 255, g: 0, b: 255 },
         { r: 138, g: 43, b: 226 },
         { r: 102, g: 51, b: 153 },
         { r: 205, g: 92, b: 92 },
         { r: 255, g: 127, b: 80 },
         { r: 255, g: 192, b: 203 },
         { r: 255, g: 69, b: 0 },
         { r: 255, g: 140, b: 0 },
         { r: 255, g: 215, b: 0 },
         { r: 255, g: 255, b: 0 },
         { r: 240, g: 230, b: 140 },
         { r: 127, g: 255, b: 0 },
         { r: 0, g: 255, b: 0 },
         { r: 0, g: 160, b: 0 },
         { r: 0, g: 250, b: 154 },
         { r: 0, g: 255, b: 255 },
         { r: 25, g: 25, b: 112 },
         { r: 0, g: 0, b: 128 },
         { r: 0, g: 0, b: 205 },
      ]
   },
   watch: {
      pesquisa: function (event) {
         let valorPesquisa = event.toLowerCase()
         $(".menucarros .card_image").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(valorPesquisa) > - 1)
         })
      }
   }
})

var valida = true

document.addEventListener("DOMContentLoaded", function () {
   window.addEventListener("message", function (event) {
      var data = event.data
      valida = data.foco

      if (data.acao == true) {
         app.show_vue = true;
         app.lista_vue = data.carros;
      }
   })

   document.onkeyup = function (data) {
      if (data.which == 27) {
         sair()
      }

      if (data.which == 70) {
         if (valida != false) {
            app.show_icone = true
            tecladoOn()
         } else {
            app.show_icone = false
            valida = true
            tecladoOff()
         }
      }
   }
})

function mostrarCarro(carro) {
   app.nome_carro_vue = carro.nome
   app.valor_vue = carro.preco
   app.kg_vue = carro.kg

   fetch("http://monkey_concessionaria/mostrarCarro", {
      method: 'POST',
      body: JSON.stringify({ 
         nome: carro.nome 
      })
   })
}

function mudarCor(cor) {
   fetch("http://monkey_concessionaria/mudarCor", {
      method: 'POST',
      body: JSON.stringify(cor)
   })
}

function abrirPortas() {
   fetch("http://monkey_concessionaria/abrirPortas", {
      method: 'POST'
   })
}

function fecharPortas() {
   fetch("http://monkey_concessionaria/fecharPortas", {
      method: 'POST'
   })
}

function testeDrive() {
   app.show_vue = false

   fetch("http://monkey_concessionaria/testeDrive", {
      method: 'POST',
      body: JSON.stringify({ 
         nome: app.nome_carro_vue
      })
   })
}

function comprarCarro() {
   fetch("http://monkey_concessionaria/comprarCarro", {
      method: 'POST',
      body: JSON.stringify({
         nome: app.nome_carro_vue,
         preco: app.valor_vue
      })
   }).then(function (response) {
      return response.json()
   }).then(function (json) {
      app.nome_carro_vue = json.nome
      app.valor_vue = json.preco
   })
}

function tecladoOn() {
   fetch("http://monkey_concessionaria/tecladoOn", {
      method: 'POST'
   })
}

function tecladoOff() {
   fetch("http://monkey_concessionaria/tecladoOff", {
      method: 'POST'
   })
}

function getCarrosPlayer() {
   $('#modalMeusCarros').modal('show')
   toggleLoading(true)

   fetch("http://monkey_concessionaria/getCarrosPlayer", {
      method: 'POST'

   }).then(function (response) {
      return response.json()

   }).then(function (json) {
      toggleLoading(false)
      app.player_carros = json

   }).catch(function (json) {
      toggleLoading(false)
   })
}

function fecharModal() {
   $('#modalMeusCarros').modal('hide')
}

function sair() {
  app.show_vue = false
  fecharModal()

   fetch("http://monkey_concessionaria/sair", {
      method: 'POST'
   })
}

function btnTransferir(carro, index) {
   let veiculo = carro.nomeCarro
   let placa = carro.placaCarro
   let detido = carro.carroDetido

   Swal.fire({
      icon: 'warning',
      title: 'Transferir veículo',
      text: "Informe a identidade",
      input: 'text',
      inputPlaceholder: 'Identidade',
      showCancelButton: true,
      confirmButtonText: 'Confirmar',
      cancelButtonText: 'Cancelar',
      inputValidator: (value) => {
         if (!$.isNumeric(value)) {
            return 'Identidade inválida!'
         }
      }
   }).then(res => {
      let id = res.value

      if (res.isConfirmed) {
         fetch("http://monkey_concessionaria/carroTransfer", {
            method: 'POST',
            body: JSON.stringify({
               vehicle: veiculo,
               plate: placa,
               detained: detido,
               idUser: id
            }),
         })
         
         app.player_carros.splice(index, 1)
         
         Swal.fire({
            icon: 'success',
            title: 'Tranferência bem sucedida!'
         })
      }
   })
}

function btnVender(carro, index) {
   let veiculo = carro.nomeCarro
   let placa = carro.placaCarro
   let valor = carro.valor

   Swal.fire({
      icon: 'warning',
      title: 'Vender veículo?',
      showCancelButton: true,
      confirmButtonText: 'Confirmar',
      cancelButtonText: 'Cancelar'

   }).then(res => {
      if (res.isConfirmed) {
         fetch("http://monkey_concessionaria/carrosVenda", {
            method: 'POST',
            body: JSON.stringify({
               vehicle: veiculo,
               plate: placa,
               sell: valor
            })
         })

         app.player_carros.splice(index, 1)
         
         Swal.fire({
            icon: 'success',
            title: 'Venda bem sucedida!'
         })
      }
   })
}

function toggleLoading(show) {
   if (show) {
      $(".loadingContent").addClass('d-block')
   } else {
      $(".loadingContent").removeClass('d-block')
   }
}

function imageError(e) {
   e.target.src = 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png'
}