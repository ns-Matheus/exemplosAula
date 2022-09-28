const Toast = Swal.mixin({
   toast: true,
   position: 'bottom',
   showConfirmButton: false,
   timer: 5000,
   timerProgressBar: true,
   didOpen: (toast) => {
      toast.addEventListener('mouseenter', Swal.stopTimer)
      toast.addEventListener('mouseleave', Swal.resumeTimer)
   }
})

var app = new Vue({
   el: '#app',
   data: {
      idCraft: null,
      recipeSelected: null,
      listaReceitas: [],
      listaItens: [],
      erroImg: 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png',
      logoImg: 'https://cdn.discordapp.com/attachments/819276128795492425/943925617089462302/logo2.png',
      urlFotosItens: 'https://j4v4.site/MC/itens/',
      carregando: false,
      isLogado: false, // true = dev
      show_progressbar: false,
      btn_sumir: true,
      btn_receber: false,
      tempoCraft: 0,
      infoUserLogado: { 'nome': 'Desconhecido', 'permissoes': [] },
      shop_ativo: false,
      lista_shop: [],
      tipo_loja: "",
      lista_fila: {}
   }
})


function pegar_shop_crafts() {

   if (app.tipo_loja == "fac") {
      app.lista_shop = [
         {
            item: "bluecard",
            nome_vitrine: "Cartão Azul",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "eletronics", qtd: 3 },
               { nome: "plastic", qtd: 3 }
            ]
         },
         {
            item: "redcard",
            nome_vitrine: "Cartão Vermelho",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "eletronics", qtd: 10 },
               { nome: "plastic", qtd: 10 }
            ]
         },
         {
            item: "blackcard",
            nome_vitrine: "Cartão Preto",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "filamentoplastico", qtd: 1 },
               { nome: "placacircuito", qtd: 1 }
            ]
         },
         {
            item: "handcuff",
            nome_vitrine: "Algema",
            preco_money: 150000,
            preco_coins: 15,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "aluminum", qtd: 3 },
               { nome: "plastic", qtd: 1 }
            ]
         },
         {
            item: "c4",
            nome_vitrine: "C4",
            preco_money: 150000,
            preco_coins: 15,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "eletronics", qtd: 2 },
               { nome: "plastic", qtd: 5 },
               { nome: "polvora", qtd: 1 }
            ]
         },
         {
            item: "hood",
            nome_vitrine: "Capuz",
            preco_money: 100000,
            preco_coins: 10,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "plastic", qtd: 3 },
               { nome: "pano", qtd: 1 },
               { nome: "linha", qtd: 1 }
            ]
         },
         {
            item: "vest",
            nome_vitrine: "Colete",
            preco_money: 150000,
            preco_coins: 150,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "pano", qtd: 1 },
               { nome: "linha", qtd: 1 }
            ]
         },
         {
            item: "rope",
            nome_vitrine: "Corda",
            preco_money: 100000,
            preco_coins: 10,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "fiocobre", qtd: 1 },
               { nome: "rubber", qtd: 2 }
            ]
         },
         {
            item: "WEAPON_ASSAULTRIFLE",
            nome_vitrine: "AK-103",
            preco_money: 1500000,
            preco_coins: 65,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 30 },
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "fiocobre", qtd: 1 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_ASSAULTRIFLE_AMMO",
            nome_vitrine: "Munição AK-103",
            preco_money: 1000000,
            preco_coins: 50,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_ASSAULTRIFLE_MK2",
            nome_vitrine: "AK-74",
            preco_money: 1500000,
            preco_coins: 65,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 30 },
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "fiocobre", qtd: 1 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_ASSAULTRIFLE_MK2_AMMO",
            nome_vitrine: "Munição AK-74",
            preco_money: 1000000,
            preco_coins: 50,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_PISTOL_MK2",
            nome_vitrine: "Five Seven",
            preco_money: 1200000,
            preco_coins: 60,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 5 },
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "copper", qtd: 1 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_PISTOL_MK2_AMMO",
            nome_vitrine: "Munição Five Seven",
            preco_money: 900000,
            preco_coins: 45,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 3 },
               { nome: "chumbo", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_REVOLVER",
            nome_vitrine: "Revolver",
            preco_money: 500000,
            preco_coins: 35,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 5 },
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "copper", qtd: 1 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_REVOLVER_AMMO",
            nome_vitrine: "Munição Revolver",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 3 },
               { nome: "chumbo", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_APPISTOL",
            nome_vitrine: "Koch VP9",
            preco_money: 500000,
            preco_coins: 35,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 5 },
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "copper", qtd: 1 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_APPISTOL_AMMO",
            nome_vitrine: "Munição Koch VP9",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 3 },
               { nome: "chumbo", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_MICROSMG",
            nome_vitrine: "UZI",
            preco_money: 600000,
            preco_coins: 40,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 15 },
               { nome: "chapaaluminio", qtd: 2 },
               { nome: "copper", qtd: 2 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_MICROSMG_AMMO",
            nome_vitrine: "Munição Uzi",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_MINISMG",
            nome_vitrine: "Skorpion",
            preco_money: 600000,
            preco_coins: 40,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 15 },
               { nome: "chapaaluminio", qtd: 2 },
               { nome: "copper", qtd: 2 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_MINISMG_AMMO",
            nome_vitrine: "Munição Skorpion",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_SMG",
            nome_vitrine: "MP5",
            preco_money: 700000,
            preco_coins: 45,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 15 },
               { nome: "chapaaluminio", qtd: 2 },
               { nome: "copper", qtd: 2 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_SMG_AMMO",
            nome_vitrine: "Munição MP5",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_ASSAULTSMG",
            nome_vitrine: "MTAR-21",
            preco_money: 700000,
            preco_coins: 45,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 15 },
               { nome: "chapaaluminio", qtd: 2 },
               { nome: "copper", qtd: 2 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_ASSAULTSMG_AMMO",
            nome_vitrine: "Munição MTAR-21",
            preco_money: 300000,
            preco_coins: 25,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_SPECIALCARBINE",
            nome_vitrine: "G36 - Parafal",
            preco_money: 1200000,
            preco_coins: 60,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 15 },
               { nome: "chapaaluminio", qtd: 2 },
               { nome: "copper", qtd: 2 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_SPECIALCARBINE_AMMO",
            nome_vitrine: "Munição G36 - Parafal",
            preco_money: 500000,
            preco_coins: 35,
            qtd_fab: 30,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 30 },
               { nome: "polvora", qtd: 10 },
               { nome: "chumbo", qtd: 3 }
            ]
         },
         {
            item: "WEAPON_RPG",
            nome_vitrine: "RPG",
            preco_money: 1200000,
            preco_coins: 60,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "pecadearma", qtd: 15 },
               { nome: "chapaaluminio", qtd: 2 },
               { nome: "copper", qtd: 2 },
               { nome: "gatilho", qtd: 1 }
            ]
         },
         {
            item: "WEAPON_RPG_AMMO",
            nome_vitrine: "Munição RPG",
            preco_money: 1000000,
            preco_coins: 50,
            qtd_fab: 2,
            duracao: 30,
            insumos: [
               { nome: "cartucho", qtd: 50 },
               { nome: "polvora", qtd: 20 },
               { nome: "chumbo", qtd: 5 }
            ]
         },
         {
            item: "dollars",
            nome_vitrine: "Lavagem de dinheiro",
            preco_money: 3000000,
            preco_coins: 90,
            qtd_fab: 8000,
            duracao: 30,
            insumos: [
               { nome: "dollars", qtd: 10000 },
               { nome: "elastic", qtd: 1 },
               { nome: "papelmoeda", qtd: 1 }
            ]
         },
         {
            item: "toolbox",
            nome_vitrine: "Caixa de ferramentas",
            preco_money: 800000,
            preco_coins: 40,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "chapaaluminio", qtd: 1 },
               { nome: "placacircuito", qtd: 1 },
               { nome: "elastic", qtd: 1 }
            ]
         },
         {
            item: "Drill",
            nome_vitrine: "Broca",
            preco_money: 800000,
            preco_coins: 40,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "fiocobre", qtd: 1 },
               { nome: "placacircuito", qtd: 1 }
            ]
         },
         {
            item: "scanner",
            nome_vitrine: "Scanner",
            preco_money: 800000,
            preco_coins: 40,
            qtd_fab: 1,
            duracao: 30,
            insumos: [
               { nome: "plastic", qtd: 1 },
               { nome: "placacircuito", qtd: 1 }
            ]
         },



      ]
   }

}

