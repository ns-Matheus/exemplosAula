var core = new Vue({
  el: "#app",
  data: {
    page: { url: "/pages/teste.html", titulo: "Teste", menu: "Principal" },
    servicos: [
      {
        nome: "Turismo",
        url: "https://cdn.discordapp.com/attachments/895016171651334154/1022182611055038464/Metropolitano6.png",
        nivel: 3,
        valorPago: 100,
        valorPagar: 0,
        valorRecebido: 0,
        mult: 0,
      },
      {
        nome: "Aventura",
        url: "https://cdn.discordapp.com/attachments/895016171651334154/1022113303499120663/Metropolitano4.png",
        nivel: 2,
        valorPago: 100,
        valorPagar: 0,
        valorRecebido: 0,
        mult: 0,
      },
      {
        nome: "Metropolitano",
        url: "https://cdn.discordapp.com/attachments/895016171651334154/1022104483456626809/Metropolitano.png",
        nivel: 1,
        valorPago: 100,
        valorPagar: 0,
        valorRecebido: 0,
        mult: 0,
      },
      {
        nome: "Viagem",
        url: "https://cdn.discordapp.com/attachments/895016171651334154/1022107479057891370/Metropolitano2.png",
        nivel: 4,
        valorPago: 100,
        valorPagar: 0,
        valorRecebido: 0,
        mult: 0,
      },
    ],
    user: {
      nome: "Carlos Oliveira",
      id: 0,
    },
    nivel: 4,
    caixaAtual: 0,
    precoLoja: 0,
    idDono: null,
    moeda: Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }),
    idLoja: null,
    percentageValue: null,
    percent: Intl.NumberFormat("pt-BR",{
      style: 'percent',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    })
  },
});

document.addEventListener("DOMContentLoaded", function () {
  window.addEventListener("message", function (event) {
    switch (event.data.method) {
      case "open":
        console.log(JSON.stringify(event.data))
        document.getElementById("app").style.display = "block";
        core.idDono = event.data.idDono;
        core.precoLoja = event.data.preco;
        core.caixaAtual = event.data.valorCaixa;
        core.nivel = event.data.nivel
        core.idLoja = event.data.id
        core.percentageValue = event.data.porcentagemGanho
        core.user.id = event.data.idPlayer
        core.user.nome = event.data.namePlayer
        changePage("Inicio", "principal", "pages/home.html");
        break;
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

function comprarLoja() {
    Swal.fire({
      title: "Deseja comprar ?",
      text:
        "Você deseja comprar essa Loja no valor de " +
        core.moeda.format(core.precoLoja),
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Sim desejo",
      cancelButtonText: "Cancelar"
    }).then((result) => {
      if (result.isConfirmed) {
        console.log(core.idLoja)
        fetch("http://monkey_taxi/buy", { method: "POST", body: JSON.stringify({
          id: parseInt(core.idLoja)
        })})
        .then(res => {return res.json()})
        .then(data => {
          Swal.fire("Parabéns!", "Você comprado com sucesso", "success");
          core.idDono = data[0].idDono;
          core.caixaAtual = data[0].valorCaixa;
          core.nivel = data[0].nivel
          core.idLoja = data[0].id

          console.log(JSON.stringify(data[0].id))
        })
        .catch(err =>{
          Swal.fire("Erro!", "Erro ao comprar", "error");
          console.log(err)
        });
      }
    });
}

function depositarDinheiro() {
  return new Promise((resolve, reject) => {
    Swal.fire({
      icon: "info",
      title: "Depositar",
      text: "Insira o valor a depoistar",
      input: "number",
      inputPlaceholder: "Valor",
      showConfirmButton: true,
      showCancelButton: true,
      confirmButtonText: "Confirmar",
      cancelButtonText: "Cancelar",
      inputValidator: (value) => {
        if (!value) {
          return "Nome inválido!";
        }
      },
    }).then((res) => {
      if (res.isConfirmed) {
      }
    });
  });
}

function sacarDinheiro() {
  return new Promise((resolve, reject) => {
    Swal.fire({
      icon: "info",
      title: "Sacar",
      text: "Insira o valor a sacar",
      input: "number",
      inputPlaceholder: "Valor",
      showConfirmButton: true,
      showCancelButton: true,
      confirmButtonText: "Confirmar",
      cancelButtonText: "Cancelar",
      inputValidator: (value) => {
        if (!value) {
          return "Nome inválido!";
        }
      },
    }).then((res) => {
      if (res.isConfirmed) {
        fetch("http:/monkey_taxi/withdraw",{
          method:"POST",
          body:JSON.stringify({
            id: core.idLoja,
            valor: res.value
          })
        }).then(res => {
          return res.json()
        }).then(data =>{
          resolve(data[0].valorCaixa)
        }).catch(err =>{
          console.log(err)
          reject(err)
        })
      }
    });
  });
}

function configurarServico() {
  return new Promise((resolve, reject) => {
    Swal.fire({
      icon: "info",
      title: "Sacar",
      text: "Insira o valor a sacar",
      input: "number",
      inputPlaceholder: "Valor",
      showConfirmButton: true,
      showCancelButton: true,
      confirmButtonText: "Confirmar",
      cancelButtonText: "Cancelar",
      inputValidator: (value) => {
        if (!value) {
          return "Nome inválido!";
        }
      },
    });
  });
}

function close() {
  return new Promise(function (resolve, reject) {
    fetch("http://monkey_taxi/close", { method: "POST" })
      .then(function () {
        document.getElementById("app").style.display = "none";
        resolve();
      })
      .catch(function () {
        reject();
      });
  });
}

function iniciarRota(nome) {
  fetch("http://monkey_taxi/initRoute", {
    method: "POST",
    body: JSON.stringify({
      nome: nome,
    }),
  }).then(function () {
    document.getElementById("app").style.display = "none";
  });
}

function aplicarPorcentagem(valor, id){
  return new Promise((resolve, reject)=>{
    Swal.fire({
      icon: "info",
      title: "Alterar",
      text: "Deseja alterar para essa porcentagem para "+core.percent.format(valor/100),
      showConfirmButton: true,
      showCancelButton: true,
      confirmButtonText: "Confirmar",
      cancelButtonText: "Cancelar",
    }).then((res) => {
      if (res.isConfirmed) {
        fetch("http:/monkey_taxi/setPorcentagem",{
          method:"POST",
          body:JSON.stringify({
            id: id,
            valor: valor
          })
        }).then(res => {
          return res.json()
        }).then(data =>{
          resolve(data[0].porcentagemGanho)
        }).catch(err =>{
          console.log(err)
          reject(err)
        })
      }
    });
  })
}
