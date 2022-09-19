var app = new Vue({
   el: '#app',
   data: {
      titulo: "Selecione um modelo de roupa",
      show_vue: false,
      id_outfit: 0,
      id_card: 0,
      permissoes: [],
      lista_roupa: []
   }
})




function sair() {
   $.post('http://monkey_outfit/sair').then(data => {
      app.show_vue = data
   })
}


function delOutfitCard(id) {
   Swal.fire({
      title: 'Deletar este Outfit?',
      text: "Após deletado não há como reverter!",
      icon: 'warning',
      showCancelButton: true,
      background: 'rgb(0, 0, 0, 0.9)',
      color: 'rgb(255,255,255, 0.9)',
      confirmButtonText: 'Sim, deletar!',
      confirmButtonColor: 'rgb(41,154,11)',
      cancelButtonText: 'Não, cancelar!',
      cancelButtonColor: 'rgb(255,48,25)',
   }).then((res) => {
      if (res.isConfirmed) {
         fetch('http://monkey_outfit/delOutfitCard', {
            method: 'POST',
            body: JSON.stringify({
               outfitCard_id: id
            })
         }).then((res) => {
            return res.json()
         }).then(data => {
            app.lista_roupa = data
         })
         Swal.fire({
            title: 'Deletado!',
            text: 'Outfit deletado com sucesso.',
            icon: 'success',
            background: 'rgb(0, 0, 0, 0.9)',
            color: 'rgb(255,255,255, 0.9)'
         })
      } else if (res.dismiss === Swal.DismissReason.cancel) {
         Swal.fire({
            title: 'Cancelado',
            text: "Ação Cancelada!",
            icon: 'error',
            background: 'rgb(0, 0, 0, 0.9)',
            color: 'rgb(255,255,255, 0.9)'
         })
      }
   })
}


function aplicarOutfit(id) {
   fetch('http://monkey_outfit/aplicarOutfit', {
      method: 'POST',
      body: JSON.stringify({
         id_roupa: id
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
      background: 'rgb(0, 0, 0, 0.9)',
      color: 'rgb(255,255,255, 0.9)',
      confirmButtonText: 'Adicionar',
      confirmButtonColor: 'rgb(41,154,11)',
      cancelButtonText: 'Cancelar',
      cancelButtonColor: 'rgb(255,48,25)',
      showLoaderOnConfirm: true,
   }).then((res) => {
      if (res.isConfirmed) {
         fetch('http://monkey_outfit/addOutfit', {
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
         Swal.fire({
            title: 'Sucesso!',
            text: 'Outfit adicionado com sucesso.',
            icon: 'success',
            background: 'rgb(0, 0, 0, 0.9)',
            color: 'rgb(255,255,255, 0.9)'
         })
      } else if (res.dismiss === Swal.DismissReason.cancel) {
         Swal.fire({
            title: 'Cancelado',
            text: "Ação Cancelada!",
            icon: 'error',
            background: 'rgb(0, 0, 0, 0.9)',
            color: 'rgb(255,255,255, 0.9)'
         })
      }
   })
}


function delOutfitBlip() {
   Swal.fire({
      title: 'Excluir Blip de Outfit?',
      text: "Após deletado não há como reverter!",
      icon: 'warning',
      showCancelButton: true,
      background: 'rgb(0, 0, 0, 0.9)',
      color: 'rgb(255,255,255, 0.9)',
      confirmButtonText: 'Sim, deletar!',
      confirmButtonColor: 'rgb(41,154,11)',
      cancelButtonText: 'Não, cancelar!',
      cancelButtonColor: 'rgb(255,48,25)',
   }).then((res) => {
      if (res.isConfirmed) {
         fetch('http://monkey_outfit/delOutfitBlip', {
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
         Swal.fire({
            title: 'Deletado!',
            text: 'Blip Outfit deletado com sucesso.',
            icon: 'success',
            background: 'rgb(0, 0, 0, 0.9)',
            color: 'rgb(255,255,255, 0.9)',
            timer: 1200,
            showConfirmButton: false
         })
         // fire({
         //    title: 'Deletado!',
         //    text: 'Blip Outfit deletado com sucesso.',
         //    icon: 'success',
         //    background: 'rgb(0, 0, 0, 0.9)',
         //    color: 'rgb(255,255,255, 0.9)',
         //    timer: 1000
         // })
         sair()
      } else if (res.dismiss === Swal.DismissReason.cancel) {
         Swal.fire({
            title: 'Cancelado',
            text: "Ação Cancelada!",
            icon: 'error',
            background: 'rgb(0, 0, 0, 0.9)',
            color: 'rgb(255,255,255, 0.9)'
         })
      }
   })
}


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
