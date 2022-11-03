var global = new Vue({
   el: '#app',
   data: {
      page: {'url': '', 'titulo': '', 'data': {}},
      errorImg: 'https://cdn.discordapp.com/attachments/795099022439481390/814929467863859221/sem_foto.png',
      urlFotoItens: 'https://j4v4.site/MC/itens/icons/'
   }
})

var Toast;
var audioPlayer;

$.getScript("https://cdn.jsdelivr.net/npm/sweetalert2@11.4.26/dist/sweetalert2.all.min.js", function() {
   Toast = Swal.mixin({
      toast: true,
      position: 'bottom-end',
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: (toast) => {
         toast.addEventListener('mouseenter', Swal.stopTimer)
         toast.addEventListener('mouseleave', Swal.resumeTimer)
      }
   })
});

document.addEventListener("DOMContentLoaded", function() {
	window.addEventListener("message", function (event) {
      switch (event.data.method) {
         case "openHome":
            document.getElementById('app').style.display = 'block'
            global.page.data = event.data.body;
            
            toggleLoading(false)
            changePage('Casa', 'pages/casa.html')
         break;
         case "openApto":
            document.getElementById('app').style.display = 'block'
            global.page.data = event.data.body;

            toggleLoading(false)
            changePage('Apartamento', 'pages/apartamento.html')
         break;
         case "openPainel":
            document.getElementById('app').style.display = 'block'
            global.page.data = event.data.body;

            toggleLoading(false)
            changePage('Painel', 'pages/painel.html')
         break;
         case "openChest":
            document.getElementById('app').style.display = 'block'
            global.page.data = event.data.body;

            toggleLoading(false)
            changePage('Baú', 'pages/bau.html')
         break;
         case "openFurnitures":
            document.getElementById('app').style.display = 'block'

            toggleLoading(false)
            changePage('Possuídos', 'pages/moveis_jogador.html')
         break;
         case "close":
            document.getElementById('app').style.display = 'none'
            global.page = {'url': '', 'titulo': '', 'data': {}}
         break;
         case "updateChest":
            updateChest()
         break;
         case "playSound":
            playSound(event.data.body)
         break;
      }
   })

   window.onkeyup = function(data) {
      if (data.which == 27){
         close()
      }
   }
})

function changePage(titulo, page) {
   toggleLoading(true)
   
   $("#content-body").load(page, function(response, status, xhr) {
      if (status != "error") {
         global.page.url = page
         global.page.titulo = titulo
      }

      toggleLoading(false)
   });
}

function playSound(sound) {
   if (audioPlayer != null){ 
      audioPlayer.pause(); 
   }

   audioPlayer = new Audio("sounds/"+ sound +".ogg");
   audioPlayer.volume = 0.5;
   audioPlayer.play();
}

function toggleLoading(show) {
   if (show) {
      $(".loadingContent").addClass('d-block')
   } else {
      $(".loadingContent").removeClass('d-block')
   }
}

function close() {
   return new Promise(function(resolve, reject) {
      fetch('http://monkey_homes_v2/close', { method: 'POST' })
      .then(function() {
         document.getElementById('app').style.display = 'none'
         resolve()
         
      }).catch(function() {
         reject()
      });
   });
}

function isAuthorized(casa) {
   if (casa.ownerId == casa.idPlayer) {
      return true
   } else if (casa.authorizedPersons == null) {
      return false
   } else if (casa.authorizedPersons.map(user => user.id).includes(casa.idPlayer)) {
      return true
   } else {
      return false
   }
}

