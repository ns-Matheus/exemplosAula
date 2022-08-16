var app = new Vue({
  el: '#app',
  data: {
    show_vue: false,
    show_icone: false,
    lista_vue: [],
    nome_carro_vue: 0,
    valor_vue: 0,
    kg_vue: 0,
    pesquisa: null,
    aceleracao_vue: 0,
    velocidade_vue: 0,
    aderencia_vue: 0,
    frenagem_vue: 0,
    cores_vue: [
      
      { r: 0, g: 160, b: 0 },
      { r: 127, g: 255, b: 0 },
      { r: 0, g: 255, b: 0 },

      { r: 0, g: 250, b: 154 },
      { r: 0, g: 255, b: 255 },
      { r: 25, g: 25, b: 112 },
      { r: 0, g: 0, b: 128 },

      { r: 0, g: 0, b: 205 },
      { r: 205, g: 92, b: 92 },
      { r: 220, g: 20, b: 60 },
      { r: 255, g: 0, b: 0 },

      { r: 255, g: 20, b: 147 },
      { r: 199, g: 21, b: 133 },
      { r: 255, g: 0, b: 255 },
      { r: 138, g: 43, b: 226 },

      { r: 102, g: 51, b: 153 },
      { r: 255, g: 127, b: 80 },
      { r: 255, g: 69, b: 0 },
      { r: 255, g: 140, b: 0 },
      { r: 255, g: 215, b: 0 },

      { r: 255, g: 255, b: 0 },
      { r: 240, g: 230, b: 140 },
      { r: 255, g: 192, b: 203 },
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
// Mostrar Carros 
// =================================================

function mostrarCarro(carro) {

  app.nome_carro_vue = carro.nome
  app.valor_vue = carro.preco
  app.kg_vue = carro.kg

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
    console.log(response)
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
// Escoder HUD 
// =================================================
function esconderHUD() {

  fetch("http://monkey_concessionaria/esconderHUD", {
    method: 'POST'

  }).then(function (response) {
    return response.json()
  }).then(function (json) {

  }).catch(function () {

  })
}



// =================================================
// Evento de chamada 
// =================================================
var valida = true

document.addEventListener("DOMContentLoaded", function () {
  window.addEventListener("message", function (event) {
    var data = event.data

    valida = data.foco

    if (data.acao == true) {
      app.show_vue = true,
        app.lista_vue = data.carros
    }

    if (data.acao == 'att') {

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