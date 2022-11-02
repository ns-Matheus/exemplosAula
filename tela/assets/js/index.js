Vue.component('corpo', {
  template: `
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
  `
})

var app = new Vue({
  el: '#app',
  data: {}
})
