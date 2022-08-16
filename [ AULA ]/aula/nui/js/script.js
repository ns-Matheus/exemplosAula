var app = new Vue({
  el: '#app',
  data: {
    titulo: "Titulo Teste",
    show: false
  }
})


function fechar(){

  fetch("http://aula/fechar", {
    method: "POST",
      body: JSON.stringify({
        titulo: app.titulo
      })
  }).then(function(response) {
    return response.json()
  }).then(function(json) {
    // retorno do objeto do CB
    app.titulo = json.hg
    
  }).catch(function () {   
    // coisas caso der erro
  })

}



$(document).ready(function(){
	window.addEventListener("message",function(event){

    if(event.data.acao == "tela"){
      app.show = event.data.mostrar
    }
		
	});

	
  
  
  
  
  // document.onkeyup = data => {
	// 	if (data["key"] === "Escape"){
			


	// 	}
	// };



});