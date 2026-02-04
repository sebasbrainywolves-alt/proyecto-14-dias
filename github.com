<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Progreso del Proyecto</title>
  <script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-firestore-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-auth-compat.js"></script>
</head>
<body>
  <h1>Progreso del Proyecto 14 Días</h1>

  <div id="login-div">
    <input type="password" id="clave" placeholder="Ingresa tu clave">
    <button onclick="verificarClave()">Entrar</button>
  </div>

  <div id="progreso-div" style="display:none;">
    <ul id="lista-progreso"></ul>
  </div>

<script>
  // --- Tu configuración de Firebase ---
  const firebaseConfig = {
    apiKey: "TU_API_KEY",
    authDomain: "TU_AUTH_DOMAIN",
    projectId: "TU_PROJECT_ID",
    storageBucket: "TU_STORAGE_BUCKET",
    messagingSenderId: "TU_MESSAGING_SENDER_ID",
    appId: "TU_APP_ID"
  };
  firebase.initializeApp(firebaseConfig);
  const db = firebase.firestore();
  const auth = firebase.auth();

  const CLAVE_SECRETA = "MI_CLAVE"; // <-- La clave que compartes

  function verificarClave() {
    const clave = document.getElementById("clave").value;
    if(clave === CLAVE_SECRETA){
      document.getElementById("login-div").style.display = "none";
      document.getElementById("progreso-div").style.display = "block";
      cargarProgreso();
    } else {
      alert("Clave incorrecta");
    }
  }

  function cargarProgreso(){
    // Aquí se lee de Firestore
    db.collection("progreso").get().then((snapshot)=>{
      const lista = document.getElementById("lista-progreso");
      snapshot.forEach(doc => {
        const li = document.createElement("li");
        li.textContent = `${doc.data().dia}: ${doc.data().tarea} - ${doc.data().estado}`;
        lista.appendChild(li);
      });
    });
  }
</script>

</body>
</html>
