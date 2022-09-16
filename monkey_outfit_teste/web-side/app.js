var app = new Vue({
   el: '#app',
   data: {
      titulo: "Selecione um modelo de roupa",
      show_vue: false,
      id_outfit: 0,
      permissoes: [],
      lista_roupa: []
   }
})


window.addEventListener("message", (event) => {
   let data = event.data
   if (data.show == true) {
      app.show_vue = true
      app.id_outfit = data.id
      app.lista_roupa = data.lista
      app.permissoes = []
      data.permissoes.forEach(permissao => {
         app.permissoes.push(permissao.permiss)
      });
   }
   document.onkeyup = (data) => {
      if (data.which == 27) {
         sair()
      }
   }
})


function sair() {
   $.post('http://monkey_outfit_teste/sair').then(data => {
      app.show_vue = data
   })
}


function delOutfitCard(id) {
   $(".fechar").click(() => {
      $('#' + id).fadeOut('slow', () => {
         fetch('http://monkey_outfit_teste/delOutfitCard', {
            method: 'POST',
            body: JSON.stringify({
               outfitCard_id: id
            })
         })
      })
   })
}


function aplicarOutfit(id) {
   fetch('http://monkey_outfit_teste/aplicarOutfit', {
      method: 'POST',
      body: JSON.stringify({
         outfitCard_id: id
      })
   }).then((res) => {
      return res.json()
   }).then(data => {

   }).catch(error => {

   })
}


function addOutfit() {
   Swal.fire({
      title: 'Adicione um nome para seu Outfit',
      input: 'text',
      inputAttributes: {
         autocapitalize: 'off'
      },
      showCancelButton: true,
      confirmButtonText: 'Adicionar',
      confirmButtonColor: 'rgb(41,154,11)',
      cancelButtonText: 'Cancelar',
      cancelButtonColor: 'rgb(255,48,25)',
      showLoaderOnConfirm: true,
   }).then((res) => {
      if (res.isConfirmed) {
         fetch('http://monkey_outfit_teste/addOutfit', {
            method: 'POST',
            body: JSON.stringify({
               outfit_id: app.id_outfit,
               outfit_nome: res.value
            })
         }).then((res) => {
            return res.json()
         }).then(data => {
            app.lista_roupa = data
         }).catch(error => {

         })
         Swal.fire(
            'Sucesso!',
            'Outfit adicionado com sucesso.',
            'success'
         )
      } else if (res.dismiss === Swal.DismissReason.cancel) {
         Swal.fire(
            'Cancelado',
            'Ação cancelada',
            'error'
         )
      }
   })
}


function delOutfitBlip() {
   Swal.fire({
      title: 'Excluir Blip de Outfit?',
      text: "Após deletado não há como reverter!",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Sim, deletar!',
      confirmButtonColor: 'rgb(41,154,11)',
      cancelButtonText: 'Não, cancelar!',
      cancelButtonColor: 'rgb(255,48,25)',
   }).then((res) => {
      if (res.isConfirmed) {
         fetch('http://monkey_outfit_teste/delOutfitBlip', {
            method: 'POST',
            body: JSON.stringify({
               outfit_id: app.id_outfit
            })
         }).then((res) => {
            return res.json()
         }).then(data => {
            app.lista_roupa = data
         }).catch(error => {

         })
         Swal.fire(
            'Deletado!',
            'Blip Outfit deletado com sucesso.',
            'success'
         )
      } else if (res.dismiss === Swal.DismissReason.cancel) {
         Swal.fire(
            'Cancelado',
            'Ação cancelada',
            'error'
         )
      }
   })
}