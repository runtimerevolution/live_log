import consumer from "./consumer"
console.log("KEKEK")
consumer.subscriptions.create("LiveLogChannel", {
  connected() {
    console.log("KEKEKEEKEKEKEEKEK")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