function comprar_coin(insumo) {

   Swal.fire({
      title: 'Tem certeza?',
      text: "Craft de " + insumo.nome_vitrine + " por " + insumo.preco_coins + " coins, com " + insumo.duracao + " dias de duração",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#34A853',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Comprar'
   }).then((result) => {
      if (result.isConfirmed) {


         fetch("http://monkey_craft/comprar_por_coin", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               insumo: insumo,
               idCraft: app.idCraft
            })
         }).then(response => response.json()).then(data => {

            Swal.fire(
               data.titulo,
               data.messsagem,
               data.tipo
            )

            fetch("http://monkey_craft/getRecipes", {
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  idCraft: app.idCraft
               })
            }).then(response => response.json()).then(data => {
               app.listaReceitas = data;

               if (data.length > 0) {
                  if (app.recipeSelected == null) {
                     app.recipeSelected = data[0]

                  } else {
                     data.forEach(receita => {
                        if (app.recipeSelected.id == receita.id) {
                           app.recipeSelected = receita
                        }
                     });
                  }
               } else {
                  app.recipeSelected = null
               }
            });
         });



      }
   })

}

function comprar_monkey(insumo) {
   Swal.fire({
      title: 'Tem certeza?',
      text: "Craft de " + insumo.nome_vitrine + " por R$ " + insumo.preco_money + " com " + insumo.duracao + " dias de duração",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#34A853',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Comprar'
   }).then((result) => {
      if (result.isConfirmed) {


         fetch("http://monkey_craft/comprar_por_money", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               insumo: insumo,
               idCraft: app.idCraft
            })
         }).then(response => response.json()).then(data => {

            Swal.fire(
               data.titulo,
               data.messsagem,
               data.tipo
            )

            fetch("http://monkey_craft/getRecipes", {
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  idCraft: app.idCraft
               })
            }).then(response => response.json()).then(data => {
               app.listaReceitas = data;

               if (data.length > 0) {
                  if (app.recipeSelected == null) {
                     app.recipeSelected = data[0]

                  } else {
                     data.forEach(receita => {
                        if (app.recipeSelected.id == receita.id) {
                           app.recipeSelected = receita
                        }
                     });
                  }
               } else {
                  app.recipeSelected = null
               }
            });
         });



      }
   })
}

