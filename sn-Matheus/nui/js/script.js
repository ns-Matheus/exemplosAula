Vue.component('lista-item', {
	template: '\
	  <li>\
     {{ title }}\
     <button class="btn btn3 btn-lg btn-danger btn-block" @click="persist()" v-on:click="$emit(\'remove\')">Remove</button>\
     </li>\
	',
	props: ['title']
  })

var app = new Vue({
    el: '#app',
    data:{
       ver: false,
       newListaText: '',
       listas: [
         {
           id: 1,
           title: '',
         }
        ],
        nextListaId: 4
    },


    /* Faz a manipulação do carregamento dos valores armazenados */
    mounted() {
      if (localStorage.newListaText) {
        this.newListaText = localStorage.newListaText;
      }
    },

    methods: {
      persist() {
         localStorage.newListaText = this.newListaText;
      },
   }
   
 })

 function listar() {
   app.listas.push({
     title: app.newListaText
   })
   app.newListaText = ''
  }





 /* Cria um evento Listener */
 document.addEventListener("DOMContentLoaded", function() {
 window.addEventListener("message",(event)=>{

    let data = event.data
 
    if (data.action == true){
       app.ver = true
    }else{
       app.ver = false
    }
 })
})

 
/* Função de sair ao se clicar no botão Sair */

 function sair(){
    app.ver = false
    fetch("http://sn-Matheus/fechar", { method: "POST" })
 }

 