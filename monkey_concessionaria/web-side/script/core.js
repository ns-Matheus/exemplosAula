var core = new Vue({
  el: "#app",
  data: {
    page: { url: "/pages/teste.html", titulo: "Teste", menu: "Principal" },
    erroImg: 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png',
    active: false,
    carros: [],
    lista_player_carros: [],
    urlIcon: "images/coins.png",
    nome_carro: 0,
    valor_carro: 0,
    kg_vue: 0,
    pesquisa: null
  }, watch: {
    pesquisa: function (event) {
      let valorPesquisa = event.toLowerCase()
      $(".card-carro").filter(function () {
        $(this).toggle($(this).text().toLowerCase().indexOf(valorPesquisa) > - 1)
      })
    }
  }
});

document.addEventListener("DOMContentLoaded", () => {
  window.addEventListener("message", (event) => {

    let data = event.data;
    if (data.acao == true) {
      changePage("Loja", "Painel", "pages/store.html");
      document.getElementById("app").style.display = "block";
      core.carros = data.carros
      core.lista_player_carros = data.carrosPlayer
    } else {
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

// function comprarCarro() {
//   Swal.fire({
//     title: "Deseja comprar ?",
//     text: "Deseja comprar este automóvel pelo valor de "+preco+"?",
//     icon: "warning",
//     showCancelButton: true,
//     confirmButtonColor: "#3085d6",
//     cancelButtonColor: "#d33",
//     confirmButtonText: "Sim",
//     cancelButtonText:"Cancelar"
//   }).then((result) => {
//     if (result.isConfirmed) {
//       fetch("http://monkey_concessionaria/comprar_print_coin", {
//         method: "POST",
//         body: JSON.stringify({ nome: app.nome_carro, preco: app.valor_carro})
//       }).then((result) => {
//           return result.json();
//         }).then((data) => {
//           app.nome_carro = data.nome
//           app.valor_carro = data.preco
//         })
// .catch((err) => {
//   console.log(err);
// });
//     }
//   });
// }


// function filtrarArma(filtro){
//   console.log(filtro)
//   return new Promise((resolve, reject)=>{
//     fetch("http://monkey_concessionaria/filtrar", {
//       method: "POST",
//       body: JSON.stringify({
//         filtro: filtro
//       })
//     })
//       .then((response) => response.json())
//       .then((data) => {
//         resolve(data)
//       })
//       .catch((err) => {
//         console.log(err);
//         reject(err)
//       });
//   })
// }

// function filtrarArmaUser(filtro){
//   return new Promise((resolve, reject)=>{
//     fetch("http://monkey_concessionaria/filtrarUser", {
//       method: "POST",
//       body: JSON.stringify({
//         filtro: filtro
//       })
//     })
//       .then((response) => response.json())
//       .then((data) => {
//         resolve(data)
//       })
//       .catch((err) => {
//         console.log(err);
//         reject(err)
//       });
//   })
// }

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
      .catch(function (err) {
        reject(err);
      });
  });
}

function comprarCarro(nome, preco) {
  return new Promise(function (resolve, reject) {
    fetch("http://monkey_concessionaria/comprarCarro", {
      method: 'POST',
      body: JSON.stringify({
        nome: nome,
        preco: preco
      })
    }).then(function (data) {
      core.lista_player_carros = data.carros
      resolve(data);
      close()
    }).catch(function (err) {
      reject(err);
    });
  })
}

function testeDrive(nome) {
  document.getElementById("app").style.display = "none";
  return new Promise(function (resolve, reject) {
    fetch("http://monkey_concessionaria/testeDrive", {
      method: 'POST',
      body: JSON.stringify({
        nome: nome
      })
    }).then(function (data) {
      resolve(data);
    }).catch(function (err) {
      reject(err);
    });
  })
}




function getCarrosPlayer() {
  // $('.card-carro').modal('show')
  toggleLoading(true)

  fetch("http://monkey_concessionaria/getCarrosPlayer", {
    method: 'POST'

  }).then(function (response) {
    return response.json()

  }).then(function (json) {
    toggleLoading(false)
    core.lista_player_carros = json

  }).catch(function (json) {
    toggleLoading(false)
  })
}


function btnTransferir(carro) {
  return new Promise((resolve, reject) => {
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
        }).then(res => {
          return res.json()
        }).then(data => {
          core.lista_player_carros = data
          resolve(data)
        }).catch(err => {
          reject(err)
        })
        // app.lista_player_carros.splice(index, 1)

        Swal.fire({
          icon: 'success',
          title: 'Tranferência bem sucedida!'
        })
      }
    })
  })

}

function btnVender(carro) {
  return new Promise((resolve, reject) => {
    let veiculo = carro.nomeCarro
    let placa = carro.placaCarro
    let valor = carro.valor

    Swal.fire({
      icon: 'warning',
      title: 'Vender veículo por $ ' + valor.toLocaleString('pt-br', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' ?',
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
        }).then(res => {
          return res.json()
        }).then(data => {
          core.lista_player_carros = data.carros
          resolve(data)
        }).catch(err => {
          reject(err)
        })

        // app.lista_player_carros.splice(index, 1)

        Swal.fire({
          icon: 'success',
          title: 'Venda bem sucedida!'
        })
      }
    })
  })
}

function imageError(e) {
  e.src = 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png'
}