function getRecipes(isRemove) {
   fetch("http://monkey_craft/getRecipes", {
      headers: { "Content-Type": "application/json" },
      method: "POST",
      body: JSON.stringify({
         idCraft: app.idCraft
      })
   }).then(response => response.json()).then(data => {
      app.listaReceitas = data;

      if (data.length > 0) {
         if (isRemove || app.recipeSelected == null) {
            app.recipeSelected = data[0]

         } else {
            data.forEach(receita => {
               if (app.recipeSelected.id == receita.id) {
                  app.recipeSelected = receita
               }
            });
         }
      } else {
         app.recipeSelected = null
      }
   });
}

function removerCraft() {
   Swal.fire({
      icon: 'warning',
      title: 'Remover craft?',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showConfirmButton: true,
      confirmButtonText: 'Confirmar'

   }).then((result) => {
      if (result.isConfirmed) {
         fetch("http://monkey_craft/removeCraft", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               idCraft: app.idCraft
            })
         });

         sair(false)
      }
   })
}

function criarReceita() {
   Swal.fire({
      icon: 'question',
      title: 'Adicionar receita',
      html: '<div class="w-100">' +
         '<div class="row">' +
         '<div class="w-100">' +
         '<label class="font-12"><i class="fas fa-hashtag font-11 mr-1"></i>Nome do Item</label><br/>' +
         '<input class="w-50" type="text" id="criarReceita1" class="mb-2" />' +
         '</div>' +
         '<div class="w-50">' +
         '<label class="font-12"><i class="fas fa-boxes font-10 mr-1"></i>Quantidade Gerada</label><br/>' +
         '<input class="w-25" type="text" id="criarReceita2" />' +
         '</div>' +
         '<div class="w-50">' +
         '<label class="font-12"><i class="fa fa-clock font-10 mr-1"></i>Tempo para o Craft</label><br/>' +
         '<input class="w-25" type="text" id="criarReceita3" />' +
         '</div>' +
         '</div>' +
         '</div>',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showConfirmButton: true,
      confirmButtonText: 'Salvar',
      didOpen: function () {
         setTimeout(() => {
            document.getElementById('criarReceita1').value = ''
            document.getElementById('criarReceita2').value = ''

            document.getElementById('criarReceita1').focus()

            $('#criarReceita1').autocomplete({
               source: app.listaItens,
               minLength: 2
            });
         }, 100);
      }
   }).then((result) => {
      if (result.isConfirmed) {
         if (document.getElementById('criarReceita1').value.trim().length == 0) {
            Toast.fire({
               icon: 'error',
               title: 'Informe o nome do insumo!'
            });

            return
         } else if (document.getElementById('criarReceita2').value.trim().length == 0) {
            Toast.fire({
               icon: 'error',
               title: 'Informe a quantidade gerada!'
            });

            return
         } else if (isNaN(document.getElementById('criarReceita2').value)) {
            Toast.fire({
               icon: 'error',
               title: 'Quantidade deve ser numérico!'
            });

            return
         } else if (document.getElementById('criarReceita3').value.trim().length == 0) {
            Toast.fire({
               icon: 'error',
               title: 'Informe o tempo!'
            });

            return
         } else if (isNaN(document.getElementById('criarReceita3').value)) {
            Toast.fire({
               icon: 'error',
               title: 'O valor deve ser numérico!'
            });

            return
         }

         app.carregando = true

         fetch("http://monkey_craft/createRecipe", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               nameItem: document.getElementById('criarReceita1').value.trim(),
               amount: document.getElementById('criarReceita2').value.trim(),
               time: document.getElementById('criarReceita3').value.trim(),
               idCraft: app.idCraft
            })
         }).finally(function () {
            app.carregando = false

            Toast.fire({
               icon: 'success',
               title: 'Adicionado com sucesso!'
            });

            getRecipes(false)
         });
      }
   })
}

