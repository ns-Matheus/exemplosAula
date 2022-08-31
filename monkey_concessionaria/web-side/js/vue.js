var app = new Vue({
  el: '#app',
  data: {
    tituloModal: "Teste de Modal para Concessionaria",
    show_vue: true,
    show_icone: false,
    show_modal: false,
    lista_vue: [],
    player_carros: [],
    nome_carro_vue: 0,
    valor_vue: 0,
    kg_vue: 0,
    pesquisa: null,
    cores_vue: [

      { r: 25, g: 25, b: 112 },
      { r: 0, g: 0, b: 128 },
      { r: 0, g: 0, b: 205 },
      { r: 0, g: 255, b: 255 },
      { r: 0, g: 250, b: 154 },
      { r: 127, g: 255, b: 0 },
      { r: 0, g: 255, b: 0 },
      { r: 0, g: 160, b: 0 },
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
      { r: 169, g: 169, b: 169 },
      { r: 255, g: 255, b: 255 },
      { r: 0, g: 0, b: 0 }
    ]
  },
  // Funcao filtro da barra de pesquisa
  watch: {
    pesquisa: function (event) {
      let valorPesquisa = event.toLowerCase()
      $(".menucarros_css .left_perspective_css").filter(function () {
        $(this).toggle($(this).text().toLowerCase().indexOf(valorPesquisa) > - 1)
      })
    }
  }
})


// =================================================
// Evento de chamada 
// =================================================
var valida = true

