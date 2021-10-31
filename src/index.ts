import type { ChannelT, SubscriptionCallbacksT } from './d';
import Subscription from './subscription';
import connection from './connnection';

const setUrl = (url: string) => {
  connection.setUrl(url)
}

// TODO: use [label, id] instead of channel here 
const subscribe = (channel: ChannelT, callbacks: SubscriptionCallbacksT) : Subscription => {
  const sub = connection.subscribe(channel, callbacks)
  return sub;
}

const unsubscribe = (channel: ChannelT) => {
  connection.unsubscribe(channel)
}

const publish = (channel: ChannelT, msg: object) => {
  connection.publish(channel, msg)
}

const Mandela = { subscribe, unsubscribe, setUrl, publish }

export default Mandela;
