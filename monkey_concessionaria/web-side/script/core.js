var core = new Vue({
  el: "#app",
  data: {
    page: { url: "/pages/teste.html", titulo: "Teste", menu: "Principal" },
    erroImg: 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png',
    active: false,
    moeda: Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: "BRL",
    }),
    peso: Intl.NumberFormat("pt-BR", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }),
    carros: [

    ],
    lista_player_carros: [

    ],
    urlIcon: "images/coins.png",
    pesquisa: null
  },watch: {
    pesquisa: function (event) {
       let valorPesquisa = event.toLowerCase()
       $(".menucarros .card_image").filter(function () {
          $(this).toggle($(this).text().toLowerCase().indexOf(valorPesquisa) > - 1)
       })
    }
 }
});

document.addEventListener("DOMContentLoaded", () => {
  window.addEventListener("message", (event) => {
    
    let data = event.data;
    console.log(JSON.stringify(data));
    if (data.acao == true) {
      changePage("Loja", "Painel", "pages/store.html");
      document.getElementById("app").style.display = "block";
      core.carros = data.carros
   }else{
    document.getElementById("app").style.display = "none";
   }

 
  });
  window.onkeyup = function (data) {
    if (data.which == 27) {
      close();
    }
  };
});

function changePage(titulo, menu, page) {
  if (
    core.page.url != page ||
    core.page.menu != menu ||
    core.page.titulo != titulo
  ) {
    toggleLoading(true);
    $("#content-body").load(page, (response, status, xhr) => {
      if (status != "error") {
        core.page.url = page;
        core.page.titulo = titulo;
        core.page.menu = menu;
        toggleLoading(false);
        $(".block-header").removeClass("d-none");
      } else {
        setTimeout(() => {
          toggleLoading(false);
          $("#content-body").load(
            "/pages/erro.html",
            (response, status, xhr) => {
              if (status != "error") {
                $(".block-header").addClass("d-none");
              }
            }
          );
          core.page.url = "Erro";
          core.page.titulo = "Erro";
          core.page.menu = "Erro";
        }, 2000);
      }
    });
  }
}

function toggleLoading(show) {
  if (show) {
    $(".loadingContent").addClass("d-block");
  } else {
    $(".loadingContent").removeClass("d-block");
  }
}

function comprarCarro(carro) {
  return new Promise((resolve, reject) => {
    Swal.fire({
      title: "Deseja comprar ?",
      text: "Deseja comprar essa skin por "+arma.price_coin+" coins",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Sim",
      cancelButtonText:"Cancelar"
    }).then((result) => {
      if (result.isConfirmed) {
        fetch("http://monkey_skin_arma/comprar_print_coin", {
          method: "POST",
          body: JSON.stringify({
            arma,
          }),
        })
          .then((res) => {
            return res.json();
          })
          .then((data) => {
            console.log(JSON.stringify(data));
          })
          .catch((err) => {
            console.log(err);
          });
      }
    });
  });
}


function filtrarArma(filtro){
  console.log(filtro)
  return new Promise((resolve, reject)=>{
    fetch("http://monkey_skin_arma/filtrar", {
      method: "POST",
      body: JSON.stringify({
        filtro: filtro
      })
    })
      .then((response) => response.json())
      .then((data) => {
        resolve(data)
      })
      .catch((err) => {
        console.log(err);
        reject(err)
      });
  })
}

function filtrarArmaUser(filtro){
  return new Promise((resolve, reject)=>{
    fetch("http://monkey_skin_arma/filtrarUser", {
      method: "POST",
      body: JSON.stringify({
        filtro: filtro
      })
    })
      .then((response) => response.json())
      .then((data) => {
        resolve(data)
      })
      .catch((err) => {
        console.log(err);
        reject(err)
      });
  })
}

function close() {
  return new Promise(function (resolve, reject) {
    fetch("http://monkey_concessionaria/sair", { method: "POST" })
      .then((res) => {
        return res.json();
      })
      .then((data) => {
        if (data.fechar == true) {
          document.getElementById("app").style.display = "none";
        }
        resolve();
      })
      .catch(function () {
        reject();
      });
  });
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


// function mostrarCarro(carro) {
//   app.nome_carro_vue = carro.nome
//   app.valor_vue = carro.preco
//   app.kg_vue = carro.kg

//   fetch("http://monkey_concessionaria/mostrarCarro", {
//      method: 'POST',
//      body: JSON.stringify({ 
//         nome: carro.nome 
//      })
//   })
// }

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

function imageError(e) {
  e.src = 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png'
}