var app = new Vue({
   el: '#app',
   data: {
      titulo: "Selecione um modelo de roupa",
      show_vue: false,
      id_outfit: 0,
      nomeOutfit: 0,
      roupaOutfit: 0,
      lista_roupa: [
         { nome: "roupa numero 1" },
         { nome: "roupa numero 2" },
         { nome: "roupa numero 3" },
         { nome: "roupa numero 4" },
         { nome: "roupa numero 5" },
         { nome: "roupa numero 6" },
         { nome: "roupa numero 7" },
         { nome: "roupa numero 8" },
         { nome: "roupa numero 9" },
         { nome: "roupa numero 10" },
         { nome: "roupa numero 11" },
         { nome: "roupa numero 12" },
         { nome: "roupa numero 13" },
         { nome: "roupa numero 14" },
         { nome: "roupa numero 15" },
         { nome: "roupa numero 10" },
         { nome: "roupa numero 11" },
         { nome: "roupa numero 12" },
         { nome: "roupa numero 13" },
         { nome: "roupa numero 14" },
         { nome: "roupa numero 15" },
         { nome: "roupa numero 10" },
         { nome: "roupa numero 11" },
         { nome: "roupa numero 12" },
         { nome: "roupa numero 13" },
         { nome: "roupa numero 14" },
         { nome: "roupa numero 15" },
         { nome: "roupa numero 10" },
         { nome: "roupa numero 11" },
         { nome: "roupa numero 12" },
         { nome: "roupa numero 13" },
         { nome: "roupa numero 14" },
         { nome: "roupa numero 15" },
      ]
   }
})





function sair() {
   $.post('http://monkey_outfit_teste/sair').then(data => {
      app.show_vue = data
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
      confirmButtonColor: 'var(--bgBtnsuccess)',
      cancelButtonText: 'Cancelar',
      canelButtonColor: '#d33',
      showLoaderOnConfirm: true,
      // allowOutsideClick: () => !Swal.isLoading()
   }).then((res) => {
      if (res.isConfirmed) {
         fetch('http://monkey_outfit_teste/addOutfit', {
            method: 'POST',
            body: JSON.stringify({
               outfit_id: app.id_outfit,
               outfit_nome: res.value
            })
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

function delOutfit() {
   Swal.fire({
      title: 'Excluir Blip de Outfit?',
      text: "Após deletado não há como reverter!",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: 'var(--bgBtnsuccess)',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Sim, deletar!',
      cancelButtonText: 'Não, cancelar!',
   }).then((res) => {
      if (res.isConfirmed) {
         $.post('http://monkey_outfit_teste/delOutfit')
         Swal.fire(
            'Deleted!',
            'Outfit deletado com sucesso.',
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

   // swalWithBootstrapButtons.fire({
   //    title: 'Excluir Blip de Outfit?',
   //    text: "Você não poderá reverter está ação!",
   //    icon: 'warning',
   //    showCancelButton: true,
   //    confirmButtonText: 'Sim, deletar!',
   //    cancelButtonText: 'Não, cancelar!',
   //    confirmButtonColor: 'var(--bgBtnInfo)',
   //    cancelButtonColor: '#d33',
   //    reverseButtons: true
   // }).then((result) => {
   //    if (result.isConfirmed) {
   //       $.post('http://monkey_outfit_teste/delOutfit')
   //       swalWithBootstrapButtons.fire(
   //          'Deletado!',
   //          'Blip de Outfit deletado.',
   //          'success'
   //       )
   //    } else if (
   //       result.dismiss === Swal.DismissReason.cancel
   //    ) {
   //       swalWithBootstrapButtons.fire(
   //          'Cancelado',
   //          'Ação cancelada',
   //          'error'
   //       )
   //    }
   // })
}


window.addEventListener("message", (event) => {
   let data = event.data
   if (data.show == true) {
      app.show_vue = true
      app.id_outfit = data.id
   }

   document.onkeyup = (data) => {
      if (data.which == 27) {
         sair()
      }
   }

})