function personOptions(user, casa, index) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Opções',
         text: 'Morador "'+ user.name +'"',
         confirmButtonText: 'Transferir imóvel',
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         showDenyButton: true,
         denyButtonText: 'Remover morador'

      }).then((result) => {
         if (result.isDenied) {
            Swal.fire({
               icon: 'warning',
               title: 'Remover morador',
               showCancelButton: true,
               cancelButtonText: 'Cancelar',
               confirmButtonText: 'Confirmar'
               
            }).then((result) => {
               if (result.isConfirmed) {
                  toggleLoading(true)

                  fetch('http://monkey_homes_v2/disallowPerson', { 
                     headers: { "Content-Type": "application/json" },
                     method: "POST",
                     body: JSON.stringify({
                        name: casa.homeName,
                        apto: casa.homeApto,
                        idPlayer: user.id
                     })
                  }).then(function() {
                     global.page.data.authorizedPersons.splice(index, 1)

                     Toast.fire({
                        icon: 'success',
                        title: 'Morador removido!'
                     });

                     toggleLoading(false)
                     resolve()
                     
                  }).catch(function() {
                     Toast.fire({
                        icon: 'error',
                        title: 'Erro ao remover!'
                     });

                     toggleLoading(false)
                     reject()
                  });
               }
            })
         } else if (result.isConfirmed) {
            transferHome(casa.homeId, casa.homeApto, user.id)
         }
      })
   })
}

function transferHomeUnknown(homeId, homeApto) {
   Swal.fire({
      icon: 'warning',
      title: 'Vender casa',
      text: 'Informe a identidade',
      input: 'text',
      inputPlaceholder: 'Identidade',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      confirmButtonText: 'Confirmar',
      inputValidator: (value) => {
         if (!$.isNumeric(value)) {
            return 'Identidade inválido!'
         }
      }
   }).then((result) => {
      if (result.isConfirmed) {
         transferHome(homeId, homeApto, parseInt(result.value))
      }
   })
}

function transferHome(homeId, homeApto, idPlayer) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Oferta de transferência',
         text: 'Informe o valor desejado',
         input: 'text',
         inputPlaceholder: 'Valor',
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar',
         inputValidator: (value) => {
            if (!$.isNumeric(value)) {
               return 'Valor inválido!'
            }
         }
      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/transferHome', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: homeId,
                  value: parseInt(result.value),
                  apto: homeApto,
                  idPlayer: idPlayer
               })
            }).then(function(response) {
               return response.json();

            }).then(function(data) {
               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao transferir!',
                     icon: 'error'
                  })
               } else {
                  Toast.fire({
                     title: 'Casa transferida!',
                     icon: 'success'
                  })
               }

               resolve()
               toggleLoading(false)
               
            }).catch(function() {
               Toast.fire({
                  icon: 'error',
                  title: 'Erro ao transferir!'
               });

               reject()
               toggleLoading(false)
            });
         }
      })
   });
}

function configBuyHome(home) {
   Swal.fire({
      icon: 'warning',
      title: 'Forma de pagamento',
      html: '<h5 class="my-0 weight-400 font-20">' +
         '<small class="font-12 text-secondary">Dinheiro</small> <small>$</small>'+ home.homeValue +
         '<small class="mx-1 text-secondary"> | </small> '+ home.homeValueCoins +' <small class="font-12 text-secondary">Coins</small>' +
      '</h5>',
      confirmButtonText: 'Dinheiro',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showDenyButton: true,
      denyButtonText: 'Coins'

   }).then((result) => {
      if (result.isDenied) {
         buyHome(home.homeId, home.homeApto, 'Coins')
         
      } else if (result.isConfirmed) {
         buyHome(home.homeId, home.homeApto, 'Dinheiro')
      }
   });
}

function buyHome(id, apto, type) {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      fetch('http://monkey_homes_v2/buyHome', { 
         headers: { "Content-Type": "application/json" },
         method: "POST",
         body: JSON.stringify({
            id: id,
            apto: apto,
            type: type
         })
      }).then(function(response) {
         return response.json();

      }).then(function(data) {
         if (String(data) == 'erro') {
            Toast.fire({
               title: 'Erro ao comprar!',
               icon: 'error'
            })
         } else {
            Toast.fire({
               title: 'Imóvel comprado!',
               icon: 'success'
            })
         }

         toggleLoading(false)
         resolve()
         
      }).catch(function() {
         Toast.fire({
            icon: 'error',
            title: 'Erro ao comprar!'
         });
         
         toggleLoading(false)
         reject()
      });
   })
}

