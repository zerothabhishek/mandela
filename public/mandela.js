
import Mandela from "../dist/mandela.esm.js";

window.Mandela = Mandela;

Mandela.setUrl("ws://localhost:9292")
Mandela.subscribe({label: 'collab', id: '125'}, {
  connected() {
    console.log("Connected")
  },
  disconnected() {
    console.log("Disconnected")
  },
  received() {
    console.log("received")
  }
})
