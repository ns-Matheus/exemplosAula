var app = new Vue({
    el: '#app',
    data: {
      change: 0,
      se: false,
    },
  })
  
  function salvar(){
    $.post('http://Aula02/fechar', JSON.stringify({
      ChangeColor: app.change
    }));
    app.se = false
  }
  
  
  document.addEventListener("DOMContentLoaded", function() {
    window.addEventListener("message",(e)=>{
   
       let data = e.data
    
       if (data.action == true){
          app.se = true
       }else{
          app.se = false
       }
    })
   })