function unlockHome(casa) {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      fetch('http://monkey_homes_v2/unlockHome', { 
         headers: { "Content-Type": "application/json" },
         method: "POST",
         body: JSON.stringify({
            name: casa.homeName,
            apto: casa.homeApto
         })
      }).then(function() {
         casa.locked = false;
         playSound('doorlock')

         Toast.fire({
            title: 'Porta destrancada!',
            icon: 'success'
         })

         toggleLoading(false)
         resolve()
         
      }).catch(function() {
         Toast.fire({
            title: 'Erro ao destrancar!',
            icon: 'error'
         })

         toggleLoading(false)
         reject()
      });
   });
}

function enterHome(id, apto) {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      fetch('http://monkey_homes_v2/enterHome', { 
         headers: { "Content-Type": "application/json" },
         method: "POST",
         body: JSON.stringify({
            id: id,
            apto: apto
         })
      }).then(function() {
         playSound('enterhouse')
         toggleLoading(false)
         resolve()
         
      }).catch(function() {
         toggleLoading(false)
         reject()
      });
   });
}

function leaveHome(id, apto) {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      fetch('http://monkey_homes_v2/leaveHome', { 
         headers: { "Content-Type": "application/json" },
         method: "POST",
         body: JSON.stringify({
            id: id,
            apto: apto
         })
      }).then(function() {
         toggleLoading(false)
         resolve()
         
      }).catch(function() {
         toggleLoading(false)
         reject()
      });
   });
}

function lockHome(casa) {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      fetch('http://monkey_homes_v2/lockHome', { 
         headers: { "Content-Type": "application/json" },
         method: "POST",
         body: JSON.stringify({
            name: casa.homeName,
            apto: casa.homeApto
         })
      }).then(function() {
         casa.locked = true;
         playSound('doorlock')

         Toast.fire({
            title: 'Porta trancada!',
            icon: 'success'
         })

         toggleLoading(false)
         resolve()
         
      }).catch(function() {
         Toast.fire({
            title: 'Erro ao trancar!',
            icon: 'error'
         })

         toggleLoading(false)
         reject()
      });
   });
}