document.addEventListener("DOMContentLoaded", function () {
  window.addEventListener("message", function (event) {
    var data = event.data

    valida = data.foco

    if (data.acao === true) {
      app.show_vue = true,
        app.lista_vue = data.carros
    }
    if (data.onModal != false) {
      app.show_modal = true
    }
  })

  document.onkeyup = function (data) {

    if (data.which == 27) {
      sair(false)
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


// =================================================
// Mostrar Carros 
// =================================================

function mostrarCarro(carro) {
  fetch("http://monkey_concessionaria/mostrarCarro", {
    method: 'POST',
    body: JSON.stringify({ nome: carro.nome })
  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}


// =================================================
// Mostrar Player Carro
// =================================================




function carroPlayer() {

  fetch("http://monkey_concessionaria/getCarrosPlayer", {
    method: 'POST',
    body: JSON.stringify({})
  }).then(function (response) {
    return response.json()
  }).then(function (data) {
    app.player_carros = data
  }).catch(function () {

  })
  /*
    fetch("http://monkey_concessionaria/carroPlayer", {
      method: 'POST'
    }).then((response) => {
      return response.json()
  
    }).then((data) => {
      console.log(JSON.stringify(data))
      app.player_carros = data
      console.log(app.player_carros[0].nomeCarro)
    }).catch((error) => {
      console.log(error)
    })
    */
}


// =================================================
// Mudar cor dos carros
// =================================================
function mudarCor(cor) {


  fetch("http://monkey_concessionaria/mudarCor", {
    method: 'POST',
    body: JSON.stringify(cor)
  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}

// =================================================
// Abrir as Portas do Carro
// =================================================


function abrirPortas() {

  fetch("http://monkey_concessionaria/abrirPortas", {
    method: 'POST'
  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}

// =================================================
// Fechar as Portas do Carro
// =================================================


function fecharPortas() {

  fetch("http://monkey_concessionaria/fecharPortas", {
    method: 'POST'
  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}



// =================================================
// Teste Drive do carro
// =================================================

function testeDrive() {

  app.show_vue = false

  fetch("http://monkey_concessionaria/testeDrive", {
    method: 'POST',
    body: JSON.stringify({ nome: app.nome_carro_vue })
  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {
    console.error()
  })
}

// =================================================
// Comprar o carro
// =================================================

function comprarCarro() {

  fetch("http://monkey_concessionaria/comprarCarro", {
    method: 'POST',
    body: JSON.stringify({ nome: app.nome_carro_vue, preco: app.valor_vue })
  }).then(function (response) {
    return response.json()
    console.log(response)
  }).then(function (json) {

  }).catch(function () {
    console.error()
  })
}

// =================================================
// TecladoOn ao clicar F para ativar modo visualização
// =================================================
function tecladoOn() {
  fetch("http://monkey_concessionaria/tecladoOn", {
    method: 'POST'

  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}

// =================================================
// TecladoOff ao clicar F para desativar modo visualização
// =================================================
function tecladoOff() {
  fetch("http://monkey_concessionaria/tecladoOff", {
    method: 'POST'

  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}

// =================================================
// modalOn 
// =================================================

function modalOn() {

  app.show_modal = false
  fetch("http://monkey_concessionaria/modalOn", {
    method: 'POST'
  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })

  Swal.fire({
    title: 'Carregando os carros da sua garagem!',
    timer: 2500,
    timerProgressBar: true,
    didOpen: () => {
      Swal.showLoading()
    }
  }).then(() => {
    carroPlayer()
  })

}

function fecharModal() {
  app.show_modal = true
  fetch("http://monkey_concessionaria/fecharModal", {
    method: "POST"
  }).then(function (response) {
    return response.json()
  }).then(function (json) {
    // retorno do objeto do CB
  }).catch(function () {
    // coisas caso der erro
  })

}

// =================================================
// tituloMostrar
// =================================================
function tituloMostrar() {


  fetch("http://monkey_concessionaria/tituloMostrar", {
    method: "POST",
    body: JSON.stringify({ titulo: app.tituloModal })
  }).then(function (response) {
    return response.json()
  }).then(function (json) {
    // retorno do objeto do CB
    app.tituloModal = json.titulo
  }).catch(function () {
    // coisas caso der erro
  })

}

// =================================================
// Sair da Conssessionaria
// =================================================

function sair() {

  app.show_vue = false

  fetch("http://monkey_concessionaria/sair", {
    method: 'POST'

  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}







// =================================================
// Sweet Alert
// =================================================
function btnTransferir(num) {
  let veiculo = app.player_carros[num].nomeCarro
  let placa = app.player_carros[num].placaCarro
  let detido = app.player_carros[num].carroDetido
  
  Swal.fire({
    title: 'Transferir',
    text: "Deseja transferir este automóvel?",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#00BD68',
    cancelButtonColor: '#FF4742',
    confirmButtonText: 'Sim'
  }).then(res => {
    if (res.isConfirmed) {
      Swal.fire({
        title: 'ID',
        text: "Digite o ID do outro usuário para realizar a transferencia: ",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#00BD68',
        cancelButtonColor: '#FF4742',
        confirmButtonText: 'Sim',
        input: 'number'
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
          }).then(function (response) {
            return response.json()
          }).then(function (data) {
            app.player_carros = data
            if (!data.ok) {
              throw new Error(data.statusText)
            }
            return data.json()
          }).catch(function () {

          })
          Swal.fire(
            'Sucesso!',
            'Sua Tranferência foi bem sucedida.',
            'success'
          )
        }
      })
    }
  })
}

function btnVender(num) {
  let veiculo = app.player_carros[num].nomeCarro
  let placa = app.player_carros[num].placaCarro
  let valor = app.player_carros[num].valor
  Swal.fire({
    title: 'Vender',
    text: "Deseja vender este automóvel?",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#00BD68',
    cancelButtonColor: '#FF4742',
    confirmButtonText: 'Sim'
  }).then(res => {
    if (res.isConfirmed) {
      fetch("http://monkey_concessionaria/carrosVenda", {
        method: 'POST',
        body: JSON.stringify({
          vehicle: veiculo,
          plate: placa,
          sell: valor
        }),
      }).then(function (response) {
        return response.json()
      }).then(function (data) {
        app.player_carros = data
      }).catch(function () {

      })
      Swal.fire(
        'Sucesso!',
        'Sua Venda foi bem sucedida.',
        'success'
      )
    }
  })
}