function removerReceita(idReceita) {
   Swal.fire({
      icon: 'warning',
      title: 'Remover receita?',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showConfirmButton: true,
      confirmButtonText: 'Confirmar'

   }).then((result) => {
      if (result.isConfirmed) {
         app.carregando = true

         fetch("http://monkey_craft/removeRecipe", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               idRecipe: idReceita
            })
         }).finally(function () {
            app.carregando = false

            Toast.fire({
               icon: 'success',
               title: 'Removido com sucesso!'
            });

            getRecipes(true)
         });
      }
   })

}

function criarInsumo() {
   Swal.fire({
      icon: 'question',
      title: 'Adicionar insumo',
      html: '<div class="w-100">' +
         '<div class="row">' +
         '<div class="w-50">' +
         '<label class="font-12"><i class="fas fa-hashtag font-11 mr-1"></i>Nome item</label><br/>' +
         '<input type="text" id="criarInsumo1" class="mb-2" />' +
         '</div>' +
         '<div class="w-50">' +
         '<label class="font-12"><i class="fas fa-boxes font-10 mr-1"></i>Quantidade requerida</label><br/>' +
         '<input type="text" id="criarInsumo2" />' +
         '</div>' +
         '</div>' +
         '</div>',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showConfirmButton: true,
      confirmButtonText: 'Salvar',
      didOpen: function () {
         setTimeout(() => {
            document.getElementById('criarInsumo1').value = ''
            document.getElementById('criarInsumo2').value = ''

            document.getElementById('criarInsumo1').focus()

            $('#criarInsumo1').autocomplete({
               source: app.listaItens,
               minLength: 2
            });
         }, 100);
      }
   }).then((result) => {
      if (result.isConfirmed) {
         if (document.getElementById('criarInsumo1').value.trim().length == 0) {
            Toast.fire({
               icon: 'error',
               title: 'Informe o nome do insumo!'
            });

            return
         } else if (document.getElementById('criarInsumo2').value.trim().length == 0) {
            Toast.fire({
               icon: 'error',
               title: 'Informe a quantidade requerida!'
            });

            return
         } else if (isNaN(document.getElementById('criarInsumo2').value)) {
            Toast.fire({
               icon: 'error',
               title: 'Quantidade deve ser numérico!'
            });

            return
         }

         app.carregando = true

         fetch("http://monkey_craft/createInsumo", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               nameItem: document.getElementById('criarInsumo1').value.trim(),
               amount: document.getElementById('criarInsumo2').value.trim(),
               idRecipe: app.recipeSelected.id
            })
         }).finally(function () {
            app.carregando = false

            Toast.fire({
               icon: 'success',
               title: 'Adicionado com sucesso!'
            });

            getRecipes(false)
         });
      }
   })
}