function payHomeTax(id, apto, iptu) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Pagar IPTU',
         text: 'Valor: $'+ iptu,
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar'

      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/payHomeTax', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id,
                  apto: apto
               })
            }).then(function(response) {
               return response.json();
      
            }).then(function(data) {
               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao pagar!',
                     icon: 'error'
                  })
               } else {
                  global.page.data.expirationDate = data.expirationDate

                  Toast.fire({
                     title: 'IPTU pago!',
                     icon: 'success'
                  })
               }

               toggleLoading(false)
               resolve()
               
            }).catch(function() {
               Toast.fire({
                  title: 'Erro ao pagar!',
                  icon: 'error'
               })

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function upgradeKeys(id, apto, valor) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Melhorar chaves',
         text: 'Valor: $'+ valor,
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar'

      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/upgradeKeys', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id,
                  apto: apto
               })
            }).then(function(response) {
               return response.json();
      
            }).then(function(data) {
               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao melhorar!',
                     icon: 'error'
                  })
               } else {
                  global.page.data.homeKeyAmount = parseInt(data.homeKeyAmount)
                  global.page.data.upgradeKeysValue = parseInt(data.upgradeKeysValue)

                  Toast.fire({
                     title: 'Chaves melhoradas!',
                     icon: 'success'
                  })
               }

               toggleLoading(false)
               resolve()
               
            }).catch(function() {
               Toast.fire({
                  title: 'Erro ao melhorar!',
                  icon: 'error'
               })

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function upgradeChest(id, apto, valor) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Melhorar baú',
         text: 'Valor: $'+ valor,
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar'

      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/upgradeChest', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id,
                  apto: apto
               })
            }).then(function(response) {
               return response.json();
      
            }).then(function(data) {
               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao melhorar!',
                     icon: 'error'
                  })
               } else {
                  global.page.data.homeChestWeight = parseInt(data.homeChestWeight)
                  global.page.data.upgradeChestValue = parseInt(data.upgradeChestValue)

                  Toast.fire({
                     title: 'Baú melhorado!',
                     icon: 'success'
                  })
               }

               toggleLoading(false)
               resolve()
               
            }).catch(function() {
               Toast.fire({
                  title: 'Erro ao melhorar!',
                  icon: 'error'
               })

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function changeInterior(id, apto, interior, valor) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Alterar interior',
         text: 'Valor: $'+ valor,
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar'

      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/changeInterior', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id,
                  apto: apto,
                  interior: interior
               })
            }).then(function(response) {
               return response.json();
      
            }).then(function(data) {
               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao alterar!',
                     icon: 'error'
                  })
               } else {
                  Toast.fire({
                     title: 'Interior alterado!',
                     icon: 'success'
                  })
               }

               toggleLoading(false)
               resolve()
               
            }).catch(function() {
               Toast.fire({
                  title: 'Erro ao alterar!',
                  icon: 'error'
               })

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function authorizePerson(id, apto) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Adicionar morador',
         text: 'Informe a identidade',
         input: 'text',
         inputPlaceholder: 'Identidade',
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar',
         inputValidator: (value) => {
            if (!$.isNumeric(value)) {
               return 'Identidade inválida!'
            }
         }
      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/authorizePerson', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id,
                  apto: apto,
                  idPlayer: parseInt(result.value)
               })
            }).then(function(response) {
               return response.json();

            }).then(function(data) {
               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao adicionar!',
                     icon: 'error'
                  })
               } else {
                  global.page.data.authorizedPersons = data.authorizedPersons

                  Toast.fire({
                     title: 'Morador adicionado!',
                     icon: 'success'
                  })
               }

               toggleLoading(false)
               resolve()
               
            }).catch(function() {
               Toast.fire({
                  icon: 'error',
                  title: 'Erro ao adicionar!'
               });

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function getFurnitures() {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      return fetch('http://monkey_homes_v2/getFurnitures', { method: 'POST' })
      .then(function(response) {
         return response.json();
      })
      .then(function(data) {
         toggleLoading(false)
         resolve(data)

      }).catch(function() {
         toggleLoading(false)
         reject()
      });
   });
}

function getMyFurnitures() {
   return new Promise(function(resolve, reject) {
      toggleLoading(true)

      return fetch('http://monkey_homes_v2/getMyFurnitures', { method: 'POST' })
      .then(function(response) {
         return response.json();
      })
      .then(function(data) {
         toggleLoading(false)
         resolve(data)

      }).catch(function() {
         toggleLoading(false)
         reject()
      });
   });
}

function configBuyFurniture(furniture) {
   Swal.fire({
      icon: 'warning',
      title: 'Forma de pagamento',
      html: '<h5 class="my-0 weight-400 font-20">' +
         '<small class="font-12 text-secondary">Dinheiro</small> <small>$</small>'+ furniture.preco +
         '<small class="mx-1 text-secondary"> | </small> '+ furniture.coins +' <small class="font-12 text-secondary">Coins</small>' +
      '</h5>',
      confirmButtonText: 'Dinheiro',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      showDenyButton: true,
      denyButtonText: 'Coins'

   }).then((result) => {
      if (result.isDenied) {
         buyFurniture(furniture.id, furniture.coins, 'Coins')
         
      } else if (result.isConfirmed) {
         buyFurniture(furniture.id, furniture.preco, 'Dinheiro')
      }
   });
}

