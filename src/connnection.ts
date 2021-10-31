import { ChannelT, MsgMeta, SubscriptionCallbacksT } from './d';
import Subscription from './subscription';

interface ConnectionT {
  url: string | null
  socket: any,
  subs: any, //
  pendingSubs: any
}

const Connection : ConnectionT = {
  url: null,
  socket: null,
  subs: {},
  pendingSubs: {}
}

const keyForSub = (sub: Subscription) => {
  return keyFor(sub.channel.label, sub.channel.id)
}
const keyFor = (label:string, id:string) => {
 return `${label}-${id}`
}

const findSub = (label:string, id:string): Subscription | undefined => {
  const key = keyFor(label, id)
  return Connection.subs[key]
}

const findSubInPending = (label:string, id:string): Subscription | undefined => {
  const key = keyFor(label, id)
  return Connection.pendingSubs[key]
}

const onSubscribe = (msg: object, meta: MsgMeta, socket: any) => {
  const sub = findSubInPending(meta.label, meta.id)

  if (sub) {
    addSub(sub)
    removeFromPending(sub)
    sub.onConnect(msg, meta, socket)
  }
}

const onUnsubscribe = (msg: any, meta: any, socket: any) => {
  // 1. find the subscriptions
  // 2. invoke the disconnected callbacks
  const sub = findSub(meta.label, meta.id)
  if (sub) {
    removeSub(sub)
    sub.onDisconnect(msg, meta, socket)
  }
}

const onMessage = (msg: any, meta: any, socket: any) => {
  // 1. find the subscriptions
  // 2. Invoke in received callbacks
  const sub = findSub(meta.label, meta.id)
  if (sub) {
    sub.onReceive(msg, meta, socket)
  }
}

const messageOnSocket = (dataS: string, socket: any) => {
  const data = JSON.parse(dataS)
  const meta = data.meta
  if (meta == undefined) return;

  const msg = data.msg;
  switch (msg) {
    case 'subscription_done':
      onSubscribe(msg, meta, socket)
      break;

    case 'subscription_closed':
      onUnsubscribe(msg, meta, socket)
      break;
  
    default:
      onMessage(msg, meta, socket)
      break;
  }
}

const connect = (url: string) => {
  const socket = new WebSocket(url)

  socket.onopen = () => {
    console.log("Socket open")
  }

  socket.onmessage = (event) => {
    messageOnSocket(event.data, socket)
  }
  Connection.socket = socket
}

const socket = () => Connection.socket

const addAsPending = (sub: Subscription) => {
  const key = keyForSub(sub)
  Connection.pendingSubs[key] = sub
  return key
}

const removeFromPending = (sub: Subscription) => {
  const key = keyForSub(sub)
  Connection.pendingSubs[key] = undefined
  return key
}

const addSub = (sub: Subscription) => {
  const key = keyForSub(sub)
  Connection.subs[key] = sub
  return key
}

const removeSub = (sub: Subscription) => {
  const key = keyForSub(sub)
  Connection.subs[key] = undefined
  return key
}

const request = (sub: Subscription) => {
  const channel = sub.channel;
  const meta:MsgMeta = { type: 'sub', label: channel.label, id: channel.id }
  socket().send(JSON.stringify({ meta }))
}

const setUrl = (url: string) => {
  Connection.url = url
}

const subscribe = (channel: ChannelT, callbacks: SubscriptionCallbacksT): Subscription => {

  if (Connection.socket == null) {
    if (Connection.url == null) {
      throw("subscribe: URL missing")
    }
    connect(Connection.url)
  }

  const sub = new Subscription(channel, callbacks)
  addAsPending(sub)

  // TODO: find a way to check connection and then back off
  setTimeout(() => {
    request(sub)
  }, 1000)
  
  return sub;
}

// TODO: implement
const unsubscribe = (_channel: ChannelT) => {}

const publish = (channel: ChannelT, msg: object) => {
  const meta:MsgMeta = { label: channel.label, id: channel.id }
  const data = { meta: meta, msg: msg }
  Connection.socket.send(JSON.stringify(data))
}

export default { setUrl, subscribe, unsubscribe, publish }