function removerInsumo(idInsumo) {
   Swal.fire({
      icon: 'warning',
      title: 'Remover insumo?',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showConfirmButton: true,
      confirmButtonText: 'Confirmar'

   }).then((result) => {
      if (result.isConfirmed) {
         app.carregando = true

         fetch("http://monkey_craft/removeInsumo", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               idInsumo: idInsumo
            })
         }).finally(function () {
            app.carregando = false

            Toast.fire({
               icon: 'success',
               title: 'Removido com sucesso!'
            });

            getRecipes(false)
         });
      }
   })
}

function sair(deslogar) {
   document.getElementById('app').style.display = 'none'
   fetch("http://monkey_craft/close", { method: "POST" })

   if (deslogar) {
      app.isLogado = false
   }

   app.carregando = false
}

function craftRecipe() {


   Swal.fire({
      icon: 'warning',
      title: 'Craft de item',
      text: 'Informe a quantidade',
      input: 'text',
      inputValue: '1',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      confirmButtonText: 'Confirmar',
      inputValidator: (value) => {
         if (!$.isNumeric(value) || parseInt(value) <= 0) {
            return 'Quantidade inválida!'
         }
      }

   }).then((result) => {

      if (result.isConfirmed) {
         app.btn_receber = false;
         fetch("http://monkey_craft/craftRecipe", {
            headers: { "Content-Type": "application/json" },
            method: "POST",
            body: JSON.stringify({
               item: {
                  id: app.recipeSelected.id,
                  nome: app.recipeSelected.nome_item,
                  quantidade: app.recipeSelected.quantidade,
                  tempo: app.recipeSelected.tempo
               },
               btnReceber: app.btn_receber,
               insumos: app.recipeSelected.insumos,
               amount: parseInt(result.value)
            })
         }).then(result => {
            return result.json()
         }).then((data) => {
            app.show_progressbar = data

            $(function () {
               var progressbar = $("#progressbar"),
                  progressLabel = $(".progress-label");
                  // progressLine = $(".progress-line");

               progressbar.progressbar({
                  value: false,
                  change: function () {
                     progressLabel.text(progressbar.progressbar("value") + "%");
                     app.btn_sumir = false
                  },
                  complete: function () {
                     progressLabel.text("Completo!");
                     app.btn_sumir = true;
                     app.btn_receber = true;
                     app.show_progressbar = false;
                  }
               });

               function progress() {
                  var val = progressbar.progressbar("value");
                  progressbar.progressbar("value", val + 1);

                  //   progressLine.width(val + '%');

                  if (val < 100) {
                     setTimeout(progress, 100);
                  }
               }

               setTimeout(progress, 2000);
            });
         })

            

         // setTimeout(() => {
         //    var i = 0;
         //    if (i == 0) {
         //       i = 1;
         //       var elem = document.getElementById("myBar");
         //       var width = 0;
         //       var id = setInterval(frame, 100);
         //       function frame() {
         //          if (width != 100) {
         //             app.btn_sumir = false
         //             width++;
         //             elem.style.width = width + "%";
         //          } else {
         //             clearInterval(id);
         //             i = 0;
         //             app.btn_sumir = true;
         //             app.btn_receber = true;
         //             app.show_progressbar = false;
         //          }
         //       }
         //    }
         // }, 200);

      }
   })
}