function buyFurniture(id, value, type) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Comprar móvel',
         text: 'Valor: $'+ value,
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar'

      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/buyFurniture', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id,
                  type: type
               })
            }).then(function(response) {
               return response.json();
      
            }).then(function(data) {
               toggleLoading(false)

               if (String(data) == 'erro') {
                  Toast.fire({
                     title: 'Erro ao comprar!',
                     icon: 'error'
                  })

                  reject()
                  
               } else {
                  Toast.fire({
                     title: 'Móvel comprado!',
                     icon: 'success'
                  })

                  resolve()
               }
            }).catch(function() {
               Toast.fire({
                  title: 'Erro ao comprar!',
                  icon: 'error'
               })

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function sellFurniture(id) {
   return new Promise(function(resolve, reject) {
      Swal.fire({
         icon: 'warning',
         title: 'Vender móvel?',
         showCancelButton: true,
         cancelButtonText: 'Cancelar',
         confirmButtonText: 'Confirmar'

      }).then((result) => {
         if (result.isConfirmed) {
            toggleLoading(true)

            fetch('http://monkey_homes_v2/sellFurniture', { 
               headers: { "Content-Type": "application/json" },
               method: "POST",
               body: JSON.stringify({
                  id: id
               })
            }).then(function() {
               Toast.fire({
                  title: 'Móvel vendido!',
                  icon: 'success'
               })
               
               toggleLoading(false)
               resolve()

            }).catch(function() {
               Toast.fire({
                  title: 'Erro ao vender!',
                  icon: 'error'
               })

               toggleLoading(false)
               reject()
            });
         }
      });
   });
}

function placeFurniture(id) {
   return new Promise(function(resolve, reject) {
      close()

      fetch('http://monkey_homes_v2/placeFurniture', { 
         headers: { "Content-Type": "application/json" },
         method: "POST",
         body: JSON.stringify({
            id: id
         })
      }).then(function() {
         resolve()

      }).catch(function() {
         Toast.fire({
            title: 'Erro ao colocar!',
            icon: 'error'
         })

         reject()
      });
   });
}

function takeFurniture() {
   return new Promise(function(resolve, reject) {
      close()

      fetch('http://monkey_homes_v2/takeFurniture', { 
         method: "POST"

      }).then(function() {
         resolve()

      }).catch(function() {
         Toast.fire({
            title: 'Erro ao guardar!',
            icon: 'error'
         })

         reject()
      });
   });
}

function viewCommmands() {
   Swal.fire({
      icon: 'info',
      title: 'Comandos',
      html: '<div class="d-block my-3"><a class="text-decoration-none weight-600 text-dark" href="javascript:;">/casas sair</a><br><a class="text-decoration-none weight-400 text-secondary" href="javascript:;">Sair da casa atual</a></div>' +
            '<div class="d-block mb-3"><a class="text-decoration-none weight-600 text-dark" href="javascript:;">/casas list</a><br><a class="text-decoration-none weight-400 text-secondary" href="javascript:;">Mostrar no mapa todas as casas existentes</a></div>' +
            '<div class="d-block mb-3"><a class="text-decoration-none weight-600 text-dark href="javascript:;">/casas moveis</a><br><a class="text-decoration-none weight-400 text-secondary" href="javascript:;">Abrir menu de móveis</a></div>',
      confirmButtonText: 'Fechar'
   })
}

function goToFurnitureMenu() {
   Swal.fire({
      icon: 'warning',
      title: 'Ir para a loja de móveis?',
      showCancelButton: true,
      cancelButtonText: 'Cancelar',
      confirmButtonText: 'Confirmar'

   }).then((result) => {
      if (result.isConfirmed) {
         changePage('Possuídos', 'pages/moveis_jogador.html')
      }
   })
}

function imageError(e) {
   e.target.src = global.errorImg
}
