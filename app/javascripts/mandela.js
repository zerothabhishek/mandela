
const Mandela = { }
Mandela.subs = []

Mandela.subscribe = function (args) {
  let consumer = args.consumer
  let channel = args.channel
  let onConnect = args.onConnect
  let onReceive = args.onReceive
  let onClose = args.onClose
  let wsSocket = null;

  const afterConnect = function (socket) {
    wsSocket = socket
    
    let subRequest = { meta: { type: 'sub', label: channel.label, id: channel.id } }
    socket.send(JSON.stringify(subRequest))

    socket.onmessage = function(event) {
      let data = event.data
      let meta = data.meta

      if (meta == undefined) return
      if (meta.label != channel.label || meta.id != channel.id) return

      let msg = event.data.msg;
      switch (msg) {
        case 'subscription_done':
          onConnect(msg, meta, socket)
          break;

        case 'subscription_closed':
          onClose(msg, meta, socket)
          break;
      
        default:
          onReceive(msg, meta, socket)
          break;
      }
    }
  }

  Mandela.ws_connect(afterConnect)
}

Mandela.subscribe1 = function (label, id, url, onmessageFn) {
  Mandela.socket = new WebSocket(url)

  Mandela.socket.onopen = function () {
    Mandela.socket.send("ping")
    
    var sub_req = { meta: { type: 'sub', label: label, id: id } }
    Mandela.socket.send(JSON.stringify(sub_req))
    Mandela.subs.push([label, id, socket])
  }

  Mandela.socket.onmessage = function (event) {
    console.log(event.data)

    if (event.data.meta) {
      let meta = event.data.meta
      let label = meta.label
      let id = meta.id
      let data = event.data.data

      sub = Mandela.subs.filter( (sub) => { sub[0] == label && sub[1] == id  })[0]
      if (sub) {
        console.log("onmessage: ", sub, data);
        onmessageFn(sub, data, meta)
      }
    }
  }
}