function craftDarItem() {
   fetch("http://monkey_craft/craftDarItem", {
      headers: { "Content-Type": "application/json" },
      method: "POST"
   })
   app.btn_receber = false
}




function imageError(e) {
   e.src = app.erroImg
}

document.addEventListener("DOMContentLoaded", function () {
   window.addEventListener("message", function (event) {

      app.tempoCraft = event.data.tempoReal


      if (event.data.method == 'open') {
         app.infoUserLogado.nome = event.data.namePlayer
         app.listaItens = event.data.itens
         app.idCraft = event.data.id
         app.shop_ativo = false

         event.data.permissions.forEach(p => {
            if (!app.infoUserLogado.permissoes.includes(p.permiss)) {
               app.infoUserLogado.permissoes.push(p.permiss);
            }
         });

         getRecipes(true)

         document.getElementById('app').style.display = 'flex'

         // carrega shops
         app.tipo_loja = event.data.tipo
         pegar_shop_crafts()



      } else if (event.data.method == 'close') {
         app.isLogado = false

         document.getElementById('app').style.display = 'none'

      } else if (event.data.method == 'openCreateCraft') {
         Swal.fire({
            icon: 'question',
            title: 'Adicionar craft',
            html: '<div class="w-100">' +
               '<div class="row">' +
               '<div class="w-50">' +
               '<label class="font-12"><i class="fas fa-hashtag font-11 mr-1"></i>Nome</label><br/>' +
               '<input type="text" id="criarCraft1" class="mb-2" />' +
               '</div>' +
               '<div class="w-50">' +
               '<label class="font-12"><i class="fas fa-lock font-11 mr-1"></i>Permissão</label><br/>' +
               '<input type="text" id="criarCraft2" />' +
               '</div>' +
               '<div class="w-100">' +
               '<label class="font-12"><i class="fas fa-lock font-11 mr-1"></i>Tipo</label><br/>' +
               '<select id="criarCraft3" style="width: 100%;">' +
               '<option value="Normal">Normal</option>' +
               '<option value="fac">Fac</option>' +
               '</select>' +
               '</div>' +
               '</div>' +
               '</div>',
            showCancelButton: true,
            cancelButtonText: 'Cancelar',
            showConfirmButton: true,
            confirmButtonText: 'Salvar',
            didOpen: function () {
               setTimeout(() => {
                  document.getElementById('criarCraft1').value = ''
                  document.getElementById('criarCraft2').value = ''

                  document.getElementById('criarCraft1').focus()
               }, 100);
            }
         }).then((result) => {
            if (result.isConfirmed) {
               if (document.getElementById('criarCraft1').value.trim().length == 0) {
                  Toast.fire({
                     icon: 'error',
                     title: 'Informe o nome!'
                  });

                  sair(false)
                  return
               }

               fetch("http://monkey_craft/createCraft", {
                  headers: { "Content-Type": "application/json" },
                  method: "POST",
                  body: JSON.stringify({
                     name: document.getElementById('criarCraft1').value.trim(),
                     permission: document.getElementById('criarCraft2').value.trim(),
                     tipo: document.getElementById('criarCraft3').value.trim()
                  })
               });

               sair(false)

            } else {
               sair(false)
            }
         })
      }
   })

   document.onkeyup = function (data) {
      if (data.which == 27) {
         sair(false)
      }
   }
})