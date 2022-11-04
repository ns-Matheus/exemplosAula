Vue.component('cabecalho', {
  template: `
  <header>
  <nav class="navbar navbar-expand-md navbar-dark">
  <div class="container-fluid">
    <a class="navbar-brand d-md-none" href="#">
      <h2>Ozaldinho</h2>
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav mx-auto">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="#">Inicio</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Serviços</a>
        </li>
        <a class="navbar-brand d-none d-md-block" href="index.html">
          <h2>Ozaldinho</h2>
        </a>
        <li class="nav-item">
          <a class="nav-link" href="#">Preços</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Contato</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
</header>
  `
})

Vue.component('cookies', {
  template: `
    <div class="container">
        <button type="button" class="btn btn-dark" data-toggle="modal" data-target="#cookieModal">
            See Cookies
        </button>  
    </div>

    <div class="modal fade" id="cookieModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="notice d-flex justify-content-between align-items-center">
                        <div class="cookie-text">
                            This website uses cookies to personalize content and analyse traffic in order to offer you a better experience.
                        </div>
                        <div class="buttons d-flex flex-column flex-lg-row">
                            <a href="#a" class="btn btn-success btn-sm" data-dismiss="modal">I accept</a>
                            <a href="#a" class="btn btn-secondary btn-sm" data-dismiss="modal">Learn More</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    `,
})

Vue.component('rodape', {
  template: `
    <!--FOOTER-->
  //   <section>
  //     <div id="footer-wrapper" class="footer-dark">
  //         <footer id="footer">
  //             <div class="container">
  //                 <div class="row">
  //                     <ul class="col-md-3 col-sm-6 footer-widget-container clearfix">
                          
  //                         <li class="widget widget_newsletterwidget">
  //                             <div class="title">
  //                                 <h3>Institucional</h3>
  //                             </div>

  //                             <p>
  //                                 A J.A.M prioriza ações e processos simples que geram resultados positivos em um curto espaço de tempo. A busca
  //                                 por melhorias e inovações faz com que a equipe se mantenha atualizada e sempre trabalhando para
  //                                 entregar a melhor solução.
  //                             </p>

  //                             <br />

  //                             <!--
  //                             <form class="newsletter">
  //                                 <input class="email" type="email" placeholder="Your email...">
  //                                 <input type="submit" class="submit" value="">
  //                             </form>
  //                             -->
  //                         </li>
  //                     </ul>

  //                     <ul class="col-md-3 col-sm-6 footer-widget-container">
                          
  //                         <li class="widget widget_pages">
  //                             <div class="title">
  //                                 <h3>Recursos</h3>
  //                             </div>
                              
  //                             <ul>
  //                                 <li><a href="sobre">Sobre Nós</a></li>
  //                                 <li><a href="servicos">Nossos Serviços</a></li>
  //                                 <li><a href="contato">Contate-nos</a></li>
  //                             </ul>

  //                         </li>
  //                     </ul>

                      
  //                     <ul class="col-md-3 col-sm-6 footer-widget-container">
                          
  //                         <li class="widget widget_pages">
  //                             <div class="title">
  //                                 <h3>Diretrizes</h3>
  //                             </div>
  //                             <p>
  //                             Atendemos 24 horas de Segunda a Segunda. Nossa prestação de serviço
  //                             segue conforme as diretrizes e o padrão  ANTT.
  //                             </p>
  //                             <p>
  //                             <a href="https://www.antt.net.br/" rel="nofollow" target="_blank"><img src="/App/Assets/img/pics/anttWhite.png" alt="Logo ANTT"/></a>
                              
  //                             </p>
  //                         </li>
  //                     </ul>
                      
  //                     <ul class="col-md-3 col-sm-6 footer-widget-container">
  //                         <li class="widget widget-text">
  //                             <div class="title">
  //                                 <h3>Contatos</h3>
  //                             </div>

  //                             <address>
  //                                 Situado BR 116, N°8171 - Km 99 - Contorno Leste Costeira na cidade de São José dos Pinhais/PR
  //                             </address>

  //                             <span>
  //                                 Telefones: <a href="tel:41-30703140">41-30703140</a> <br> Sandra - <a href="tel:41-9-99662014">41-9-99662014</a> <br> Marcelo - <a href="tel:41-9-96867606">41-9-96867606</a><br>
  //                                 CNPJ: 27.999.250/0001-33
  //                                 Email:<a href="mailto:">jamlogisticaacessoria@gmail.com</a>
  //                                 Email:<a href="mailto:">Jamlicencas@hotmail.com</a> 
  //                             </span>
  //                             <br />
  //                             <ul class="footer-social-icons">
  //                                 <li><a href="https://wa.me/5541996867606?text=Olá%20eu%20vim%20pelo%20site,%20poderiamos%20conversar?" class="fa fa-whatsapp" target="_blank" title="Conversar pelo WhatsApp"></a></li>
  //                             </ul>
  //                         </li>
  //                     </ul>
  //                 </div>
  //             </div>
  //         </footer>
  
          
  //         <!--btn whatsapp-->
  //         <a href="https://wa.me/5541996867606?text=Olá%20eu%20vim%20pelo%20site,%20poderiamos%20conversar?" class="pulse " title="Conversar pelo WhatsApp"
  //             style="position:fixed;width:60px;height:60px;bottom:24px;left:18px;background-color:#25d366;color:#FFF;border-radius:50px;text-align:center;font-size:30px;box-shadow: 1px 1px 2px #888; z-index:1000;"
  //             target="_blank">
  //             <i style="margin-top:16px" class="fa fa-whatsapp"></i>
  //         </a>

  //         <div class="copyright-container">
  //             <div class="container">
  //                 <div class="row">
  //                     <div class="col-md-6">
  //                         <p>&copy;2022 J.A.M Logística & Assessoria em Transporte.</p>
  //                     </div>

                      
  //                     <div class="col-md-6">
  //                         <p class="align-right">Todos os Direitos Reservados</p>
  //                     </div>
  //                 </div>
  //             </div>
  //         </div>
  // </section>

  //           <!-- <a href="#" class="scroll-up" style="margin-bottom: 20px;">Scroll</a> -->
  // </div>
`
})

var app = new Vue({
  el: '#app',
  data: {}
})
