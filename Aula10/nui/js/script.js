var app = new Vue({
  el: "#app",
  data: {
    isActive: true,
    hasError: false
  }
})



function salvar(){
  $.post('http://Aula04/fechar', JSON.stringify({
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